{

TRethinkWire: RethinkWire.pas

Copyright 2014 Stijn Sanders
Made available under terms described in file "LICENSE"
https://github.com/stijnsanders/TRethinkWire

}
unit RethinkWire;

{$R-}
{$D-}
{$L-}

interface

uses SysUtils, Classes, SyncObjs, Sockets, ql2;

type
  TRethinkWire=class(TObject)
  private
    FSocket:TTcpClient;
    FData:TMemoryStream;
    FWriteLock,FReadLock:TCriticalSection;
    FAuthKey:UTF8String;
    FNextToken:int64;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(const ServerName:string;Port:integer=28015);
    procedure Close;

    procedure Run(const Request:TQuery; const Response:TResponse);

    property AuthKey:UTF8String read FAuthKey write FAuthKey;
  end;

  ERethinkException=class(Exception);
  ERethinkConnectFailed=class(ERethinkException);
  ERethinkNotConnected=class(ERethinkException);
  ERethinkTransferError=class(ERethinkException);
  ERethinkQueryError=class(ERethinkException);

procedure CheckRes(const Res: TResponse);

function r(b:boolean):TDatum; overload;
function r(d:double):TDatum; overload;
function r(const s:string):TDatum; overload;

function q(const s:string):TTerm; overload;

implementation

uses WinSock;

{ TRethinkWire }

constructor TRethinkWire.Create;
begin
  inherited Create;
  FSocket:=TTcpClient.Create(nil);
  FData:=TMemoryStream.Create;
  FWriteLock:=TCriticalSection.Create;
  FReadLock:=TCriticalSection.Create;
  FAuthKey:='';
  FNextToken:=0;//default, see Open
end;

destructor TRethinkWire.Destroy;
begin
  FSocket.Free;
  FData.Free;
  FWriteLock.Free;
  FReadLock.Free;
  inherited;
end;

procedure TRethinkWire.Open(const ServerName: string; Port: integer);
var
  i,j,l:integer;
  s:UTF8String;
begin
  FWriteLock.Enter;
  try
    //connect
    FSocket.Close;
    FSocket.RemoteHost:=ServerName;
    FSocket.RemotePort:=IntToStr(Port);
    FSocket.Open;
    if not FSocket.Connected then
      raise ERethinkConnectFailed.Create(
        'RethinkWire: failed to connect to "'+ServerName+':'+IntToStr(Port)+'"');
    i:=1;
    l:=4;
    setsockopt(FSocket.Handle,IPPROTO_TCP,TCP_NODELAY,@i,l);

    //authenticate
    FData.Position:=0;
    i:=integer(Version_V0_2);
    FData.Write(i,4);
    i:=Length(FAuthKey);
    FData.Write(i,4);
    FData.Write(FAuthKey[1],i);
    i:=FData.Position;
    if FSocket.SendBuf(FData.Memory^,i)<>i then
     begin
      FSocket.Close;
      raise ERethinkConnectFailed.Create(
        'RethinkWire: failed to authenticate with "'+ServerName+':'+IntToStr(Port)+'"');
     end;

    //process response
    l:=$1000;
    SetLength(s,l);
    i:=1;
    j:=0;
    while (j=0) or (s[j]<>#0) do
     begin
      j:=i;
      inc(i,FSocket.ReceiveBuf(s[i],l-i+1));
      while (j<i) and (s[j]<>#0) do inc(j);
      if j=i then j:=0;
     end;
    SetLength(s,j-1);
    if s<>'SUCCESS' then
     begin
      FSocket.Close;
      raise ERethinkConnectFailed.Create('RethinkWire: '+s);
     end;

    //initial values
    FNextToken:=1;//random? 
  finally
    FWriteLock.Leave;
  end;
end;

procedure TRethinkWire.Close;
begin
  FSocket.Close;
end;

procedure TRethinkWire.Run(const Request: TQuery; const Response: TResponse);
type
  TBArr=array[0..0] of byte;
  PBArr=^TBArr;
var
  i,j,l:integer;
begin
  FWriteLock.Enter;
  try
    //send request
    Request.token:=FNextToken;
    inc(FNextToken);
    FData.Position:=4;
    Request.SaveToStream(FData);
    l:=FData.Position-4;
    FData.Position:=0;
    FData.Write(l,4);
    FData.Position:=0;
    inc(l,4);
    if FSocket.SendBuf(FData.Memory^,l)<>l then
      raise ERethinkTransferError.Create('Rethink: failed to send request');

    //TODO: set socket timeout?
    //TODO: WSAGetLastError

    //receive response
    if FSocket.ReceiveBuf(l,4)<>4 then
      raise ERethinkTransferError.Create('Rethink: failed to receive response');

    if FData.Size<l then FData.Size:=l;
    i:=0;
    while i<l do
     begin
      j:=FSocket.ReceiveBuf(PBArr(FData.Memory)[i],l-i);
      if j<=0 then
        raise ERethinkTransferError.Create('Rethink: failed to receive response');
      inc(i,j);
     end;

    FData.Position:=0;
    Response.LoadFromStream(FData,l);
    
    //TODO: handle responses async (match by token!)
    if Response.token<>Request.token then
      raise ERethinkTransferError.Create('Rethink: token mismatch');

  finally
    FWriteLock.Leave;
  end;
end;

{  }

procedure CheckRes(const Res: TResponse);
var
  s:string;
  i:integer;
begin
  if Res.type_>=ResponseType_CLIENT_ERROR then
   begin
    s:='';
    for i:=0 to Res.responseCount-1 do
     begin
      case Res.response[i].type_ of
        DatumType_R_STR:s:=s+Res.response[i].r_str+' ';
        DatumType_R_NUM:s:=s+FloatToStr(Res.response[i].r_num)+' ';
        //TODO
        else s:=s+'??? ';
      end;
     end;
    raise ERethinkQueryError.Create(Trim(s));
   end;
end;

{ r }

function r(b:boolean):TDatum; overload;
begin
  Result:=TDatum.Create;
  Result.type_:=DatumType_R_BOOL;
  Result.r_bool:=b;
end;

function r(d:double):TDatum; overload;
begin
  Result:=TDatum.Create;
  Result.type_:=DatumType_R_NUM;
  Result.r_num:=d;
end;

function r(const s:string):TDatum; overload;
begin
  Result:=TDatum.Create;
  Result.type_:=DatumType_R_STR;
  Result.r_str:=s;
end;

{ q }

function q(const s:string):TTerm; overload;
begin
  Result:=TTerm.Create;
  Result.type_:=TermType_DATUM;
  Result.datum:=TDatum.Create;
  Result.datum.type_:=DatumType_R_STR;
  Result.datum.r_str:=s;
end;

end.

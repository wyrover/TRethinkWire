unit rdbProxy1;

interface

uses SysUtils, Classes, Sockets;

type
  TRDBProxy=class(TObject)
  private
    srv:TTcpServer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Perform;
  end;

  TPassThrough=class(TThread)
  private
    FIn,FOut:TCustomIpClient;
    FDoAuth:boolean;
    FSuffix:string;
  protected
    procedure Execute; override;
  public
    constructor Create(ConIn,ConOut:TCustomIpClient;DoAuth:boolean;
      const Suffix:string);
    destructor Destroy; override;
  end;

implementation

{ TRDBProxy }

constructor TRDBProxy.Create;
begin
  inherited Create;
  srv:=TTcpServer.Create(nil);
end;

destructor TRDBProxy.Destroy;
begin
  srv.Free;
  inherited;
end;

procedure TRDBProxy.Perform;
var
  c:TCustomIpClient;
  d:TTcpClient;
begin
  srv.BlockMode:=bmBlocking;
  srv.LocalPort:='28015';
  srv.Open;

  while srv.WaitForConnection do
   begin
    c:=TCustomIpClient.Create(nil);
    if srv.Accept(c) then
     begin
      d:=TTcpClient.Create(nil);
      d.BlockMode:=bmBlocking;
      d.RemoteHost:=ParamStr(1);
      d.RemotePort:='28015';
      d.Open;
      TPassThrough.Create(c,d,true,'A');
      TPassThrough.Create(d,c,false,'B');
     end;
   end;

end;

{ TPassThrough }

constructor TPassThrough.Create(ConIn, ConOut: TCustomIpClient;
  DoAuth: boolean; const Suffix: string);
begin
  inherited Create(false);
  FIn:=ConIn;
  FOut:=ConOut;
  FDoAuth:=DoAuth;
  FSuffix:=Suffix;
end;

destructor TPassThrough.Destroy;
begin
  //FIn.Free;//?
  //FOut.Free;//?
  inherited;
end;

procedure TPassThrough.Execute;
const
  BlockSize=$10000;
var
  d:array[0..BlockSize-1] of byte;
  i,j,l,t:integer;
  f:TFileStream;
begin
  if FDoAuth then
   begin
    //client auth request
    l:=FIn.ReceiveBuf(i,4);
    if l<>4 then raise Exception.Create('x');
    //assert i=integer(Version_V0_2);
    FOut.SendBuf(i,4);
    l:=FIn.ReceiveBuf(i,4);
    if l<>4 then raise Exception.Create('x');
    //assert l=4
    FOut.SendBuf(i,4);
    while i<>0 do
     begin
      if i>BlockSize then
        l:=FIn.ReceiveBuf(d[0],BlockSize)
      else
        l:=FIn.ReceiveBuf(d[0],i);
      FOut.SendBuf(d[0],l);
      dec(i,l);
     end;
   end
  else
   begin
    //server auth response
    i:=0;
    j:=-1;
    l:=BlockSize;
    while (j=-1) or (d[j]<>0) do
     begin
      j:=i;
      inc(i,FIn.ReceiveBuf(d[i],l-i+1));
      while (j<i) and (d[j]<>0) do inc(j);
      if j=i then j:=0;
     end;
    FOut.SendBuf(d[0],j+1);
    //check 'SUCCESS'?
   end;

  //catch messages
  t:=0;
  while FOut.Connected and FIn.Connected do
   begin
    inc(t);
    l:=FIn.ReceiveBuf(j,4);
    if l<>4 then raise Exception.Create('x');
    FOut.SendBuf(j,4);
    f:=TFileStream.Create(FormatDateTime('yyyymmdd_hhnnss_zzz_',Now)+
      IntToStr(t)+FSuffix+'.bin',fmCreate or fmShareDenyWrite);
    try
      //f.Size:=j;f.Position:=0;
      while j<>0 do
       begin
        if j>BlockSize then
          l:=FIn.ReceiveBuf(d[0],BlockSize)
        else
          l:=FIn.ReceiveBuf(d[0],j);
        f.Write(d[0],l);
        FOut.SendBuf(d[0],l);
        dec(j,l);
       end;
    finally
      f.Free;
    end;
   end;
end;

end.

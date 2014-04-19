unit ql2;

// ATTENTION:
//   This file was auto generated by dpbp v1.0.1.2
//   https://github.com/stijnsanders/DelphiProtocolBuffer
//
// FLAG: Pn: prepend with parent name
// FLAG: Ef: prepend enumeration field with name

{$D-}
{$L-}

interface

uses Classes, ProtBuf;

type
  TVersion = (
    Version_V0_1 = $3F61BA36,
    Version_V0_2 = $723081E1
  );

  TVersionDummy = class(TProtocolBufferMessage)
  private
  protected
    procedure WriteFields(Stream: TStream); override;
  public
  end;

  TQueryType = (
    QueryType_START = 1,
    QueryType_CONTINUE,
    QueryType_STOP,
    QueryType_NOREPLY_WAIT
  );

  TTerm = class; //forward

  TQuery_AssocPair = class; //forward

  TQuery = class(TProtocolBufferMessage)
  private
    Ftype_: TQueryType;
    Fquery: TTerm;
    Ftoken: int64;
    FOBSOLETE_noreply: boolean;
    Faccepts_r_json: boolean;
    Fglobal_optargs: array of TQuery_AssocPair;
    function Getglobal_optargs(Index: integer): TQuery_AssocPair;
    procedure Setglobal_optargs(Index: integer; Value: TQuery_AssocPair);
    function Getglobal_optargsCount: integer;
  protected
    procedure SetDefaultValues; override;
    procedure ReadVarInt(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property type_: TQueryType read Ftype_ write Ftype_;
    property query: TTerm read Fquery write Fquery;
    property token: int64 read Ftoken write Ftoken;
    property OBSOLETE_noreply: boolean read FOBSOLETE_noreply write FOBSOLETE_noreply;
    property accepts_r_json: boolean read Faccepts_r_json write Faccepts_r_json;
    property global_optargs[Index: integer]: TQuery_AssocPair read Getglobal_optargs write Setglobal_optargs;
    property global_optargsCount: integer read Getglobal_optargsCount;
    procedure Add_global_optargs(Value: TQuery_AssocPair);
  end;

  TQuery_AssocPair = class(TProtocolBufferMessage)
  private
    Fkey: string;
    Fval: TTerm;
  protected
    procedure SetDefaultValues; override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property key: string read Fkey write Fkey;
    property val: TTerm read Fval write Fval;
  end;

  TFrameType = (
    FrameType_POS = 1,
    FrameType_OPT
  );

  TFrame = class(TProtocolBufferMessage)
  private
    Ftype_: TFrameType;
    Fpos: int64;
    Fopt: string;
  protected
    procedure SetDefaultValues; override;
    procedure ReadVarInt(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    property type_: TFrameType read Ftype_ write Ftype_;
    property pos: int64 read Fpos write Fpos;
    property opt: string read Fopt write Fopt;
  end;

  TBacktrace = class(TProtocolBufferMessage)
  private
    Fframes: array of TFrame;
    function Getframes(Index: integer): TFrame;
    procedure Setframes(Index: integer; Value: TFrame);
    function GetframesCount: integer;
  protected
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property frames[Index: integer]: TFrame read Getframes write Setframes;
    property framesCount: integer read GetframesCount;
    procedure Add_frames(Value: TFrame);
  end;

  TResponseType = (
    ResponseType_SUCCESS_ATOM = 1,
    ResponseType_SUCCESS_SEQUENCE,
    ResponseType_SUCCESS_PARTIAL,
    ResponseType_WAIT_COMPLETE,
    ResponseType_CLIENT_ERROR = 16,
    ResponseType_COMPILE_ERROR,
    ResponseType_RUNTIME_ERROR
  );

  TDatum = class; //forward

  TResponse = class(TProtocolBufferMessage)
  private
    Ftype_: TResponseType;
    Ftoken: int64;
    Fresponse: array of TDatum;
    Fbacktrace: TBacktrace;
    Fprofile: TDatum;
    function Getresponse(Index: integer): TDatum;
    procedure Setresponse(Index: integer; Value: TDatum);
    function GetresponseCount: integer;
  protected
    procedure SetDefaultValues; override;
    procedure ReadVarInt(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property type_: TResponseType read Ftype_ write Ftype_;
    property token: int64 read Ftoken write Ftoken;
    property response[Index: integer]: TDatum read Getresponse write Setresponse;
    property responseCount: integer read GetresponseCount;
    procedure Add_response(Value: TDatum);
    property backtrace: TBacktrace read Fbacktrace write Fbacktrace;
    property profile: TDatum read Fprofile write Fprofile;
  end;

  TDatumType = (
    DatumType_R_NULL = 1,
    DatumType_R_BOOL,
    DatumType_R_NUM,
    DatumType_R_STR,
    DatumType_R_ARRAY,
    DatumType_R_OBJECT,
    DatumType_R_JSON
  );

  TDatum_AssocPair = class; //forward

  TDatum = class(TProtocolBufferMessage)
  private
    Ftype_: TDatumType;
    Fr_bool: boolean;
    Fr_num: double;
    Fr_str: string;
    Fr_array: array of TDatum;
    Fr_object: array of TDatum_AssocPair;
    function Getr_array(Index: integer): TDatum;
    procedure Setr_array(Index: integer; Value: TDatum);
    function Getr_arrayCount: integer;
    function Getr_object(Index: integer): TDatum_AssocPair;
    procedure Setr_object(Index: integer; Value: TDatum_AssocPair);
    function Getr_objectCount: integer;
  protected
    procedure SetDefaultValues; override;
    procedure ReadVarInt(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure ReadFixed64(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property type_: TDatumType read Ftype_ write Ftype_;
    property r_bool: boolean read Fr_bool write Fr_bool;
    property r_num: double read Fr_num write Fr_num;
    property r_str: string read Fr_str write Fr_str;
    property r_array[Index: integer]: TDatum read Getr_array write Setr_array;
    property r_arrayCount: integer read Getr_arrayCount;
    procedure Add_r_array(Value: TDatum);
    property r_object[Index: integer]: TDatum_AssocPair read Getr_object write Setr_object;
    property r_objectCount: integer read Getr_objectCount;
    procedure Add_r_object(Value: TDatum_AssocPair);
  end;

  TDatum_AssocPair = class(TProtocolBufferMessage)
  private
    Fkey: string;
    Fval: TDatum;
  protected
    procedure SetDefaultValues; override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property key: string read Fkey write Fkey;
    property val: TDatum read Fval write Fval;
  end;

  TTermType = (
    TermType_DATUM = 1,
    TermType_MAKE_ARRAY,
    TermType_MAKE_OBJ,
    TermType_VAR = 10,
    TermType_JAVASCRIPT,
    TermType_ERROR,
    TermType_IMPLICIT_VAR,
    TermType_DB,
    TermType_TABLE,
    TermType_GET,
    TermType_GET_ALL = 78,
    TermType_EQ = 17,
    TermType_NE,
    TermType_LT,
    TermType_LE,
    TermType_GT,
    TermType_GE,
    TermType_NOT,
    TermType_ADD,
    TermType_SUB,
    TermType_MUL,
    TermType_DIV,
    TermType_MOD,
    TermType_APPEND,
    TermType_PREPEND = 80,
    TermType_DIFFERENCE = 95,
    TermType_SET_INSERT = 88,
    TermType_SET_INTERSECTION,
    TermType_SET_UNION,
    TermType_SET_DIFFERENCE,
    TermType_SLICE = 30,
    TermType_SKIP = 70,
    TermType_LIMIT,
    TermType_INDEXES_OF = 87,
    TermType_CONTAINS = 93,
    TermType_GET_FIELD = 31,
    TermType_KEYS = 94,
    TermType_OBJECT = 143,
    TermType_HAS_FIELDS = 32,
    TermType_WITH_FIELDS = 96,
    TermType_PLUCK = 33,
    TermType_WITHOUT,
    TermType_MERGE,
    TermType_BETWEEN,
    TermType_REDUCE,
    TermType_MAP,
    TermType_FILTER,
    TermType_CONCATMAP,
    TermType_ORDERBY,
    TermType_DISTINCT,
    TermType_COUNT,
    TermType_IS_EMPTY = 86,
    TermType_UNION = 44,
    TermType_NTH,
    TermType_INNER_JOIN = 48,
    TermType_OUTER_JOIN,
    TermType_EQ_JOIN,
    TermType_ZIP = 72,
    TermType_INSERT_AT = 82,
    TermType_DELETE_AT,
    TermType_CHANGE_AT,
    TermType_SPLICE_AT,
    TermType_COERCE_TO = 51,
    TermType_TYPEOF,
    TermType_UPDATE,
    TermType_DELETE,
    TermType_REPLACE,
    TermType_INSERT,
    TermType_DB_CREATE,
    TermType_DB_DROP,
    TermType_DB_LIST,
    TermType_TABLE_CREATE,
    TermType_TABLE_DROP,
    TermType_TABLE_LIST,
    TermType_SYNC = 138,
    TermType_INDEX_CREATE = 75,
    TermType_INDEX_DROP,
    TermType_INDEX_LIST,
    TermType_INDEX_STATUS = 139,
    TermType_INDEX_WAIT,
    TermType_FUNCALL = 64,
    TermType_BRANCH,
    TermType_ANY,
    TermType_ALL,
    TermType_FOREACH,
    TermType_FUNC,
    TermType_ASC = 73,
    TermType_DESC,
    TermType_INFO = 79,
    TermType_MATCH = 97,
    TermType_UPCASE = 141,
    TermType_DOWNCASE,
    TermType_SAMPLE = 81,
    TermType_DEFAULT = 92,
    TermType_JSON = 98,
    TermType_ISO8601,
    TermType_TO_ISO8601,
    TermType_EPOCH_TIME,
    TermType_TO_EPOCH_TIME,
    TermType_NOW,
    TermType_IN_TIMEZONE,
    TermType_DURING,
    TermType_DATE,
    TermType_TIME_OF_DAY = 126,
    TermType_TIMEZONE,
    TermType_YEAR,
    TermType_MONTH,
    TermType_DAY,
    TermType_DAY_OF_WEEK,
    TermType_DAY_OF_YEAR,
    TermType_HOURS,
    TermType_MINUTES,
    TermType_SECONDS,
    TermType_TIME,
    TermType_MONDAY = 107,
    TermType_TUESDAY,
    TermType_WEDNESDAY,
    TermType_THURSDAY,
    TermType_FRIDAY,
    TermType_SATURDAY,
    TermType_SUNDAY,
    TermType_JANUARY,
    TermType_FEBRUARY,
    TermType_MARCH,
    TermType_APRIL,
    TermType_MAY,
    TermType_JUNE,
    TermType_JULY,
    TermType_AUGUST,
    TermType_SEPTEMBER,
    TermType_OCTOBER,
    TermType_NOVEMBER,
    TermType_DECEMBER,
    TermType_LITERAL = 137,
    TermType_GROUP = 144,
    TermType_SUM,
    TermType_AVG,
    TermType_MIN,
    TermType_MAX,
    TermType_SPLIT,
    TermType_UNGROUP
  );

  TTerm_AssocPair = class; //forward

  TTerm = class(TProtocolBufferMessage)
  private
    Ftype_: TTermType;
    Fdatum: TDatum;
    Fargs: array of TTerm;
    Foptargs: array of TTerm_AssocPair;
    function Getargs(Index: integer): TTerm;
    procedure Setargs(Index: integer; Value: TTerm);
    function GetargsCount: integer;
    function Getoptargs(Index: integer): TTerm_AssocPair;
    procedure Setoptargs(Index: integer; Value: TTerm_AssocPair);
    function GetoptargsCount: integer;
  protected
    procedure SetDefaultValues; override;
    procedure ReadVarInt(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property type_: TTermType read Ftype_ write Ftype_;
    property datum: TDatum read Fdatum write Fdatum;
    property args[Index: integer]: TTerm read Getargs write Setargs;
    property argsCount: integer read GetargsCount;
    procedure Add_args(Value: TTerm);
    property optargs[Index: integer]: TTerm_AssocPair read Getoptargs write Setoptargs;
    property optargsCount: integer read GetoptargsCount;
    procedure Add_optargs(Value: TTerm_AssocPair);
  end;

  TTerm_AssocPair = class(TProtocolBufferMessage)
  private
    Fkey: string;
    Fval: TTerm;
  protected
    procedure SetDefaultValues; override;
    procedure ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey); override;
    procedure WriteFields(Stream: TStream); override;
  public
    destructor Destroy; override;
    property key: string read Fkey write Fkey;
    property val: TTerm read Fval write Fval;
  end;

implementation

uses SysUtils;

{ TVersionDummy }

procedure TVersionDummy.WriteFields(Stream: TStream);
begin
end;

{ TQuery }

procedure TQuery.SetDefaultValues;
begin
  Ftype_ := TQueryType(0);
  Fquery := nil;
  Ftoken := 0;
  FOBSOLETE_noreply := false;
  Faccepts_r_json := false;
end;

destructor TQuery.Destroy;
var
  i: integer;
begin
  FreeAndNil(Fquery);
  for i := 0 to Length(Fglobal_optargs)-1 do
    FreeAndNil(Fglobal_optargs[i]);
end;

procedure TQuery.ReadVarInt(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: Ftype_ := TQueryType(ReadEnum(Stream));
    3: ReadUInt(Stream, Ftoken);
    4: FOBSOLETE_noreply := ReadBool(Stream);
    5: Faccepts_r_json := ReadBool(Stream);
  end;
end;

procedure TQuery.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
var
  l: integer;
begin
  case Key of
    2:
      begin
        Fquery:=TTerm.Create;
        ReadMessage(Stream, Fquery);
      end;
    6:
      begin
        l := Length(Fglobal_optargs);
        SetLength(Fglobal_optargs, l+1);
        Fglobal_optargs[l]:=TQuery_AssocPair.Create;
        ReadMessage(Stream, Fglobal_optargs[l]);
      end;
  end;
end;

procedure TQuery.WriteFields(Stream: TStream);
var
  i: integer;
begin
  if Ftype_<>TQueryType(0) then
    WriteUInt(Stream, 1, cardinal(Ftype_));
  if Fquery<>nil then
    WriteMessage(Stream, 2, Fquery);
  if Ftoken<>0 then
    WriteUInt(Stream, 3, Ftoken);
  if FOBSOLETE_noreply then
    WriteUInt(Stream, 4, 1);
  if Faccepts_r_json then
    WriteUInt(Stream, 5, 1);
  for i := 0 to Length(Fglobal_optargs)-1 do
    WriteMessage(Stream, 6, Fglobal_optargs[i]);
end;

function TQuery.Getglobal_optargs(Index: integer): TQuery_AssocPair;
begin
  Result := Fglobal_optargs[Index];
end;

procedure TQuery.Setglobal_optargs(Index: integer; Value: TQuery_AssocPair);
begin
  Fglobal_optargs[Index] := Value;
end;

function TQuery.Getglobal_optargsCount: integer;
begin
  Result := Length(Fglobal_optargs);
end;

procedure TQuery.Add_global_optargs(Value: TQuery_AssocPair);
var
  l: integer;
begin
  l := Length(Fglobal_optargs);
  SetLength(Fglobal_optargs, l+1);
  Fglobal_optargs[l] := Value;
end;

{ TQuery_AssocPair }

procedure TQuery_AssocPair.SetDefaultValues;
begin
  Fval := nil;
end;

destructor TQuery_AssocPair.Destroy;
begin
  FreeAndNil(Fval);
end;

procedure TQuery_AssocPair.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: ReadStr(Stream, Fkey);
    2:
      begin
        Fval:=TTerm.Create;
        ReadMessage(Stream, Fval);
      end;
  end;
end;

procedure TQuery_AssocPair.WriteFields(Stream: TStream);
begin
  WriteStr(Stream, 1, Fkey);
  if Fval<>nil then
    WriteMessage(Stream, 2, Fval);
end;

{ TFrame }

procedure TFrame.SetDefaultValues;
begin
  Ftype_ := TFrameType(0);
  Fpos := 0;
end;

procedure TFrame.ReadVarInt(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: Ftype_ := TFrameType(ReadEnum(Stream));
    2: ReadUInt(Stream, Fpos);
  end;
end;

procedure TFrame.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    3: ReadStr(Stream, Fopt);
  end;
end;

procedure TFrame.WriteFields(Stream: TStream);
begin
  if Ftype_<>TFrameType(0) then
    WriteUInt(Stream, 1, cardinal(Ftype_));
  if Fpos<>0 then
    WriteUInt(Stream, 2, Fpos);
  WriteStr(Stream, 3, Fopt);
end;

{ TBacktrace }

destructor TBacktrace.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(Fframes)-1 do
    FreeAndNil(Fframes[i]);
end;

procedure TBacktrace.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
var
  l: integer;
begin
  case Key of
    1:
      begin
        l := Length(Fframes);
        SetLength(Fframes, l+1);
        Fframes[l]:=TFrame.Create;
        ReadMessage(Stream, Fframes[l]);
      end;
  end;
end;

procedure TBacktrace.WriteFields(Stream: TStream);
var
  i: integer;
begin
  for i := 0 to Length(Fframes)-1 do
    WriteMessage(Stream, 1, Fframes[i]);
end;

function TBacktrace.Getframes(Index: integer): TFrame;
begin
  Result := Fframes[Index];
end;

procedure TBacktrace.Setframes(Index: integer; Value: TFrame);
begin
  Fframes[Index] := Value;
end;

function TBacktrace.GetframesCount: integer;
begin
  Result := Length(Fframes);
end;

procedure TBacktrace.Add_frames(Value: TFrame);
var
  l: integer;
begin
  l := Length(Fframes);
  SetLength(Fframes, l+1);
  Fframes[l] := Value;
end;

{ TResponse }

procedure TResponse.SetDefaultValues;
begin
  Ftype_ := TResponseType(0);
  Ftoken := 0;
  Fbacktrace := nil;
  Fprofile := nil;
end;

destructor TResponse.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(Fresponse)-1 do
    FreeAndNil(Fresponse[i]);
  FreeAndNil(Fbacktrace);
  FreeAndNil(Fprofile);
end;

procedure TResponse.ReadVarInt(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: Ftype_ := TResponseType(ReadEnum(Stream));
    2: ReadUInt(Stream, Ftoken);
  end;
end;

procedure TResponse.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
var
  l: integer;
begin
  case Key of
    3:
      begin
        l := Length(Fresponse);
        SetLength(Fresponse, l+1);
        Fresponse[l]:=TDatum.Create;
        ReadMessage(Stream, Fresponse[l]);
      end;
    4:
      begin
        Fbacktrace:=TBacktrace.Create;
        ReadMessage(Stream, Fbacktrace);
      end;
    5:
      begin
        Fprofile:=TDatum.Create;
        ReadMessage(Stream, Fprofile);
      end;
  end;
end;

procedure TResponse.WriteFields(Stream: TStream);
var
  i: integer;
begin
  if Ftype_<>TResponseType(0) then
    WriteUInt(Stream, 1, cardinal(Ftype_));
  if Ftoken<>0 then
    WriteUInt(Stream, 2, Ftoken);
  for i := 0 to Length(Fresponse)-1 do
    WriteMessage(Stream, 3, Fresponse[i]);
  if Fbacktrace<>nil then
    WriteMessage(Stream, 4, Fbacktrace);
  if Fprofile<>nil then
    WriteMessage(Stream, 5, Fprofile);
end;

function TResponse.Getresponse(Index: integer): TDatum;
begin
  Result := Fresponse[Index];
end;

procedure TResponse.Setresponse(Index: integer; Value: TDatum);
begin
  Fresponse[Index] := Value;
end;

function TResponse.GetresponseCount: integer;
begin
  Result := Length(Fresponse);
end;

procedure TResponse.Add_response(Value: TDatum);
var
  l: integer;
begin
  l := Length(Fresponse);
  SetLength(Fresponse, l+1);
  Fresponse[l] := Value;
end;

{ TDatum }

procedure TDatum.SetDefaultValues;
begin
  Ftype_ := TDatumType(0);
  Fr_bool := false;
  Fr_num := 0.0;
end;

destructor TDatum.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(Fr_array)-1 do
    FreeAndNil(Fr_array[i]);
  for i := 0 to Length(Fr_object)-1 do
    FreeAndNil(Fr_object[i]);
end;

procedure TDatum.ReadVarInt(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: Ftype_ := TDatumType(ReadEnum(Stream));
    2: Fr_bool := ReadBool(Stream);
  end;
end;

procedure TDatum.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
var
  l: integer;
begin
  case Key of
    4: ReadStr(Stream, Fr_str);
    5:
      begin
        l := Length(Fr_array);
        SetLength(Fr_array, l+1);
        Fr_array[l]:=TDatum.Create;
        ReadMessage(Stream, Fr_array[l]);
      end;
    6:
      begin
        l := Length(Fr_object);
        SetLength(Fr_object, l+1);
        Fr_object[l]:=TDatum_AssocPair.Create;
        ReadMessage(Stream, Fr_object[l]);
      end;
  end;
end;

procedure TDatum.ReadFixed64(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    3: ReadBlock(Stream, Fr_num, 8);
  end;
end;

procedure TDatum.WriteFields(Stream: TStream);
var
  i: integer;
begin
  if Ftype_<>TDatumType(0) then
    WriteUInt(Stream, 1, cardinal(Ftype_));
  if Fr_bool then
    WriteUInt(Stream, 2, 1);
  if Fr_num<>0.0 then
    WriteBlock(Stream, 3, Fr_num, 8);
  WriteStr(Stream, 4, Fr_str);
  for i := 0 to Length(Fr_array)-1 do
    WriteMessage(Stream, 5, Fr_array[i]);
  for i := 0 to Length(Fr_object)-1 do
    WriteMessage(Stream, 6, Fr_object[i]);
end;

function TDatum.Getr_array(Index: integer): TDatum;
begin
  Result := Fr_array[Index];
end;

procedure TDatum.Setr_array(Index: integer; Value: TDatum);
begin
  Fr_array[Index] := Value;
end;

function TDatum.Getr_arrayCount: integer;
begin
  Result := Length(Fr_array);
end;

procedure TDatum.Add_r_array(Value: TDatum);
var
  l: integer;
begin
  l := Length(Fr_array);
  SetLength(Fr_array, l+1);
  Fr_array[l] := Value;
end;

function TDatum.Getr_object(Index: integer): TDatum_AssocPair;
begin
  Result := Fr_object[Index];
end;

procedure TDatum.Setr_object(Index: integer; Value: TDatum_AssocPair);
begin
  Fr_object[Index] := Value;
end;

function TDatum.Getr_objectCount: integer;
begin
  Result := Length(Fr_object);
end;

procedure TDatum.Add_r_object(Value: TDatum_AssocPair);
var
  l: integer;
begin
  l := Length(Fr_object);
  SetLength(Fr_object, l+1);
  Fr_object[l] := Value;
end;

{ TDatum_AssocPair }

procedure TDatum_AssocPair.SetDefaultValues;
begin
  Fval := nil;
end;

destructor TDatum_AssocPair.Destroy;
begin
  FreeAndNil(Fval);
end;

procedure TDatum_AssocPair.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: ReadStr(Stream, Fkey);
    2:
      begin
        Fval:=TDatum.Create;
        ReadMessage(Stream, Fval);
      end;
  end;
end;

procedure TDatum_AssocPair.WriteFields(Stream: TStream);
begin
  WriteStr(Stream, 1, Fkey);
  if Fval<>nil then
    WriteMessage(Stream, 2, Fval);
end;

{ TTerm }

procedure TTerm.SetDefaultValues;
begin
  Ftype_ := TTermType(0);
  Fdatum := nil;
end;

destructor TTerm.Destroy;
var
  i: integer;
begin
  FreeAndNil(Fdatum);
  for i := 0 to Length(Fargs)-1 do
    FreeAndNil(Fargs[i]);
  for i := 0 to Length(Foptargs)-1 do
    FreeAndNil(Foptargs[i]);
end;

procedure TTerm.ReadVarInt(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: Ftype_ := TTermType(ReadEnum(Stream));
  end;
end;

procedure TTerm.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
var
  l: integer;
begin
  case Key of
    2:
      begin
        Fdatum:=TDatum.Create;
        ReadMessage(Stream, Fdatum);
      end;
    3:
      begin
        l := Length(Fargs);
        SetLength(Fargs, l+1);
        Fargs[l]:=TTerm.Create;
        ReadMessage(Stream, Fargs[l]);
      end;
    4:
      begin
        l := Length(Foptargs);
        SetLength(Foptargs, l+1);
        Foptargs[l]:=TTerm_AssocPair.Create;
        ReadMessage(Stream, Foptargs[l]);
      end;
  end;
end;

procedure TTerm.WriteFields(Stream: TStream);
var
  i: integer;
begin
  if Ftype_<>TTermType(0) then
    WriteUInt(Stream, 1, cardinal(Ftype_));
  if Fdatum<>nil then
    WriteMessage(Stream, 2, Fdatum);
  for i := 0 to Length(Fargs)-1 do
    WriteMessage(Stream, 3, Fargs[i]);
  for i := 0 to Length(Foptargs)-1 do
    WriteMessage(Stream, 4, Foptargs[i]);
end;

function TTerm.Getargs(Index: integer): TTerm;
begin
  Result := Fargs[Index];
end;

procedure TTerm.Setargs(Index: integer; Value: TTerm);
begin
  Fargs[Index] := Value;
end;

function TTerm.GetargsCount: integer;
begin
  Result := Length(Fargs);
end;

procedure TTerm.Add_args(Value: TTerm);
var
  l: integer;
begin
  l := Length(Fargs);
  SetLength(Fargs, l+1);
  Fargs[l] := Value;
end;

function TTerm.Getoptargs(Index: integer): TTerm_AssocPair;
begin
  Result := Foptargs[Index];
end;

procedure TTerm.Setoptargs(Index: integer; Value: TTerm_AssocPair);
begin
  Foptargs[Index] := Value;
end;

function TTerm.GetoptargsCount: integer;
begin
  Result := Length(Foptargs);
end;

procedure TTerm.Add_optargs(Value: TTerm_AssocPair);
var
  l: integer;
begin
  l := Length(Foptargs);
  SetLength(Foptargs, l+1);
  Foptargs[l] := Value;
end;

{ TTerm_AssocPair }

procedure TTerm_AssocPair.SetDefaultValues;
begin
  Fval := nil;
end;

destructor TTerm_AssocPair.Destroy;
begin
  FreeAndNil(Fval);
end;

procedure TTerm_AssocPair.ReadLengthDelim(Stream: TStream; Key: TProtocolBufferKey);
begin
  case Key of
    1: ReadStr(Stream, Fkey);
    2:
      begin
        Fval:=TTerm.Create;
        ReadMessage(Stream, Fval);
      end;
  end;
end;

procedure TTerm_AssocPair.WriteFields(Stream: TStream);
begin
  WriteStr(Stream, 1, Fkey);
  if Fval<>nil then
    WriteMessage(Stream, 2, Fval);
end;

end.

unit API.Base64;

interface

uses

  System.Classes     // Used for [TMemoryStream as Pictures]
, API.Types          // Used for [TBase_Bitmap (Vcl or Fmx)]
;

type

  TStaticBase64Picture = class
  private
  public
    class procedure Decode(const aInput: TMemoryStream; aResultPic: TFinalPicture); static;
    class function Encode(const aInput: TMemoryStream): string; overload; static;
    class function Encode(const aPicture: TFinalPicture): string; overload; static;
  end;

  I_Base64Picture = interface ['{3CF67E4A-F377-4CDA-B3D1-F4580D2DE363}']

    procedure Decode(const aInput: TMemoryStream; aResultPic: TFinalPicture);
    function Encode(const aInput: TMemoryStream): string; overload;
    function Encode(const aPicture: TFinalPicture): string; overload;
  end;

  function GetTBase64Picture: I_Base64Picture;

implementation

uses
  System.NetEncoding  // Used for [TNetEncoding.Base64]
, System.SysUtils     // Used for [Exception]
;

{ TStaticBase64Picture<aInput> }

class procedure TStaticBase64Picture.Decode(const aInput: TMemoryStream; aResultPic: TFinalPicture);
var
  LOutput: TMemoryStream;
  LPic: TFinalPicture;
begin
  LOutput := TMemoryStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Decode(aInput, LOutput);
    LOutput.Position := 0;
    {$IF Defined(FRAMEWORK_FMX)}
    LPic := TFinalPicture.Get_Result(200, 100);
    {$ELSE}
    LPic := TFinalPicture.Get_Result;
    {$ENDIF}
    try
      LPic.LoadFromStream(LOutput);
    except on Ex: Exception do
      raise Exception.Create('Error: '+ Ex.Message);
    end;

    TFinalPicture(aResultPic).Assign(LPic);
  finally
    LOutput.Free;
    FreeAndNil(LPic);
  end;
end;

class function TStaticBase64Picture.Encode(const aInput: TMemoryStream): string;
var
  LOutput: TStringStream;
begin
  LOutput := TStringStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Encode(aInput, LOutput);
    LOutput.Position := 0;

    Result := LOutput.DataString;
  finally
    LOutput.Free;
  end;
end;

class function TStaticBase64Picture.Encode(
  const aPicture: TFinalPicture): string;
var
  LSrcStream: TMemoryStream;
begin
  LSrcStream := TMemoryStream.Create;
  try
    aPicture.SaveToStream(LSrcStream);
    LSrcStream.Position := 0;

    Result :=  Encode(LSrcStream);
    LSrcStream.Clear;
  finally
    FreeAndNil(LSrcStream);
  end;
end;

type
  TBase64Picture = class(TInterfacedObject, I_Base64Picture)
  strict private
  private
    procedure Decode(const aInput: TMemoryStream; aResultPic: TFinalPicture);
    function Encode(const aInput: TMemoryStream): string; overload;
    function Encode(const aPicture: TFinalPicture): string; overload;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function GetTBase64Picture: I_Base64Picture; begin

  Result := TBase64Picture.Create;
end;


{ TBase64Picture }

{$REGION '  [constructor||destructor] ..'}
constructor TBase64Picture.Create;
begin
end;

destructor TBase64Picture.Destroy;
begin inherited;
end;
{$ENDREGION}

procedure TBase64Picture.Decode(const aInput: TMemoryStream; aResultPic: TFinalPicture);
var
  LOutput: TMemoryStream;
  LPic: TFinalPicture;
begin
  LOutput := TMemoryStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Decode(aInput, LOutput);
    LOutput.Position := 0;
    {$IF Defined(FRAMEWORK_FMX)}
    LPic := TFinalPicture.Get_Result(200, 100);
    {$ELSE}
    LPic := TFinalPicture.Get_Result;
    {$ENDIF}
    try
      LPic.LoadFromStream(LOutput);
    except on Ex: Exception do
      raise Exception.Create('Error: '+ Ex.Message);
    end;

    aResultPic.Assign(LPic);
  finally
    LOutput.Free;
    FreeAndNil(LPic)
  end;
end;

function TBase64Picture.Encode(const aInput: TMemoryStream): string;
var
  LOutput: TStringStream;
begin
  LOutput := TStringStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Encode(aInput, LOutput);
    LOutput.Position := 0;

    Result := LOutput.DataString;
  finally
    LOutput.Free;
  end;
end;

function TBase64Picture.Encode(const aPicture: TFinalPicture): string;
var
  LSrcStream: TMemoryStream;
begin
  LSrcStream := TMemoryStream.Create;
  try
    aPicture.SaveToStream(LSrcStream);
    LSrcStream.Position := 0;

    Result :=  Encode(LSrcStream);
    LSrcStream.Clear;
  finally
    FreeAndNil(LSrcStream);
  end;
end;

end.

unit API.Base64;

interface

uses

  System.Classes     // Used for [TMemoryStream as Pictures]
, API.Types          // Used for [TBase_Bitmap (Vcl or Fmx)]
;

type
  TStatic_Base64_Picture = class
  private
  public
    class function Decode(const aInput: TMemoryStream): TFinal_Picture; static;
    class function Encode(const aInput: TMemoryStream): string; static;
  end;

  I_Base64_Picture = interface ['{3CF67E4A-F377-4CDA-B3D1-F4580D2DE363}']

    function Decode(const aInput: TMemoryStream): TFinal_Picture;
    function Encode(const aInput: TMemoryStream): string;
  end;

  function Get_TBase64_Picture: I_Base64_Picture;

implementation

uses
  System.NetEncoding  // Used for [TNetEncoding.Base64]
, System.SysUtils     // Used for [Exception]
;

{ TStatic_Base64_Picture<aInput> }

class function TStatic_Base64_Picture.Decode(const aInput: TMemoryStream): TFinal_Picture;
var
  L_Output: TMemoryStream;
  L_Pic: TFinal_Picture;
begin
  L_Output := TMemoryStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Decode(aInput, L_Output);
    L_Output.Position := 0;
    {$IF Defined(FRAMEWORK_FMX)}
    L_Pic := TFinal_Picture.Get_Result(200, 100);
    {$ELSE}
    L_Pic := TFinal_Picture.Get_Result;
    {$ENDIF}
    try
      L_Pic.LoadFromStream(L_Output);
    except on Ex: Exception do
      raise Exception.Create('Error: '+ Ex.Message);
    end;

  finally
    L_Output.Free;
  end;

  Result := L_Pic;
end;

class function TStatic_Base64_Picture.Encode(const aInput: TMemoryStream): string;
var
  L_Output: TStringStream;
begin
  L_Output := TStringStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Encode(aInput, L_Output);
    L_Output.Position := 0;

    Result := L_Output.DataString;
  finally
    L_Output.Free;
  end;
end;


type
  TBase64_Picture = class(TInterfacedObject, I_Base64_Picture)
  strict private
  private
    function Decode(const aInput: TMemoryStream): TFinal_Picture;
    function Encode(const aInput: TMemoryStream): string;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function Get_TBase64_Picture: I_Base64_Picture; begin

  Result := TBase64_Picture.Create;
end;


{ TBase64_Picture }

{$REGION '  [constructor||destructor] ..'}
constructor TBase64_Picture.Create;
begin
end;

destructor TBase64_Picture.Destroy;
begin inherited;
end;
{$ENDREGION}

function TBase64_Picture.Decode(const aInput: TMemoryStream): TFinal_Picture;
var
  L_Output: TMemoryStream;
  L_Pic: TFinal_Picture;
begin
  L_Output := TMemoryStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Decode(aInput, L_Output);
    L_Output.Position := 0;
    {$IF Defined(FRAMEWORK_FMX)}
    L_Pic := TFinal_Picture.Get_Result(200, 100);
    {$ELSE}
    L_Pic := TFinal_Picture.Get_Result;
    {$ENDIF}
    try
      L_Pic.LoadFromStream(L_Output);
    except on Ex: Exception do
      raise Exception.Create('Error: '+ Ex.Message);
    end;

  finally
    L_Output.Free;
  end;

  Result := L_Pic;
end;

function TBase64_Picture.Encode(const aInput: TMemoryStream): string;
var
  L_Output: TStringStream;
begin
  L_Output := TStringStream.Create;
  try
    aInput.Position := 0;

    TNetEncoding.Base64.Encode(aInput, L_Output);
    L_Output.Position := 0;

    Result := L_Output.DataString;
  finally
    L_Output.Free;
  end;
end;

end.

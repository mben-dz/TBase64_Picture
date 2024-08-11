unit API.Types;

interface

uses

{$IF Defined(FRAMEWORK_FMX)}
  FMX.Graphics;
{$ELSEIF Defined(FRAMEWORK_VCL)}
  Vcl.Graphics;
{$ELSE}
  {$MESSAGE ERROR 'No framework defined'}
{$ENDIF}

type
  TFinalPicture = class;

  {$IF Defined(FRAMEWORK_FMX)}
  TBitmapFmxHelper = class helper for FMX.Graphics.TBitmap
  public
    function ToFinalPicture: TFinalPicture;
  end;
  {$ELSEIF Defined(FRAMEWORK_VCL)}
  TPictureHelper = class helper for Vcl.Graphics.TPicture
  public
    function ToFinalPicture: TFinalPicture;
  end;
  {$ENDIF}

  TFinalPicture = class(
    {$IF Defined(FRAMEWORK_FMX)}
      FMX.Graphics.TBitmap)
    {$ELSE}
      Vcl.Graphics.TPicture)
    {$ENDIF}
  public
    class function Get_Result: TFinalPicture; overload; static;
  {$IF Defined(FRAMEWORK_FMX)}
    class function Get_Result(aWidth, aHeight: Integer): TFinalPicture; overload; static;
  {$ENDIF}
  end;

  TFinalPictureMETA = class of TFinalPicture;

implementation

uses
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage;

{ TBase_Bitmap }

class function TFinalPicture.Get_Result: TFinalPicture;
begin
  Result := TFinalPicture.Create;
end;

{$IF Defined(FRAMEWORK_FMX)}
class function TFinalPicture.Get_Result(aWidth, aHeight: Integer): TFinalPicture;
begin

    Result := TFinalPicture.Create(aWidth, aHeight);
end;
{$ENDIF}

{$IF Defined(FRAMEWORK_FMX)}

{ TBitmapFmxHelper }

function TBitmapFmxHelper.ToFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture(Self);
end;
{$ELSEIF Defined(FRAMEWORK_VCL)}

{ TPictureHelper }

function TPictureHelper.ToFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture(Self);
end;
{$ENDIF}

end.

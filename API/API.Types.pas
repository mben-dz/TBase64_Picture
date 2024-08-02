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
  TFinal_Picture = class(
    {$IF Defined(FRAMEWORK_FMX)}
      FMX.Graphics.TBitmap)
    {$ELSE}
      Vcl.Graphics.TPicture)
    {$ENDIF}
  public
    class function Get_Result: TFinal_Picture; overload; static;
  {$IF Defined(FRAMEWORK_FMX)}
    class function Get_Result(aWidth, aHeight: Integer): TFinal_Picture; overload; static;
  {$ENDIF}
  end;

  TFinal_PictureMETA = class of TFinal_Picture;

implementation

{ TBase_Bitmap }

class function TFinal_Picture.Get_Result: TFinal_Picture;
begin
  Result := TFinal_Picture.Create;
end;

{$IF Defined(FRAMEWORK_FMX)}
class function TFinal_Picture.Get_Result(aWidth, aHeight: Integer): TFinal_Picture;
begin

    Result := TFinal_Picture.Create(aWidth, aHeight);
end;
{$ENDIF}

end.

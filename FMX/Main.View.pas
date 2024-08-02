unit Main.View;

interface

uses
{$REGION '  Import: System''s ...'}
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
{$ENDREGION}
{$REGION '  Import: FMX''s ...'}
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Memo.Types,
  FMX.Objects,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.StdCtrls
{$ENDREGION}
, API.Base64
;

type
  TMainView = class(TForm)

  {$REGION '  Components .. '}
    Pnl_Title: TPanel;
    Lyt_Main: TLayout;
    Pnl_Status: TPanel;
    Memo_Base64: TMemo;
    Btn_LoadPicture: TButton;
    Btn_Encode: TButton;
    Btn_Decode: TButton;
    Img_Src: TImage;
    Btn_SavePicture: TButton;
    Txt_Title: TText;
    OpenDlg_Picture: TOpenDialog;
    SaveDialog_Picture: TSaveDialog;
    Txt_Status: TText;
  {$ENDREGION}
    procedure Btn_LoadPictureClick(Sender: TObject);
    procedure Btn_SavePictureClick(Sender: TObject);
    procedure Btn_EncodeClick(Sender: TObject);
    procedure Btn_DecodeClick(Sender: TObject);
    procedure Memo_Base64ChangeTracking(Sender: TObject);
  private
    fBase64_Picture: I_Base64_Picture;
    fMemoStream: TMemoryStream;
  {$REGION '  [Getters||Setters] .. '}
    function Get_Base64_Picture: I_Base64_Picture;
    function Get_Memo: string; procedure Set_Memo(const aValue: string);
    function Get_MemoStream: TMemoryStream;
    function Get_LogStatus(const aValue: string = ''): string;
  {$ENDREGION}
    procedure Clear_MemoStream;
    procedure OnPicture_Changed;
  public
    property Base64: I_Base64_Picture read Get_Base64_Picture;
    property Memo: string read Get_Memo write Set_Memo;
    property MemoStream: TMemoryStream read Get_MemoStream;
    property LogStatus[const aValue: string = '']: string Read Get_LogStatus;
  end;

implementation

{$R *.fmx}

{ TMainView }

{$REGION '  [Getters||Setters] .. '}
function TMainView.Get_Base64_Picture: I_Base64_Picture;
begin
  if not Assigned(fBase64_Picture) then
    fBase64_Picture := Get_TBase64_Picture;

  Result := fBase64_Picture;
end;

function TMainView.Get_Memo: string;
begin
  Result := Memo_Base64.Lines.Text;
end;

procedure TMainView.Set_Memo(const aValue: string);
begin
  if aValue.IsEmpty then
    Memo_Base64.Lines.Clear
  else
    Memo_Base64.Lines.Text := aValue;
end;

function TMainView.Get_MemoStream: TMemoryStream;
begin
  fMemoStream := TMemoryStream.Create;
  try
    Memo_Base64.Lines.SaveToStream(fMemoStream);
  finally
    Result := fMemoStream;
  end;
end;

function TMainView.Get_LogStatus(const aValue: string): string;
begin
  if not(aValue.IsEmpty) then
    Txt_Status.Text := '   ' +aValue;

  Result := Txt_Status.Text;
end;
{$ENDREGION}

procedure TMainView.Clear_MemoStream;
begin
  fMemoStream.Clear;
  FreeAndNil(fMemoStream);
end;

procedure TMainView.Memo_Base64ChangeTracking(Sender: TObject);
begin
  Btn_Decode.Enabled := not Memo.IsEmpty;
end;

procedure TMainView.OnPicture_Changed;
begin
  Btn_SavePicture.Enabled := not Img_Src.Bitmap.IsEmpty;
  Btn_Encode.Enabled := not Img_Src.Bitmap.IsEmpty;
end;

procedure TMainView.Btn_DecodeClick(Sender: TObject);
var
  L_Pic: TBitmap;
begin
  L_Pic := TStatic_Base64_Picture.Decode(MemoStream);
  try
    Img_Src.Bitmap.Assign(L_Pic);
    OnPicture_Changed;
  finally
    Clear_MemoStream;
    L_Pic.Free;
  end;
end;

procedure TMainView.Btn_EncodeClick(Sender: TObject);
var
  L_Src_Stream: TMemoryStream;
begin
  L_Src_Stream := TMemoryStream.Create;
  try
    Img_Src.Bitmap.SaveToStream(L_Src_Stream);
    L_Src_Stream.Position := 0;

    Memo := Base64.Encode(L_Src_Stream);
  finally
    L_Src_Stream.Free;
  end;
end;

procedure TMainView.Btn_LoadPictureClick(Sender: TObject);
begin
  OpenDlg_Picture.InitialDir := ExtractFileDir(ParamStr(0));
  if OpenDlg_Picture.Execute then
  begin
    Img_Src.Bitmap.LoadFromFile(OpenDlg_Picture.FileName);
    OnPicture_Changed;
    LogStatus['Picture Loaded Successfully ..']
  end;
end;

procedure TMainView.Btn_SavePictureClick(Sender: TObject);
var
  L_FileName: string;
begin
  if SaveDialog_Picture.Execute then
  begin
    L_FileName := SaveDialog_Picture.FileName;
    if not L_FileName.IsEmpty then
      Img_Src.Bitmap.SaveToFile(L_FileName);
    LogStatus['Picture Saved Successfully ..'];
  end;
end;

end.

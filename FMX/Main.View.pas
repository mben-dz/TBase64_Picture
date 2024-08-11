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
    fBase64Picture: I_Base64Picture;
    fMemoStream: TMemoryStream;
  {$REGION '  [Getters||Setters] .. '}
    function GetBase64Picture: I_Base64Picture;
    function GetMemo: string; procedure SetMemo(const aValue: string);
    function GetMemoStream: TMemoryStream;
    function GetLogStatus(const aValue: string = ''): string;
  {$ENDREGION}
    procedure Clear_MemoStream;
    procedure OnPicture_Changed;
  public
    property Base64: I_Base64Picture read GetBase64Picture;
    property Memo: string read GetMemo write SetMemo;
    property MemoStream: TMemoryStream read GetMemoStream;
    property LogStatus[const aValue: string = '']: string Read GetLogStatus;
  end;

implementation

uses
  API.Types;

{$R *.fmx}

{ TMainView }

{$REGION '  [Getters||Setters] .. '}
function TMainView.GetBase64Picture: I_Base64Picture;
begin
  if not Assigned(fBase64Picture) then
    fBase64Picture := GetTBase64Picture;

  Result := fBase64Picture;
end;

function TMainView.GetMemo: string;
begin
  Result := Memo_Base64.Lines.Text;
end;

procedure TMainView.SetMemo(const aValue: string);
begin
  if aValue.IsEmpty then
    Memo_Base64.Lines.Clear
  else
    Memo_Base64.Lines.Text := aValue;
end;

function TMainView.GetMemoStream: TMemoryStream;
begin
  fMemoStream := TMemoryStream.Create;
  try
    Memo_Base64.Lines.SaveToStream(fMemoStream);
  finally
    Result := fMemoStream;
  end;
end;

function TMainView.GetLogStatus(const aValue: string): string;
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
begin
//  Base64.Decode(MemoStream, Img_Src.Bitmap.ToFinalPicture);
  TStaticBase64Picture.Decode(MemoStream, Img_Src.Bitmap.ToFinalPicture);
  TRY
    OnPicture_Changed;
  FINALLY
    Clear_MemoStream;
  END;
end;

procedure TMainView.Btn_EncodeClick(Sender: TObject);
begin
  Memo.Empty;
//  Memo := Base64.Encode(Img_Src.Bitmap.ToFinalPicture);
  Memo := TStaticBase64Picture.Encode(Img_Src.Bitmap.ToFinalPicture);

  LogStatus['Encoded Base64 Picture Saved to Clipboard Successfully ..'];

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
  LFileName: string;
begin
  if SaveDialog_Picture.Execute then
  begin
    LFileName := SaveDialog_Picture.FileName;
    if not LFileName.IsEmpty then
      Img_Src.Bitmap.SaveToFile(LFileName);
    LogStatus['Picture Saved Successfully ..'];
  end;
end;

end.

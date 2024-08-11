unit Main.View;

interface

uses
{$REGION '  Import: Winapi''s .. '}
  Winapi.Windows,
  Winapi.Messages,
{$ENDREGION}
{$REGION '  Import: System''s .. '}
  System.SysUtils,
  System.Variants,
  System.Classes,
{$ENDREGION}
{$REGION '  Import: Vcl''s .. '}
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
{$ENDREGION}
//
  API.Base64

;

type

  TMainView = class(TForm)

  {$REGION '  Components .. '}
    Btn_LoadPicture: TButton;
    Memo_Base64: TMemo;
    Btn_Encode: TButton;
    Btn_Decode: TButton;
    FileSaveDlg: TFileSaveDialog;
    FileOpenDlg: TFileOpenDialog;
    Btn_Save: TButton;
    Pnl_Status: TPanel;
    Img_Src: TImage;
  {$ENDREGION}
    procedure Btn_LoadPictureClick(Sender: TObject);
    procedure Btn_EncodeClick(Sender: TObject);
    procedure Btn_DecodeClick(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure Memo_Base64Change(Sender: TObject);
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
    { Private declarations }
  public
    { Public declarations }
    property Base64: I_Base64Picture read GetBase64Picture;
    property Memo: string read GetMemo write SetMemo;
    property MemoStream: TMemoryStream read GetMemoStream;
    property LogStatus[const aValue: string = '']: string Read GetLogStatus;
  end;

implementation

uses
  Vcl.Clipbrd, API.Types;

{$R *.dfm}

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
    Memo_Base64.Clear
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
    Pnl_Status.Caption := '   ' +aValue;

  Result := Pnl_Status.Caption;
end;
{$ENDREGION}

procedure TMainView.Clear_MemoStream;
begin
  fMemoStream.Clear;
  FreeAndNil(fMemoStream);
end;

procedure TMainView.Memo_Base64Change(Sender: TObject);
begin
  Btn_Decode.Enabled := not (Memo.IsEmpty);
end;

procedure TMainView.OnPicture_Changed;
begin
  Btn_Save.Enabled   := not Img_Src.Picture.Graphic.Empty;
  Btn_Encode.Enabled := not Img_Src.Picture.Graphic.Empty;
end;

procedure TMainView.Btn_DecodeClick(Sender: TObject);
begin
  TStaticBase64Picture.Decode(MemoStream, Img_Src.Picture.ToFinalPicture);
  TRY
    OnPicture_Changed;
  FINALLY
    Clear_MemoStream;
  END;
end;

procedure TMainView.Btn_EncodeClick(Sender: TObject);
var
  LClipboard: TClipboard;
begin
  LClipboard  := TClipboard.Create;
  try
    Memo.Empty;
    Memo := Base64.Encode(Img_Src.Picture.ToFinalPicture);

    LClipboard.AsText := Memo;
    LogStatus['Encoded Base64 Picture Saved to Clipboard Successfully ..'];
  finally
    LClipboard.Free;
  end;
end;

procedure TMainView.Btn_LoadPictureClick(Sender: TObject);
begin
  FileOpenDlg.DefaultFolder := ExtractFileDir(ParamStr(0));

  if FileOpenDlg.Execute then begin
    Img_Src.Picture.LoadFromFile(FileOpenDlg.FileName);
    OnPicture_Changed;
    LogStatus['Picture Loaded Successfully ..'];
  end;
end;

procedure TMainView.Btn_SaveClick(Sender: TObject);
var
  LFileName: string;
begin
  if FileSaveDlg.Execute then
  try
    LFileName := FileSaveDlg.FileName;
  finally
    if not LFileName.IsEmpty then
      Img_Src.Picture.SaveToFile(LFileName);
    LogStatus['Picture Saved Successfully ..'];
  end;

end;

end.

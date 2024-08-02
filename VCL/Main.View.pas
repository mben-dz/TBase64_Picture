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
    { Private declarations }
  public
    { Public declarations }
    property Base64: I_Base64_Picture read Get_Base64_Picture;
    property Memo: string read Get_Memo write Set_Memo;
    property MemoStream: TMemoryStream read Get_MemoStream;
    property LogStatus[const aValue: string = '']: string Read Get_LogStatus;
  end;

implementation

uses
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage,
  Vcl.Clipbrd;

{$R *.dfm}

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
    Memo_Base64.Clear
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
var
  L_Pic: TPicture;
begin
  L_Pic := TStatic_Base64_Picture.Decode(MemoStream);
  TRY
    Img_Src.Picture.Assign(L_Pic);
    OnPicture_Changed;
  FINALLY
    Clear_MemoStream;
    FreeAndNil(L_Pic);
  END;
end;

procedure TMainView.Btn_EncodeClick(Sender: TObject);
var
  L_Src_Stream: TMemoryStream;
  L_Clipboard: TClipboard;
begin
  L_Src_Stream := TMemoryStream.Create;
  L_Clipboard  := TClipboard.Create;
  try
    Img_Src.Picture.SaveToStream(L_Src_Stream);
    L_Src_Stream.Position := 0;

    Memo.Empty;
    Memo := Base64.Encode(L_Src_Stream);

    L_Clipboard.AsText := Memo;
    LogStatus['Encoded Base64 Picture Saved to Clipboard Successfully ..'];
  finally
    L_Src_Stream.Free;
    L_Clipboard.Free;
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
  L_FileName: string;
begin
  if FileSaveDlg.Execute then
  try
    L_FileName := FileSaveDlg.FileName;
  finally
    if not L_FileName.IsEmpty then
      Img_Src.Picture.SaveToFile(L_FileName);
    LogStatus['Picture Saved Successfully ..'];
  end;

end;

end.

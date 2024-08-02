object MainView: TMainView
  Left = 0
  Top = 0
  ClientHeight = 463
  ClientWidth = 697
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  TextHeight = 19
  object Img_Src: TImage
    Left = 8
    Top = 55
    Width = 265
    Height = 314
    Center = True
  end
  object Btn_LoadPicture: TButton
    Left = 8
    Top = 8
    Width = 265
    Height = 41
    Cursor = crHandPoint
    Caption = 'Load Picture'
    TabOrder = 0
    OnClick = Btn_LoadPictureClick
  end
  object Memo_Base64: TMemo
    Left = 279
    Top = 55
    Width = 410
    Height = 314
    ScrollBars = ssBoth
    TabOrder = 1
    OnChange = Memo_Base64Change
  end
  object Btn_Encode: TButton
    Left = 279
    Top = 8
    Width = 177
    Height = 41
    Cursor = crHandPoint
    Caption = 'Encode Picture'
    Enabled = False
    TabOrder = 2
    OnClick = Btn_EncodeClick
  end
  object Btn_Decode: TButton
    Left = 472
    Top = 8
    Width = 217
    Height = 41
    Cursor = crHandPoint
    Caption = 'Decode Encoded Picture'
    Enabled = False
    TabOrder = 3
    OnClick = Btn_DecodeClick
  end
  object Btn_Save: TButton
    Left = 8
    Top = 375
    Width = 265
    Height = 50
    Cursor = crHandPoint
    Caption = 'Save Picture'
    Enabled = False
    TabOrder = 4
    OnClick = Btn_SaveClick
  end
  object Pnl_Status: TPanel
    Left = 0
    Top = 436
    Width = 697
    Height = 27
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 13158600
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Bahnschrift SemiLight SemiConde'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    ParentBackground = False
    ParentFont = False
    TabOrder = 5
    ExplicitTop = 428
    ExplicitWidth = 695
  end
  object FileSaveDlg: TFileSaveDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 208
    Top = 72
  end
  object FileOpenDlg: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'PNG Pictures'
        FileMask = '*.png'
      end
      item
        DisplayName = 'JPEG / JPG Pictures'
        FileMask = '*.JPG'
      end
      item
        DisplayName = 'Bitmap Pictures'
        FileMask = '*.bmp'
      end>
    Options = []
    Title = 'Load Pictures'
    Left = 56
    Top = 72
  end
end

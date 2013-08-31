object QuickExportSetupForm: TQuickExportSetupForm
  Left = 204
  Top = 279
  BorderStyle = bsDialog
  Caption = 'FB2_2_rtf quick'
  ClientHeight = 184
  ClientWidth = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object SkipImages: TCheckBox
    Left = 8
    Top = 8
    Width = 153
    Height = 17
    Caption = 'Skip all images'
    TabOrder = 0
    OnClick = SkipImagesClick
    OnKeyPress = SkipImagesKeyPress
  end
  object Button1: TButton
    Left = 13
    Top = 148
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 100
    Top = 148
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object SkipCover: TCheckBox
    Left = 8
    Top = 32
    Width = 153
    Height = 17
    Caption = 'No cover image'
    TabOrder = 3
  end
  object SkipDescr: TCheckBox
    Left = 8
    Top = 56
    Width = 153
    Height = 17
    Caption = 'Skip description'
    TabOrder = 4
  end
  object EncCompat: TCheckBox
    Left = 8
    Top = 80
    Width = 153
    Height = 17
    Caption = 'Compatible encoding'
    TabOrder = 5
  end
  object ImgCompat: TCheckBox
    Left = 8
    Top = 104
    Width = 153
    Height = 17
    Caption = 'Compatible images'
    TabOrder = 6
  end
end

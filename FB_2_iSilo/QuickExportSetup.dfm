object QuickExportSetupForm: TQuickExportSetupForm
  Left = 417
  Top = 266
  BorderStyle = bsDialog
  Caption = 'FB2_2_isilo quick'
  ClientHeight = 126
  ClientWidth = 201
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
  object Label1: TLabel
    Left = 10
    Top = 40
    Width = 65
    Height = 16
    Caption = 'TOC depth'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 126
    Height = 16
    Caption = '(use 0 to turn TOC off)'
  end
  object SkipImages: TCheckBox
    Left = 10
    Top = 12
    Width = 209
    Height = 17
    Caption = 'Skip all images'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 29
    Top = 92
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 116
    Top = 92
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object TOCDepthEdit: TEdit
    Left = 141
    Top = 37
    Width = 49
    Height = 24
    TabOrder = 3
    Text = '2'
    OnChange = WidthEditChange
  end
end

object QuickExportSetupForm: TQuickExportSetupForm
  Left = 327
  Top = 128
  BorderStyle = bsDialog
  Caption = 'FB2_2_TXT quick'
  ClientHeight = 316
  ClientWidth = 270
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
    Left = 16
    Top = 173
    Width = 85
    Height = 16
    Caption = 'Text encoding'
  end
  object Label2: TLabel
    Left = 16
    Top = 221
    Width = 92
    Height = 16
    Caption = 'Line break type'
  end
  object SkipDescr: TCheckBox
    Left = 16
    Top = 16
    Width = 137
    Height = 17
    Caption = 'Skip description'
    TabOrder = 0
  end
  object WordWrap: TCheckBox
    Left = 16
    Top = 40
    Width = 121
    Height = 17
    Caption = 'Fixed-width text'
    TabOrder = 1
    OnClick = WordWrapClick
    OnKeyPress = WordWrapKeyPress
  end
  object IndentEdit: TEdit
    Left = 216
    Top = 91
    Width = 41
    Height = 24
    TabOrder = 2
    Text = '    '
  end
  object Hyph: TCheckBox
    Left = 40
    Top = 64
    Width = 97
    Height = 17
    Caption = 'Hyphenate'
    TabOrder = 3
  end
  object Indent: TCheckBox
    Left = 16
    Top = 96
    Width = 200
    Height = 17
    Caption = 'Indent paragraph with this text:'
    TabOrder = 4
    OnClick = IndentClick
    OnKeyPress = IndentKeyPress
  end
  object WidthEdit: TEdit
    Left = 144
    Top = 35
    Width = 49
    Height = 24
    TabOrder = 5
    Text = '80'
    OnChange = WidthEditChange
  end
  object EncodingsList: TComboBox
    Left = 16
    Top = 189
    Width = 241
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 6
  end
  object BRTypeList: TComboBox
    Left = 16
    Top = 237
    Width = 241
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 7
  end
  object Button1: TButton
    Left = 96
    Top = 280
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 183
    Top = 280
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object IgnoreStrongC: TCheckBox
    Left = 16
    Top = 120
    Width = 249
    Height = 17
    Caption = 'Do not convert strong to STRONG'
    TabOrder = 10
  end
  object IgnoreItalicC: TCheckBox
    Left = 16
    Top = 144
    Width = 249
    Height = 17
    Caption = 'Do not convert italic to _italic_'
    TabOrder = 11
  end
end

object Form1: TForm1
  Left = 167
  Top = 128
  Width = 845
  Height = 880
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 837
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 344
      Top = 7
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object ComboBox1: TComboBox
      Left = 240
      Top = 8
      Width = 97
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 1
      OnChange = ComboBox1Change
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 8
      Width = 137
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 2
      OnChange = ComboBox2Change
    end
    object ComboBox3: TComboBox
      Left = 144
      Top = 8
      Width = 97
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 3
    end
  end
  object RichEdit1: TRichEdit
    Left = 0
    Top = 41
    Width = 837
    Height = 804
    Align = alClient
    Lines.Strings = (
      'RichEdit1')
    ScrollBars = ssBoth
    TabOrder = 1
  end
end

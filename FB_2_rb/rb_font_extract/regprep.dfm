object Form1: TForm1
  Left = 466
  Top = 207
  BorderStyle = bsDialog
  Caption = '.RBF->.REG'
  ClientHeight = 193
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 44
    Height = 16
    Caption = 'Normal'
  end
  object Label3: TLabel
    Left = 8
    Top = 32
    Width = 28
    Height = 16
    Caption = 'Bold'
  end
  object Label4: TLabel
    Left = 8
    Top = 56
    Width = 27
    Height = 16
    Caption = 'Italic'
  end
  object Label5: TLabel
    Left = 8
    Top = 88
    Width = 45
    Height = 16
    Caption = 'BoldItal'
  end
  object Button2: TButton
    Left = 152
    Top = 163
    Width = 97
    Height = 25
    Caption = 'Generate &xml'
    Default = True
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 131
    Width = 273
    Height = 24
    MaxLength = 40
    TabOrder = 0
  end
  object Button1: TButton
    Left = 256
    Top = 163
    Width = 25
    Height = 25
    Caption = '?'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 56
    Top = 8
    Width = 193
    Height = 24
    TabOrder = 3
  end
  object Button4: TButton
    Left = 256
    Top = 8
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button3: TButton
    Left = 256
    Top = 32
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit3: TEdit
    Left = 56
    Top = 32
    Width = 193
    Height = 24
    TabOrder = 6
  end
  object Button5: TButton
    Left = 256
    Top = 56
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Edit4: TEdit
    Left = 56
    Top = 56
    Width = 193
    Height = 24
    TabOrder = 8
  end
  object Button6: TButton
    Left = 256
    Top = 80
    Width = 27
    Height = 25
    Caption = '...'
    TabOrder = 9
    OnClick = Button6Click
  end
  object Edit5: TEdit
    Left = 56
    Top = 80
    Width = 193
    Height = 24
    TabOrder = 10
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 112
    Width = 217
    Height = 17
    Caption = 'This is LARGE font'
    TabOrder = 11
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'rb'
    Filter = 'Rocket eBook font|*.rbf|All files|*.*'
    Left = 32
    Top = 147
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'xml'
    Filter = 'XML files|*.xml|All files|*.*'
    InitialDir = 'C:\Work\FB_2_any\FB_2_rb\rb_font_extract\fonts\rbf'
    Left = 64
    Top = 147
  end
end

object EncWarn: TEncWarn
  Left = 287
  Top = 140
  BorderStyle = bsDialog
  Caption = 'Warning!'
  ClientHeight = 88
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 323
    Height = 16
    Caption = 'Some characters are missing from the target encoding.'
  end
  object Label2: TLabel
    Left = 8
    Top = 24
    Width = 246
    Height = 16
    Caption = 'Part of a text may look like '#39'????? ??? ???'#39
  end
  object Button1: TButton
    Left = 296
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 64
    Width = 225
    Height = 17
    Caption = 'Never show this message again'
    TabOrder = 1
  end
end

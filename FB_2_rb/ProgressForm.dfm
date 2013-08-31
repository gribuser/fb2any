object ScrolForm: TScrolForm
  Left = 248
  Top = 167
  BorderStyle = bsNone
  Caption = 'ScrolForm'
  ClientHeight = 36
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 36
    Align = alClient
    TabOrder = 0
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 8
      Width = 257
      Height = 20
      Min = 0
      Max = 100
      TabOrder = 0
    end
  end
end

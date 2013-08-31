object QuickExportSetupForm: TQuickExportSetupForm
  Left = 384
  Top = 225
  BorderStyle = bsDialog
  Caption = 'FB2_2_isilo quick'
  ClientHeight = 307
  ClientWidth = 299
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
  object Button1: TButton
    Left = 133
    Top = 277
    Width = 75
    Height = 25
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 220
    Top = 277
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 299
    Height = 267
    Align = alTop
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 4
      Top = 4
      Width = 291
      Height = 61
      Align = alTop
      Caption = 'Document content'
      TabOrder = 0
      object CheckBox9: TCheckBox
        Left = 184
        Top = 18
        Width = 97
        Height = 16
        Caption = 'No images'
        TabOrder = 1
      end
      object CheckBox2: TCheckBox
        Left = 184
        Top = 37
        Width = 89
        Height = 16
        Caption = 'No cover'
        TabOrder = 2
      end
      object CheckBox4: TCheckBox
        Left = 8
        Top = 18
        Width = 121
        Height = 17
        Caption = 'No description'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
    end
    object GroupBox2: TGroupBox
      Left = 4
      Top = 65
      Width = 291
      Height = 44
      Align = alTop
      Caption = 'Cyrrylic support'
      TabOrder = 1
      object CheckBox1: TCheckBox
        Left = 8
        Top = 18
        Width = 245
        Height = 17
        Caption = 'Translit title and author name'
        TabOrder = 0
      end
    end
    object GroupBox3: TGroupBox
      Left = 4
      Top = 109
      Width = 291
      Height = 72
      Align = alTop
      Caption = 'Table of content generation'
      TabOrder = 2
      object ComboBox2: TComboBox
        Left = 8
        Top = 19
        Width = 276
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 0
        Text = 'No table of content'
        Items.Strings = (
          'No table of content'
          'Top-level headers only'
          'Two-levels deep TOC'
          'Three-levels deep TOC'
          'Inclide ALL headers to toc')
      end
      object CheckBox17: TCheckBox
        Left = 40
        Top = 47
        Width = 231
        Height = 17
        Caption = 'Shorten multi-line headers in TOC'
        TabOrder = 1
      end
    end
    object GroupBox4: TGroupBox
      Left = 4
      Top = 181
      Width = 291
      Height = 83
      Align = alTop
      Caption = 'Text formating'
      TabOrder = 3
      object ComboBox3: TComboBox
        Left = 8
        Top = 19
        Width = 276
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 0
        Text = 'No page-breaks'
        Items.Strings = (
          'No page-breaks'
          'Page-breaks for top-level headers'
          'Page-breaks for two-level headers'
          'Page-breaks for three-level headers'
          'Pagebreaks for all sections')
      end
      object ComboBox4: TComboBox
        Left = 8
        Top = 48
        Width = 138
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 1
      end
      object ComboBox5: TComboBox
        Left = 145
        Top = 48
        Width = 64
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 2
      end
      object ComboBox6: TComboBox
        Left = 208
        Top = 48
        Width = 76
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 3
      end
    end
  end
end

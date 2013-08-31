object ExportToRBDialog: TExportToRBDialog
  Left = 604
  Top = 193
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'FB2 to RB export by GribUser'
  ClientHeight = 416
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    000001002000000000000000000000000000000000000000000000000000FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00663300FF663300FF663300FF6633
    00FF663300FF663300FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00663300FF663300FF663300FF663300FF663300FF6633
    00FF663300FF663300FF663300FF663300FFFFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00663300FF663300FF663300FF663300FF663300FF663300FF6633
    00FF663300FF663300FF663300FF663300FF663300FFFFFFFF00FFFFFF00FFFF
    FF00663300FF333366FF6666CCFF9999CCFF6666CCFF333366FF330066FF3300
    66FF330066FF330066FF333333FF663300FF663300FF663300FFFFFFFF00FFFF
    FF00333333FFD6E7E7FFFFFFFFFFD6E7E7FFC6D6EFFFF1F1F1FF9999CCFF2100
    A5FF000099FF000099FF000099FF330066FF663300FF663300FFFFFFFF006633
    00FF663399FFFFFFFFFFC6D6EFFF000099FF000099FF000099FF6666CCFFC6D6
    EFFF3333CCFF000099FF000099FF000099FF333333FF663300FF663300FF6633
    00FF663399FFFFFFFFFF9999CCFF000099FF000099FF000099FF000099FF0000
    99FF6666CCFF9999CCFFF1F1F1FF333399FF000080FF663300FF663300FF3333
    99FF9999CCFFFFFFFFFFF1F1F1FF9999CCFF6666CCFF333399FF000099FF0000
    99FF000099FFC6D6EFFFFFFFFFFFD6E7E7FF3333CCFF333333FF663300FF6633
    00FF333333FF9999CCFFFFFFFFFF9999CCFF9999CCFFD6E7E7FFD6E7E7FF9999
    CCFF000099FF333399FF9999CCFFF1F1F1FFFFFFFFFF6666CCFF663300FF6633
    00FF663300FF333333FFC6D6EFFFC6D6EFFF000099FF000099FF6666CCFFF1F1
    F1FFC6D6EFFF2100A5FF000099FF333399FF9999CCFFF1F1F1FF333399FF6633
    00FF663300FF663300FF333366FFC6D6EFFF9999CCFF000099FF000099FF2100
    A5FFF1F1F1FF6666CCFF000099FF000099FF000099FF333333FF333333FFFFFF
    FF00663300FF663300FF663300FF330066FF9999CCFF9999CCFF333399FF0000
    99FFC6D6EFFF6666CCFF000099FF000099FF330066FF663300FFFFFFFF00FFFF
    FF00663300FF663300FF663300FF663300FF000080FF333399FF6666CCFF9999
    CCFF6666CCFF000099FF000099FF000080FF663300FF663300FFFFFFFF00FFFF
    FF00FFFFFF00663300FF663300FF663300FF663300FF330066FF000080FF0000
    99FF000099FF000080FF333333FF663300FF663300FFFFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00663300FF663300FF663300FF663300FF663300FF6633
    00FF663300FF663300FF663300FF663300FFFFFFFF00FFFFFF00FFFFFF00FFFF
    FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00663300FF663300FF663300FF6633
    00FF663300FF663300FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F81F
    0000E0070000C003000080010000800100000000000000000000000000000000
    000000000000000000008001000080010000C0030000E0070000F81F0000}
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Panel2: TPanel
    Left = 0
    Top = 363
    Width = 322
    Height = 53
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel3: TPanel
      Left = 7
      Top = 0
      Width = 315
      Height = 53
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button2: TButton
        Left = 112
        Top = 0
        Width = 89
        Height = 29
        Caption = '&Export to file'
        Default = True
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 207
        Top = 0
        Width = 69
        Height = 29
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 2
      end
      object Button4: TButton
        Left = 280
        Top = 0
        Width = 29
        Height = 29
        Caption = '?'
        TabOrder = 3
        OnClick = Button4Click
      end
      object CheckBox3: TCheckBox
        Left = 2
        Top = 33
        Width = 305
        Height = 17
        Caption = 'Skip this dialog unless you "Cancel" saving'
        TabOrder = 4
      end
      object Button1: TButton
        Left = 8
        Top = 0
        Width = 99
        Height = 29
        Caption = 'To REB1100'
        ModalResult = 2
        TabOrder = 0
        OnClick = Button2Click
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 322
    Height = 363
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 7
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 7
      Top = 7
      Width = 308
      Height = 349
      ActivePage = TabSheet1
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Document'
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 300
          Height = 318
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 4
          TabOrder = 0
          object GroupBox1: TGroupBox
            Left = 4
            Top = 4
            Width = 292
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
              OnClick = CheckBox9Click
              OnKeyPress = CheckBox9KeyPress
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
            Width = 292
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
            Width = 292
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
              OnChange = ComboBox2Change
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
            Width = 292
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
          object GroupBox5: TGroupBox
            Left = 4
            Top = 264
            Width = 292
            Height = 49
            Align = alTop
            Caption = 'REB 1100 options'
            TabOrder = 4
            object ComboBox1: TComboBox
              Left = 8
              Top = 16
              Width = 276
              Height = 24
              Style = csDropDownList
              Enabled = False
              ItemHeight = 16
              ItemIndex = 0
              TabOrder = 0
              Text = 'Write new books to internal memory'
              Items.Strings = (
                'Write new books to internal memory'
                'Write new books to Smart Media Card')
            end
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Log'
        ImageIndex = 2
        object RichEdit1: TRichEdit
          Left = 0
          Top = 0
          Width = 300
          Height = 296
          Align = alClient
          BorderStyle = bsNone
          Color = clBtnFace
          Ctl3D = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          HideSelection = False
          Lines.Strings = (
            'Ready...')
          ParentCtl3D = False
          ParentFont = False
          PopupMenu = PopupMenu1
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WantReturns = False
          WordWrap = False
        end
        object ProgressBar1: TProgressBar
          Left = 0
          Top = 296
          Width = 300
          Height = 22
          Align = alBottom
          Min = 0
          Max = 100
          TabOrder = 1
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 286
    Top = 8
    object Copy1: TMenuItem
      Caption = '&Copy the whole log'
      OnClick = Copy1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'rb'
    Filter = 'Rocket eBook/REB1100 (*.rb)|*.rb|All files (*.*)|*.*'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 254
    Top = 8
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 224
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'fb2'
    Filter = 'FictionBook 2.0 documents (*.fb2)|*.fb2|All files (*.*)|*.*'
    Left = 192
    Top = 8
  end
end

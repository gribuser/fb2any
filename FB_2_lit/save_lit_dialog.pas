unit save_lit_dialog;

interface
uses Messages, Windows, SysUtils, Classes, Controls, StdCtrls, Graphics,
  ExtCtrls, Buttons, Dialogs;

type
  TOpenPictureDialog = class(TSaveDialog)
  private
    SkipImages:TCheckBox;
    TOCDepthEdit:TEdit;
    FChecksPanel: TPanel;
    TocDepVar:Integer;
    function GetSkipImages:boolean;
  protected
    procedure DoClose; override;
    procedure DoShow; override;
    Procedure TOCDepthChange(Sender: TObject);
  public
    property DoSkipImages:boolean read GetSkipImages;
    property TocDepth:Integer read TocDepVar;
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
  end;

const
 RegistryKey='Software\Grib Soft\FB to LIT\1.0';
implementation
uses Consts, Math, Forms, CommDlg, Dlgs,Registry;
{$R MyExtdlg.res}

function TOpenPictureDialog.GetSkipImages;
Begin
  result:= SkipImages.checked;
end;
Procedure TOpenPictureDialog.TOCDepthChange;
Begin
  try
    StrToInt(TOCDepthEdit.Text);
  except
    TOCDepthEdit.Text:='2';
  end;
  TocDepVar:=StrToInt(TOCDepthEdit.Text)
end;


constructor TOpenPictureDialog.Create(AOwner: TComponent);
Var
  Reg:TRegistry;
begin
  inherited Create(AOwner);
  Options:=[ofOverwritePrompt,ofEnableSizing];
  FChecksPanel:=TPanel.Create(Self);
  with FChecksPanel do
  Begin
    Name := 'PicturePanel';
    Caption := '';
    SetBounds(10, 150, 200, 200);
    BevelOuter := bvNone;
    BorderWidth := 6;
    TabOrder := 1;
    SkipImages:=TCheckBox.Create(Self);
    With SkipImages do Begin
      Name := 'SkipImages';
      Caption := 'No images';
      Left:=126;
      Top:=3;
      TabOrder := 1;
      Width:=94;
      Parent:=FChecksPanel;
    end;

    TOCDepthEdit:=TEdit.Create(Self);
    With TOCDepthEdit do Begin
      Name := 'TocEdit';
      Left:=355;
      Top:=0;
      TabOrder := 2;
      Width:=30;
      Text:='2';
      TocDepVar:=2;
      Parent:=FChecksPanel;
      TOCDepthEdit.OnChange:=TOCDepthChange;
    end;
    with TLabel.Create(Self)do
    Begin
      Name := 'TocDepthL';
      Caption := 'TOC depth';
      Left:=280;
      Top:=3;
      Width:=120;
      Parent:=FChecksPanel;
      FocusControl:=TOCDepthEdit;
    end;

  end;
  Reg:=TRegistry.Create(KEY_READ);
  Try
    Try
      if Reg.OpenKeyReadOnly(RegistryKey) then
      Begin
        SkipImages.Checked:=Reg.ReadBool('Skip images');
        TocDepVar:=Reg.ReadInteger('TOC deepness');
        TOCDepthEdit.Text:=IntToStr(TocDepVar);
      end;
    Finally
      Reg.Free;
    end;
  Except
  end;
  Filter:='LIT books (*.lit)|*.lit|All files (*.*)|*.*';
  Title:='FB2 to lit v0.14 by GribUser';
  DefaultExt:='lit';
end;
procedure TOpenPictureDialog.DoShow;
var
  PreviewRect, StaticRect: TRect;
begin
  GetClientRect(Handle, PreviewRect);
  StaticRect := GetStaticRect;
  { Move preview area to right of static area }
  PreviewRect.Top:= StaticRect.Top + (StaticRect.Bottom - StaticRect.Top);
  Inc(PreviewRect.Left, 10);
  FChecksPanel.BoundsRect := PreviewRect;
  FChecksPanel.ParentWindow := Handle;
  inherited DoShow;
end;
procedure TOpenPictureDialog.DoClose;
begin
  inherited DoClose;
  { Hide any hint windows left behind }
  Application.HideHint;
end;
function TOpenPictureDialog.Execute;
Var
  Reg:TRegistry;
begin
  Template := 'DLGTEMPLATE2';
  Options:=[ofOverwritePrompt,ofEnableSizing];
  Result := inherited Execute;
  if Result then
  Begin
    Reg:=TRegistry.Create(KEY_ALL_ACCESS);
    Try
      if Reg.OpenKey(RegistryKey,True) then
      Begin
        Reg.WriteBool('Skip images',SkipImages.Checked);
        Reg.WriteInteger('TOC deepness',TocDepVar);
      end;
    Finally
      Reg.Free;
    end;
  end;
end;

end.

unit save_rtf_dialog;

interface
uses Messages, Windows, SysUtils, Classes, Controls, StdCtrls, Graphics,
  ExtCtrls, Buttons, Dialogs;

type
  TOpenPictureDialog = class(TSaveDialog)
  private
    SkipImages, SkipCover, SkipDescr, EncCompat, ImgCompat:TCheckBox;
    FChecksPanel: TPanel;
    function GetSkipImages:boolean;
    function GetSkipCover:boolean;
    function GetSkipDescr:boolean;
    function GetEncCompat:boolean;
    function GetImgCompat:boolean;
  protected
    procedure DoClose; override;
    procedure DoShow; override;
  public
    property DoSkipImages:boolean read GetSkipImages;
    property DoSkipCover:boolean read GetSkipCover;
    property DoSkipDescr:boolean read GetSkipDescr;
    property DoEncCompat:boolean read GetEncCompat;
    property DoImgCompat:boolean read GetImgCompat;
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; override;
    Procedure OnImgClick(sender: TObject);
    Procedure OnImgKey(Sender: TObject; var Key: Char);
  end;

const
 RegistryKey='Software\Grib Soft\FB to RTF\1.0';
implementation
uses Consts, Math, Forms, CommDlg, Dlgs,Registry;
{$R MyExtdlg.res}

function TOpenPictureDialog.GetSkipImages;
Begin
  result:= SkipImages.checked;
end;
function TOpenPictureDialog.GetSkipCover;
Begin
  result:= SkipCover.checked;
end;
function TOpenPictureDialog.GetSkipDescr;
Begin
  result:= SkipDescr.checked;
end;
function TOpenPictureDialog.GetEncCompat;
Begin
  result:= EncCompat.checked;
end;
function TOpenPictureDialog.GetImgCompat;
Begin
  result:= ImgCompat.checked;
end;

procedure TOpenPictureDialog.OnImgClick;
Begin
  SkipCover.Enabled:=not SkipImages.Checked;
end;
procedure TOpenPictureDialog.OnImgKey;
Begin
  OnImgClick(SkipImages);
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
      Left:=0;
      Top:=0;
      TabOrder := 1;
      Width:=94;
      Parent:=FChecksPanel;
    end;
    SkipImages.OnClick:=OnImgClick;
    SkipImages.OnKeyPress:=OnImgKey;
    SkipCover:=TCheckBox.Create(Self);
    With SkipCover do Begin
      Name := 'SkipCover';
      Caption := 'No cover image';
      Left:=94;
      Top:=0;
      TabOrder := 2;
      Width:=120;
      Parent:=FChecksPanel;
    end;
    SkipDescr:=TCheckBox.Create(Self);
    With SkipDescr do Begin
      Name := 'SkipDescr';
      Caption := 'Skip description';
      Left:=214;
      Top:=0;
      TabOrder := 3;
      Width:=180;
      Parent:=FChecksPanel;
    end;
    EncCompat:=TCheckBox.Create(Self);
    With EncCompat do Begin
      Name := 'EncCompat';
      Caption := 'Compatible encoding';
      Left:=340;
      Top:=0;
      TabOrder := 4;
      Width:=180;
      Parent:=FChecksPanel;
    end;
    ImgCompat:=TCheckBox.Create(Self);
    With ImgCompat do Begin
      Name := 'ImgCompat';
      Caption := 'Compatible images';
      Left:=500;
      Top:=0;
      TabOrder := 4;
      Width:=180;
      Parent:=FChecksPanel;
    end;
  end;
  Reg:=TRegistry.Create(KEY_READ);
  Try
    Try
      if Reg.OpenKeyReadOnly(RegistryKey) then
      Begin
        SkipImages.Checked:=Reg.ReadBool('Skip images');
        SkipCover.Checked:=Reg.ReadBool('Skip cover');
        SkipDescr.Checked:=Reg.ReadBool('Skip description');
        EncCompat.Checked:=Reg.ReadBool('Encoding compat');
        ImgCompat.Checked:=Reg.ReadBool('Image compat');
        OnImgClick(SkipImages);
      end;
    Finally
      Reg.Free;
    end;
  Except
  end;
  Filter:='Rich text files (*.rtf)|*.rtf|All files (*.*)|*.*';
  Title:='FB2 to rtf v0.11 by GribUser';
  DefaultExt:='rtf';
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
//  FPreviewButton.Left := FPaintPanel.BoundsRect.Right - FPreviewButton.Width - 2;
//  FImageCtrl.Picture := nil;
//  FSavedFilename := '';
//  FPaintPanel.Caption := srNone;
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
        Reg.WriteBool('Skip cover',SkipCover.Checked);
        Reg.WriteBool('Skip description',SkipDescr.Checked);
        Reg.WriteBool('Encoding compat',EncCompat.Checked);
        Reg.WriteBool('Image compat',ImgCompat.Checked);
      end;
    Finally
      Reg.Free;
    end;
  end;
end;

end.

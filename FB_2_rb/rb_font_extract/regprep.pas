unit RegPrep;

{===========================================================================

   Copyright (c) 2002 Dmitry Gribov.  All Rights Reserved.
  
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:
  
   1. Redistributions of source code must retain the above copyright
      notice immediately at the beginning of the file, without modification,
      this list of conditions, and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
   3. Absolutely no warranty of function or purpose is made by the author
      Dmitry Gribov.
  
   THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
   IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
   OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
   IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
   THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

===========================================================================}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button1: TButton;
    Edit2: TEdit;
    Button4: TButton;
    Button3: TButton;
    Edit3: TEdit;
    Button5: TButton;
    Edit4: TEdit;
    Button6: TButton;
    Edit5: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Type
  TRocketFnt= Record
    //четыре переменные неизвестного назначения, всегда одинаковые,
    //поэтому могут использоваться как сигнатура формата
    iUnknA01:Word; //неизв., всегда 0x0EE0
    iUnknA02:Word; //неизв., всегда 0x0DF0
    iUnknA03:Word; //неизв., всегда 0x0003
    iUnknA04:Word; //неизв., всегда 0x0000

    FontName:String[63]; //текстовое название шрифта

    CharSize:Integer; //0, +0x48, размер битмапа символа в байтах
    Points:Integer; //1, +0x4C, размер шрифта в пойнтах
    Height:Integer; //2, +0x50, высота битмапа символа в пикселах

    iUnknB01:Integer; //3, +0x54, неизв.
    iUnknB02:Integer; //4, +0x58, неизв.
    iUnknB03:Integer; //5, +0x5C, неизв.
    iUnknB04:Integer; //6, +0x60, неизв.

    WidthsShift:Integer; //7, +0x64, смещение массива ширин символов
    BitsShift:Integer; //8, +0x68, смещение массива битмапов символов

    iUnknB05:Integer; //9, +0x6C, неизв.
    iUnknB06:Integer; //A, +0x70, неизв.
  end;

procedure TForm1.Button2Click(Sender: TObject);
Type
  TFontInfo=array [0..3] of Record
    FileName:String;
    FontWrite:String;
  end;
Var
  F:TFileStream;
  FntHead:TRocketFnt;
  T:TextFile;
  D:Array[0..2000] of Byte;
  I,I1:Integer;
  MaxWidths: Record
    CharWidth:Integer;
    Count:Integer;
  end;
  LengthCounts:Array[0..255] of integer;
  FS,FB:String;
  Arr:TFontInfo;
  OutDat:String;
  Function GetChar(N:Integer):String;
  Begin
    Result:=Char(I);
    if Result[1] in ['"','&','<','>',#$98] then
      Result:='&#'+IntToStr(I)+';';
  end;
begin
  If Edit1.Text='' then
  Begin
    MessageBox(Handle,'Enter font name','Error',mb_Ok or mb_IconError);
    exit;
  end;
  Arr[0].FontWrite:='normal';
  Arr[0].FileName:=Edit2.Text;
  Arr[1].FontWrite:='strong';
  Arr[1].FileName:=Edit3.Text;
  Arr[2].FontWrite:='emphasis';
  Arr[2].FileName:=Edit4.Text;
  Arr[3].FontWrite:='strongemphasis';
  Arr[3].FileName:=Edit5.Text;
  if CheckBox1.Checked then FS:='Large' else FS:='Small';
  OutDat:='<?xml version="1.0" encoding="WINDOWS-1251"?><font-size name="'+FS+'">';

  For I1:=0 to 3 do
  Begin
    if Arr[I1].FileName='' then Continue;
    F:=TFileStream.Create(Arr[I1].FileName,fmOpenRead);
    F.Read(FntHead,SizeOf(FntHead));
    F.Seek(FntHead.WidthsShift,soFromBeginning);
    F.Read(D[0],255);
    F.Free;
    fillchar(LengthCounts,SizeOf(LengthCounts),#0);
    For I:=32 to 255 do
      LengthCounts[D[I-32]]:=LengthCounts[D[I-32]]+1;
    MaxWidths.Count:=0;
    For I:=0 to 255 do
      If LengthCounts[I]>MaxWidths.Count then 
      Begin
        MaxWidths.Count:=LengthCounts[I];
        MaxWidths.CharWidth:=I;
      end;
    OutDat:=OutDat+'<'+Arr[I1].FontWrite+' default-width="'+IntToStr(MaxWidths.CharWidth)+'">';
    For I:=32 to 255 do
      If (MaxWidths.CharWidth<>D[I-32]) then
        OutDat:=OutDat+'<c c="'+GetChar(I)+'">'+IntToStr(D[I-32])+'</c>'#10;
//        OutDat:=OutDat+'<c c="&#'+IntToStr(I)+';">'+IntToStr(D[I-32])+'</c>'#10;
    OutDat:=OutDat+'</'+Arr[I1].FontWrite+'>';
  end;
  OutDat:=OutDat+'</font-size>';
  If not SaveDialog1.Execute then Exit;
  AssignFile(T,SaveDialog1.FileName);
  Rewrite(T);

  WriteLn(T,OutDat);
  CloseFile(T);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  MessageBox(handle,'Grib''s RBF->REG v1.0. Allows to use custom Rocket fonts in ClearTXT.'#13'Creates REG file from RBF. For more info go to '#13+
  'http://www.df.ru/~grib'#13'or e-mail my: grib@df.ru','Info: About program',MB_ICONINFORMATION or mb_OK); 
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit3.Text:=OpenDialog1.FileName
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit2.Text:=OpenDialog1.FileName
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit4.Text:=OpenDialog1.FileName
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit5.Text:=OpenDialog1.FileName
end;

end.

{
0  -    разрыв страницы
1-32    вообще не отображаются прямо
33-126  Полное сответствие Win
127     Пусто

}

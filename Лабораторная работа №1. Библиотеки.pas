//Динамическое поключение библиотек
//dll для функции "+"
library DLLSuma;
uses
  SysUtils,
  Classes;

Function Plus(a,b:extended):extended;  StdCall;
 Begin
 Result:=a+b;
 end;
 
exports Plus;
begin
end.

//Подключение библиотек
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, jpeg, ExtCtrls, ActnList, ComCtrls;

 type Tass=function(p1,p2:extended):extended;
   stdcall;
 type
  TForm1 = class(TForm) //...
 private
  Plus, Minus, Umnog, Podel: Tass; //...
  
 //Проверка на наличие библиотек в указаном месте 
 procedure TForm1.FormCreate(Sender: TObject);
var
Hold:LongWord;
begin
Hold:=LoadLibrary('DLLs/DLLSuma.dll');
     if (Hold=0) then   Button10.Visible:=false;
Hold:=LoadLibrary('DLLs/DLLRazn.dll');
     if (Hold=0) then   Button11.Visible:=false;
Hold:=LoadLibrary('DLLs/DLLMnog.dll');
     if (Hold=0) then   Button12.Visible:=false;
Hold:=LoadLibrary('DLLs/DLLDel.dll');
     if (Hold=0) then   Button16.Visible:=false;
end;

//Использование библиотек
procedure TForm1.Button3Click(Sender: TObject);      
var
Handle:LongWord;
begin
try
if edit1.Text<>'' then b:=strtofloat(edit1.Text);
 case c of
 '+':
    begin
     Handle:=LoadLibrary('DLLSuma.dll');
     @Plus:=GetProcAddress(Handle, 'Plus');
     d:=Plus(a,b);
     FreeLibrary(Handle);
    end;
 '-':
  Begin
     Handle:=LoadLibrary('DLLRazn.dll');
     @Minus:=GetProcAddress(Handle, 'Minus');
     d:=Minus(a,b);
     FreeLibrary(Handle);
  end;
 '*':
 begin
    Handle:=LoadLibrary('DLLMnog.dll');
     @Umnog:=GetProcAddress(Handle, 'Umnog');
     d:=Umnog(a,b);
     FreeLibrary(Handle);
 end;
 '/':   begin
 if edit1.Text<>'' then b:=strtofloat(edit1.Text);
 if b=0 then
 begin
 showmessage('Нельзя делить на ноль');
 edit1.Text:='';
 end
 else
 begin
     Handle:=LoadLibrary('DLLDel.dll');
     @Podel:=GetProcAddress(Handle, 'Podel');
     d:=Podel(a,b);
     edit1.Text:=floattostr(d);
     FreeLibrary(Handle);
end;
 end;
end;
 except
on EConvertError do begin
showmessage('Ошибка');
end;
end;
edit1.Text:=floattostr(d);
end;

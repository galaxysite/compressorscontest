program compressorscontest;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$SMARTLINK ON}

{
    Compressors contest.
    For GNU/Linux 64 bit version.
    Version: 1.
    Written on FreePascal (https://freepascal.org/).
    Copyright (C) 2024  Artyomov Alexander
    http://self-made-free.ru/
    aralni@mail.ru

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

uses
unix, sysutils, DateUtils;

const
MAX_ARCS=13;
var
a : array[0..MAX_ARCS] of string = ('xz -k -e','bzip2 -k -9','gzip -k -9','lzip -k -9','quad -x','zstd -k --ultra','kgb -9','zip','arj a','lzop -k -9','7z a -mx9','pack --press=hard -i','paq9a a','lbzip2 -k -9');
e : array[0..MAX_ARCS] of string = ('xz','bz2','gz','lz','quad','zst','kgb','zip','arj','lzo','7z','pack','paq9a','bz2');
f : Int64;
filename : utf8string;
fp : file of byte;
fs : Int64;
min : Int64 = 0;
nodel : Int64 = 0;

MilliSecondsDiff: Int64;
FromTime, ToTime: TDateTime;

function chext(s, e : utf8string) : utf8string;
var f, l : Int64;
begin
l := Length(s);
for f := l downto 1 do begin
if s[f] = '.' then begin
Exit(Copy(s, 1, l - (l-f))+e);
end;
end; {next f}
Exit(s+'.'+e);
end;

begin
WriteLn(stderr,'Use: compressorscontest file.tar');
if ParamCount > 0 then begin
WriteLn(stderr,ParamStr(1));
a[6] := a[6] + ' ' + ParamStr(1) + '.kgb';
a[7] := a[7] + ' ' + ParamStr(1) + '.zip';
a[8] := a[8] + ' ' + ParamStr(1) + '.arj';
a[10] := a[10] + ' ' + ParamStr(1) + '.7z';
a[12] := a[12] + ' ' + ParamStr(1) + '.paq9a -9';

for f := 0 to MAX_ARCS do begin
 FromTime := Now();
fpSystem(a[f] + ' ' + ParamStr(1) + ' > /dev/null 2>/dev/null');
 ToTime := Now();
 MilliSecondsDiff := MilliSecondsBetween(ToTime,FromTime);
if f = 11 then filename := chext(ParamStr(1), e[11])
else filename := ParamStr(1) + '.' + e[f];
Write(stderr,'* ',filename, '  Time:', MilliSecondsDiff, ' Size:');
Assign(fp, filename);
FileMode:=0;
ReSet(fp);
fs := FileSize(fp);
Close(fp);
WriteLn(stderr, fs);

if min <> 0 then begin
 if fs < min then begin
  min := fs;
  nodel := f;
 end;
end else min := fs;

end; {next f}

for f := 0 to MAX_ARCS do begin
if f = 11 then filename := chext(ParamStr(1), e[11])
else filename := ParamStr(1) + '.' + e[f];
if f <> nodel then DeleteFile(filename)
else WriteLn(filename);
end; {next f}

end;
end.
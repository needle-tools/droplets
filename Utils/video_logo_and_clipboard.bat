@echo off
setlocal


set current_directory=%~dp0
set path_to_add_logo=%current_directory%/../Video/add_logo.bat
set copy_to_clipboard=%current_directory%/copy_to_clipboard.bat

REM run bat with arguments
echo "Adding logo to %~1"
call %path_to_add_logo% "%~1"

REM copy to clipboard
set "file_path_without_ext=%~1"
set "file_path_without_ext=%file_path_without_ext:~0,-4%"
echo "%file_path_without_ext%"

set "file_ext=%~x1"
set "expected_output_path=%file_path_without_ext%-logo%file_ext%"


echo "Copying %expected_output_path% to clipboard"
call %copy_to_clipboard% "%expected_output_path%"

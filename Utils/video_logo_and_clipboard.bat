@echo off

set current_directory=%~dp0
set path_to_add_logo=%current_directory%/../Video/add_logo.bat
set copy_to_clipboard=%current_directory%/copy_to_clipboard.bat

REM run bat with arguments
call %path_to_add_logo% "%~1"

REM copy to clipboard
set file_path_without_ext=%~dp1%~n1
set file_ext=%~x1
set expected_output_path=%file_path_without_ext%-logo%file_ext%
call %copy_to_clipboard% "%expected_output_path%"

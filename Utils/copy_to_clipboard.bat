<# : fcopy.bat -- https://stackoverflow.com/a/43924711/1683264
@echo off & setlocal

if "%~1"=="" ( goto usage ) else if "%~1"=="/?" goto usage
set args=%*

rem // kludge for PowerShell's reluctance to start in a dir containing []
set "wd=%CD%"

powershell -STA -noprofile "iex (${%~f0} | out-string)"

goto :EOF

:usage
echo Usage: %~nx0 [switch] filemask [filemask [filemask [...]]]
echo    example: %~nx0 *.jpg *.gif *.bmp
echo;
echo Switches:
echo    /L    list current contents of clipboard file droplist
echo    /C    clear clipboard
echo    /X    cut files (Without this switch, the action is copy.)
echo    /A    append files to existing clipboard file droplist
goto :EOF

: end batch / begin powershell #>

$col = new-object Collections.Specialized.StringCollection
Add-Type -AssemblyName System.Windows.Forms
$files = $()
$switches = @{}
# work around PowerShell's inability to start in a directory containing brackets
cd -PSPath $env:wd

# cmd calling PowerShell calling cmd.  Awesome.  Tokenization of arguments and
# expansion of wildcards is profoundly simpler when using a cmd.exe for loop.
$argv = @(
    cmd /c "for %I in ($env:args) do @echo(%~I"
    cmd /c "for /D %I in ($env:args) do @echo(%~I"
) -replace "([\[\]])", "```$1"

$argv | ?{$_.length -gt 3 -and (test-path $_)} | %{ $files += ,(gi -force $_).FullName }
$argv | ?{$_ -match "^[/-]\w\W*$"} | %{
    switch -wildcard ($_) {
        "?a" { $switches["append"] = $true; break }
        "?c" { $switches["clear"] = $true; break }
        "?l" { $switches["list"] = $true; break }
        "?x" { $switches["cut"] = $true; break }
        default { "Unrecognized option: $_"; exit 1 }
    }
}

if ($switches["clear"]) {
    [Windows.Forms.Clipboard]::Clear()
    "<empty>"
    exit
}

if ($switches["list"] -and [Windows.Forms.Clipboard]::ContainsFileDropList()) {
    $cut = [windows.forms.clipboard]::GetData("Preferred DropEffect").ReadByte() -eq 2
    [Windows.Forms.Clipboard]::GetFileDropList() | %{
        if ($cut) { write-host -f DarkGray $_ } else { $_ }
    }
}

if ($files.Length) {

    $data = new-object Windows.Forms.DataObject
    if ($switches["cut"]) { $action = 2 } else { $action = 5 }
    $effect = [byte[]]($action, 0, 0, 0)
    $drop = new-object IO.MemoryStream
    $drop.Write($effect, 0, $effect.Length)

    if ($switches["append"] -and [Windows.Forms.Clipboard]::ContainsFileDropList()) {
        [Windows.Forms.Clipboard]::GetFileDropList() | %{ $files += ,$_ }
    }
    $color = ("DarkGray","Gray")[!$switches["cut"]]
    $files | select -uniq | %{ write-host -f $color $col[$col.Add($_)] }

    $data.SetFileDropList($col)
    $data.SetData("Preferred DropEffect", $drop)

    [Windows.Forms.Clipboard]::Clear()
    [Windows.Forms.Clipboard]::SetDataObject($data, $true)
    $drop.Close()
}
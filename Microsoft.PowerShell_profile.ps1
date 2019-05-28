set-location C:\
clear-host

Function prompt {

  <#  if ($env:userdomain -AND $env:username) {
        $me = "$($env:userdomain)\$($env:username)"
    }
    elseif ($env:LOGNAME) {
        $me = $env:LOGNAME
    }
    else {
        #last resort
        $me = "PSUser"
    } #>
    $me = "Tr4p"

    #define lines of text to include in the box
    $text1 = "[$me] $($executionContext.SessionState.Path.CurrentLocation)"
    $text2 = ((Get-Date).ToString()).trim()

    if ($IsLinux) {
        if ($(id -g) -eq 0 ) {
            #running as SU
            $lineColor = "Red"
        }
        else {
            $lineColor = "Green"
        }
    }
    elseif ($isWindows -or $psEdition -eq 'desktop') {
        $IsAdmin = [System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.WindowsIdentity]::GetCurrent() ).IsInRole("Administrators")
        if ($IsAdmin) {
            $lineColor = "Red"
        }
        else {
            $lineColor = "Green"
        }
    }
    else {
        #for everything else not tested
        $lineColor = "Yellow"
    }

    #get the length of the longest line in the box and uas that to calculate lengths and padding
    $longest = $text1.length, $text2.length | Sort-Object | Select-Object -last 1
    $len = $longest + 2
    $top = "┌$(("─" * $len))┐"
    Write-Host $top -ForegroundColor $lineColor
    Write-Host "│ " -ForegroundColor $lineColor -NoNewline
    Write-Host $text1.PadRight($longest, ' ') -NoNewline
    Write-Host " │" -ForegroundColor $lineColor
    Write-Host "│ " -ForegroundColor $lineColor -NoNewline
    Write-Host $text2.PadRight($longest, ' ') -NoNewline -ForegroundColor yellow
    Write-Host " │" -ForegroundColor $lineColor
    $bottom = "└$(("─" * $len))┘"
    Write-Host $bottom -ForegroundColor $lineColor

    #parse out the PSVersionTable to most meaningful values
    $ver = $(([regex]"\d+\.\d+.\d+").match($psversiontable.psversion).value)

    #the prompt function needs to write something to the pipeline
    " v$($ver) PS$('>' * ($nestedPromptLevel + 1)) "

}

function Get-PSConfEU {
(irm http://powershell.fun )
}

function Disable-AutoProxy
{
	$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
	
	$data = (Get-ItemProperty -Path $key -Name DefaultConnectionSettings).DefaultConnectionSettings
	$data[8] = 1
	Set-ItemProperty -Path $key -Name DefaultConnectionSettings -Value $data
}
clear-host

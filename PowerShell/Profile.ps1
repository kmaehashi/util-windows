# PowerShell Profile
# @author Kenichi Maehashi

# Exit with Ctrl-D
Invoke-Expression "function $([char]4) {exit}"

# History Management
$MaximumHistoryCount = 32767
$HistoryFile = "~/PowerShell_History.csv"
If (Test-Path $HistoryFile) {
	Import-CSV $HistoryFile | Add-History
}
[void] (Register-EngineEvent -SourceIdentifier([System.Management.Automation.PsEngineEvent]::Exiting) -Action {
	[Microsoft.PowerShell.Commands.HistoryInfo[]] $hist = Get-History -Count $MaximumHistoryCount
#	[Array]::Reverse($hist); $hist = ($hist | Select-Object -Unique CommandLine); [Array]::Reverse($hist)
	$hist |? {$_.CommandLine -notlike " *"} | Export-CSV $HistoryFile
})

# Prompt
function prompt() {
	Write-Host -NoNewline -ForegroundColor White ($env:USERNAME + "@" + $env:COMPUTERNAME + " [" + $PWD + "]>")
	return " ";
}

# Get-Type
function Get-Type([Object] $obj = $null) {
	if ($obj -ne $null) {
		$obj.GetType().FullName
	} else {
		foreach($obj in $input) {
			Get-Type $obj
		}
	}
}

# Alias
Remove-Item Alias:ls -Force
Set-Alias ls _ls
Set-Alias ll _ll

Remove-Item Alias:cd -Force
Set-Alias cd _cd
Set-Alias .. _..

Set-Alias gt Get-Type
Set-Alias start. _start.

function _ls() {
	Get-ChildItem $args[0] | Format-Wide Name -AutoSize
}

function _ll() {
	Get-ChildItem $args[0]
}

function _cd() {
	if ($args[0] -eq "-") {
		Pop-Location
	} else {
		Push-Location
		Set-Location $args[0]
	}
}

function _..() {
	Set-Location ..
}

function _start.() {
	start .
}

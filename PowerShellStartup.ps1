
function ocgv_history {
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  $selection = $history | Out-ConsoleGridView -Title "Select CommandLine from History" -OutputMode Single
  if ($selection) {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selection)
    if ($selection.StartsWith($line)) {
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor)
    }
    else {
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selection.Length)
    }    
  }
}


$parameters = @{
  Key = 'F7'
  BriefDescription = 'ShowMatchingHistoryOcgv'
  LongDescription = 'Show Matching History using Out-ConsoleGridView'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example

    $history = Get-History | Sort-Object -Descending -Property Id -Unique | Select-Object CommandLine -ExpandProperty CommandLine 
    $history | ocgv_history
  }
}
Set-PSReadLineKeyHandler @parameters

$parameters = @{
  Key = 'Shift-F7'
  BriefDescription = 'ShowMatchingGlobalHistoryOcgv'
  LongDescription = 'Show Matching History for all PowerShell instances using Out-ConsoleGridView'
  ScriptBlock = {
    param($key, $arg)   # The arguments are ignored in this example
    $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems().CommandLine 
    # reverse the items so most recent is on top
    [array]::Reverse($history) 
    $history | Select-Object -Unique | ocgv_history
  }
}
Set-PSReadLineKeyHandler @parameters

Import-Module posh-git
Import-Module oh-my-posh
Import-Module -Name Terminal-Icons
Set-Theme Paradox
cd c:\dev

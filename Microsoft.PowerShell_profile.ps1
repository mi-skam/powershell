Import-Module PSReadline

# user Emacs key binding
Set-PSReadLineOption -EditMode Emacs

Set-PSReadlineOption -BellStyle None
# Aliases

function which($cmd) { (Get-Command $cmd).Definition }
function whoami { (get-content env:\userdomain) + "\" + (get-content env:\username) }

# Load my scripts (not tests) automatically
Resolve-Path $PSScriptRoot\Scripts\*.ps1 |
Where-Object { -not ($_.ProviderPath.Contains(".Tests.")) } |
Foreach-Object { . $_.ProviderPath }
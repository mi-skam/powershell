Import-Module posh-git
Import-Module PSReadline

# user Emacs key binding
#Set-PSReadLineOption -EditMode Emacs

# Aliases

function CD_WORK { Set-Location E:\work }
Set-Alias cdwork CD_WORK

function CD_CONFIGURATION { Set-Location E:\work\configuration }
Set-Alias cdconfig CD_CONFIGURATION
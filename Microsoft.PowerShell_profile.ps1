Import-Module posh-git
Import-Module PSReadline

# user Emacs key binding
Set-PSReadLineOption -EditMode Emacs

# Aliases

function EDIT_CONFIGURATION { 
    cd $env:HOME\Documents\PowerShell\
    explorer Microsoft.PowerShell_profile.ps1
}
Set-Alias Edit-Configuration EDIT_CONFIGURATION
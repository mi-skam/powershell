# Install-Package iTextSharp -Scope CurrentUser
Add-Type -Path "$env:LOCALAPPDATA\PackageManagement\NuGet\Packages\iTextSharp.5.5.13.1\lib\itextsharp.dll"

function Merge-Pdf() {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string[]]$Filenames,
    [Parameter()]
    [string]$OutFile = "$(Join-Path $pwd "merge.pdf")"
  )

  # Create a "merge.pdf"
  $doc = New-Object iTextSharp.text.Document
  $fs = [System.IO.FileStream]::new($OutFile, [System.IO.FileMode]::Create)
  $writer = New-Object iTextSharp.text.pdf.PdfCopy($doc, $fs)
  $doc.Open()

  # Merge them document by document
  foreach ($filename in $filenames) {
    $reader = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $filename
    $reader.ConsolidateNamedDestinations()  
    for ($i = 1; $i -le $reader.NumberOfPages; $i++) {
      $page = $writer.GetImportedPage($reader, $i)
      $writer.AddPage($page)
    }
    $reader.Close()
  }
  $writer.Close()
  $doc.Close()
}

function Remove-PdfPage() {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string]$Filename,
    [string]$Page = $( Read-Host "Enter the page, that should be removed" ),

    [Parameter()]
    [string]$OutFile = "$(Join-Path $pwd "edit.pdf")"

  )

  # Create  a "edit.pdf"
  $doc = New-Object iTextSharp.text.Document
  $fs = [System.IO.FileStream]::new($OutFile, [System.IO.FileMode]::Create)
  $writer = New-Object iTextSharp.text.pdf.PdfCopy($doc, $fs)
  $doc.Open()

  # Remove page
  $reader = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $Filename
  $reader.ConsolidateNamedDestinations()  
  for ($i = 1; $i -le $reader.NumberOfPages; $i++) {
    if ($i -ne $Page ) {

      $currentPage = $writer.GetImportedPage($reader, $i)
      $writer.AddPage($currentPage)
    }
  }
  $reader.Close()

  # Tear-Downs
  $writer.Close()
  $doc.Close()

}

function Convert-Endings()
{
  # Change the line endings of a text file to: Windows (CR/LF), Unix (LF) or Mac (CR)

  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$True,Position=1)]
      [ValidateSet("mac","unix","win")] 
      [string]$lineEnding,
    [Parameter(Mandatory=$True)]
      [string]$file
  )

  # Convert the friendly name into a PowerShell EOL character
  Switch ($lineEnding) {
    "mac"  { $eol="`r" }
    "unix" { $eol="`n" }
    "win"  { $eol="`r`n" }
  } 

  # Replace CR+LF with LF
  $text = [IO.File]::ReadAllText($file) -replace "`r`n", "`n"
  [IO.File]::WriteAllText($file, $text)

  # Replace CR with LF
  $text = [IO.File]::ReadAllText($file) -replace "`r", "`n"
  [IO.File]::WriteAllText($file, $text)

  #  At this point all line-endings should be LF.

  # Replace LF with intended EOL char
  if ($eol -ne "`n") {
    $text = [IO.File]::ReadAllText($file) -replace "`n", $eol
    [IO.File]::WriteAllText($file, $text)
  }
  Echo "   ** Completed **"
}

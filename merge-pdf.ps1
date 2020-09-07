# Install-Package iTextSharp -Scope CurrentUser
Add-Type -Path "$env:LOCALAPPDATA\PackageManagement\NuGet\Packages\iTextSharp.5.5.13.1\lib\itextsharp.dll"

# Create a "merge.pdf"
$doc = New-Object iTextSharp.text.Document
$fs = [System.IO.FileStream]::new($(Join-Path $home\Downloads merge.pdf), [System.IO.FileMode]::Create)
$writer = New-Object iTextSharp.text.pdf.PdfCopy($doc, $fs)
$doc.Open()

# Select the files, which will be merged
[string[]]$filenames = $(Join-Path $home\Downloads "Deckblatt_BA.pdf"), $(Join-Path $home\Downloads "Bachelor_Final.pdf")

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
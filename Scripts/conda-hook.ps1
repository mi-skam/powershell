$Env:CONDA_EXE = "C:/tools/miniconda3\Scripts\conda.exe"
$Env:_CE_M = ""
$Env:_CE_CONDA = ""
$Env:_CONDA_ROOT = "C:/tools/miniconda3"
$Env:_CONDA_EXE = "C:/tools/miniconda3\Scripts\conda.exe"

Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1"
Add-CondaEnvironmentToPrompt
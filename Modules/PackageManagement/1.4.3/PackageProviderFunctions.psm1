﻿###
# ==++==
#
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###

<#
	Overrides the default Write-Debug so that the output gets routed back thru the
	$request.Debug() function
#>
function Write-Debug {
	param(
	[Parameter(Mandatory=$true)][string] $message,
	[parameter(ValueFromRemainingArguments=$true)]
	[object[]]
	 $args= @()
	)

	if( -not $request  ) {
		if( -not $args  ) {
			Microsoft.PowerShell.Utility\write-verbose $message
			return
		}

		$msg = [system.string]::format($message, $args)
		Microsoft.PowerShell.Utility\write-verbose $msg
		return
	}

	if( -not $args  ) {
		$null = $request.Debug($message);
		return
	}
	$null = $request.Debug($message,$args);
}

function Write-Error {
	param( 
		[Parameter(Mandatory=$true)][string] $Message,
		[Parameter()][string] $Category,
		[Parameter()][string] $ErrorId,
		[Parameter()][string] $TargetObject
	)

	$null = $request.Warning($Message);
}

<#
	Overrides the default Write-Verbose so that the output gets routed back thru the
	$request.Verbose() function
#>

function Write-Progress {
    param(
        [CmdletBinding()]

        [Parameter(Position=0)]
        [string]
        $Activity,

        # This parameter is not supported by request object
        [Parameter(Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Status,

        [Parameter(Position=2)]
        [ValidateRange(0,[int]::MaxValue)]
        [int]
        $Id,

        [Parameter()]
        [int]
        $PercentComplete=-1,

        # This parameter is not supported by request object
        [Parameter()]
        [int]
        $SecondsRemaining=-1,

        # This parameter is not supported by request object
        [Parameter()]
        [string]
        $CurrentOperation,        

        [Parameter()]
        [ValidateRange(-1,[int]::MaxValue)]
        [int]
        $ParentID=-1,

        [Parameter()]
        [switch]
        $Completed,

        # This parameter is not supported by request object
        [Parameter()]
        [int]
        $SourceID,

	    [object[]]
        $args= @()
    )

    $params = @{}

    if ($PSBoundParameters.ContainsKey("Activity")) {
        $params.Add("Activity", $PSBoundParameters["Activity"])
    }

    if ($PSBoundParameters.ContainsKey("Status")) {
        $params.Add("Status", $PSBoundParameters["Status"])
    }

    if ($PSBoundParameters.ContainsKey("PercentComplete")) {
        $params.Add("PercentComplete", $PSBoundParameters["PercentComplete"])
    }

    if ($PSBoundParameters.ContainsKey("Id")) {
        $params.Add("Id", $PSBoundParameters["Id"])
    }

    if ($PSBoundParameters.ContainsKey("ParentID")) {
        $params.Add("ParentID", $PSBoundParameters["ParentID"])
    }

    if ($PSBoundParameters.ContainsKey("Completed")) {
        $params.Add("Completed", $PSBoundParameters["Completed"])
    }

	if( -not $request  ) {    
		if( -not $args  ) {
			Microsoft.PowerShell.Utility\Write-Progress @params
			return
		}

		$params["Activity"] = [system.string]::format($Activity, $args)
		Microsoft.PowerShell.Utility\Write-Progress @params
		return
	}

	if( -not $args  ) {
        $request.Progress($Activity, $Status, $Id, $PercentComplete, $SecondsRemaining, $CurrentOperation, $ParentID, $Completed)
	}

}

function Write-Verbose{
	param(
	[Parameter(Mandatory=$true)][string] $message,
	[parameter(ValueFromRemainingArguments=$true)]
	[object[]]
	 $args= @()
	)

	if( -not $request ) {
		if( -not $args ) {
			Microsoft.PowerShell.Utility\write-verbose $message
			return
		}

		$msg = [system.string]::format($message, $args)
		Microsoft.PowerShell.Utility\write-verbose $msg
		return
	}

	if( -not $args ) {
		$null = $request.Verbose($message);
		return
	}
	$null = $request.Verbose($message,$args);
}

<#
	Overrides the default Write-Warning so that the output gets routed back thru the
	$request.Warning() function
#>

function Write-Warning{
	param(
	[Parameter(Mandatory=$true)][string] $message,
	[parameter(ValueFromRemainingArguments=$true)]
	[object[]]
	 $args= @()
	)

	if( -not $request ) {
		if( -not $args ) {
			Microsoft.PowerShell.Utility\write-warning $message
			return
		}

		$msg = [system.string]::format($message, $args)
		Microsoft.PowerShell.Utility\write-warning $msg
		return
	}

	if( -not $args ) {
		$null = $request.Warning($message);
		return
	}
	$null = $request.Warning($message,$args);
}

<#
	Creates a new instance of a PackageSource object
#>
function New-PackageSource {
	param(
		[Parameter(Mandatory=$true)][string] $name,
		[Parameter(Mandatory=$true)][string] $location,
		[Parameter(Mandatory=$true)][bool] $trusted,
		[Parameter(Mandatory=$true)][bool] $registered,
		[bool] $valid = $false,
		[System.Collections.Hashtable] $details = $null
	)

	return New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.PackageSource -ArgumentList $name,$location,$trusted,$registered,$valid,$details
}

<#
	Creates a new instance of a SoftwareIdentity object
#>
function New-SoftwareIdentity {
	param(
		[Parameter(Mandatory=$true)][string] $fastPackageReference,
		[Parameter(Mandatory=$true)][string] $name,
		[Parameter(Mandatory=$true)][string] $version,
		[Parameter(Mandatory=$true)][string] $versionScheme,
		[Parameter(Mandatory=$true)][string] $source,
		[string] $summary,
		[string] $searchKey = $null,
		[string] $fullPath = $null,
		[string] $filename = $null,
		[System.Collections.Hashtable] $details = $null,
		[System.Collections.ArrayList] $entities = $null,
		[System.Collections.ArrayList] $links = $null,
		[bool] $fromTrustedSource = $false,
		[System.Collections.ArrayList] $dependencies = $null,
		[string] $tagId = $null,
		[string] $culture = $null,
        [string] $destination = $null
	)
	return New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.SoftwareIdentity -ArgumentList $fastPackageReference, $name, $version,  $versionScheme,  $source,  $summary,  $searchKey, $fullPath, $filename , $details , $entities, $links, $fromTrustedSource, $dependencies, $tagId, $culture, $destination
}

<#
	Creates a new instance of a SoftwareIdentity object based on an xml string
#>
function New-SoftwareIdentityFromXml {
    param(
        [Parameter(Mandatory=$true)][string] $xmlSwidtag,
        [bool] $commitImmediately = $false
    )

    return New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.SoftwareIdentity -ArgumentList $xmlSwidtag, $commitImmediately
}

<#
	Creates a new instance of a DyamicOption object
#>
function New-DynamicOption {
	param(
		[Parameter(Mandatory=$true)][Microsoft.PackageManagement.MetaProvider.PowerShell.OptionCategory] $category,
		[Parameter(Mandatory=$true)][string] $name,
		[Parameter(Mandatory=$true)][Microsoft.PackageManagement.MetaProvider.PowerShell.OptionType] $expectedType,
		[Parameter(Mandatory=$true)][bool] $isRequired,
		[System.Collections.ArrayList] $permittedValues = $null
	)

	if( -not $permittedValues ) {
		return New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.DynamicOption -ArgumentList $category,$name,  $expectedType, $isRequired
	}
	return New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.DynamicOption -ArgumentList $category,$name,  $expectedType, $isRequired, $permittedValues.ToArray()
}

<#
	Creates a new instance of a Feature object
#>
function New-Feature {
	param(
		[Parameter(Mandatory=$true)][string] $name,
		[System.Collections.ArrayList] $values = $null
	)

	if( -not $values ) {
		return New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.Feature -ArgumentList $name
	}
	return New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.Feature -ArgumentList $name, $values.ToArray()
}

<#
	Duplicates the $request object and overrides the client-supplied data with the specified values.
#>
function New-Request {
	param(
		[System.Collections.Hashtable] $options = $null,
		[System.Collections.ArrayList] $sources = $null,
		[PSCredential] $credential = $null
	)

	return $request.CloneRequest( $options, $sources, $credential )
}

function New-Entity {
	param(
		[Parameter(Mandatory=$true)][string] $name,
		[Parameter(Mandatory=$true,ParameterSetName="role")][string] $role,
		[Parameter(Mandatory=$true,ParameterSetName="roles")][System.Collections.ArrayList]$roles,
        [string] $regId = $null,
        [string] $thumbprint= $null
	)

	$o = New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.Entity
	$o.Name = $name

	# support role as a NMTOKENS string or an array of strings
	if( $role ) {
		$o.Role = $role
	} 
	if( $roles )  {
		$o.Roles = $roles
	}

	$o.regId = $regId
	$o.thumbprint = $thumbprint
	return $o
}

function New-Link {
	param(
		[Parameter(Mandatory=$true)][string] $HRef,
		[Parameter(Mandatory=$true)][string] $relationship,
		[string] $mediaType = $null,
		[string] $ownership = $null,
		[string] $use= $null,
		[string] $appliesToMedia= $null,
		[string] $artifact = $null
	)

	$o = New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.Link

	$o.HRef = $HRef
	$o.Relationship =$relationship
	$o.MediaType =$mediaType
	$o.Ownership =$ownership
	$o.Use = $use
	$o.AppliesToMedia = $appliesToMedia
	$o.Artifact = $artifact

	return $o
}

function New-Dependency {
	param(
		[Parameter(Mandatory=$true)][string] $providerName,
		[Parameter(Mandatory=$true)][string] $packageName,
		[string] $version= $null,
		[string] $source = $null,
		[string] $appliesTo = $null
	)

	$o = New-Object -TypeName Microsoft.PackageManagement.MetaProvider.PowerShell.Dependency

	$o.ProviderName = $providerName
	$o.PackageName =$packageName
	$o.Version =$version
	$o.Source =$source
	$o.AppliesTo = $appliesTo

	return $o
}
# SIG # Begin signature block
# MIIjhgYJKoZIhvcNAQcCoIIjdzCCI3MCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDs5FoY/w7B0Miq
# Kfi0Wb7Z3JGNbdfm1vY/fLsAXNclnKCCDYEwggX/MIID56ADAgECAhMzAAABUZ6N
# j0Bxow5BAAAAAAFRMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTkwNTAyMjEzNzQ2WhcNMjAwNTAyMjEzNzQ2WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCVWsaGaUcdNB7xVcNmdfZiVBhYFGcn8KMqxgNIvOZWNH9JYQLuhHhmJ5RWISy1
# oey3zTuxqLbkHAdmbeU8NFMo49Pv71MgIS9IG/EtqwOH7upan+lIq6NOcw5fO6Os
# +12R0Q28MzGn+3y7F2mKDnopVu0sEufy453gxz16M8bAw4+QXuv7+fR9WzRJ2CpU
# 62wQKYiFQMfew6Vh5fuPoXloN3k6+Qlz7zgcT4YRmxzx7jMVpP/uvK6sZcBxQ3Wg
# B/WkyXHgxaY19IAzLq2QiPiX2YryiR5EsYBq35BP7U15DlZtpSs2wIYTkkDBxhPJ
# IDJgowZu5GyhHdqrst3OjkSRAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUV4Iarkq57esagu6FUBb270Zijc8w
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDU0MTM1MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAWg+A
# rS4Anq7KrogslIQnoMHSXUPr/RqOIhJX+32ObuY3MFvdlRElbSsSJxrRy/OCCZdS
# se+f2AqQ+F/2aYwBDmUQbeMB8n0pYLZnOPifqe78RBH2fVZsvXxyfizbHubWWoUf
# NW/FJlZlLXwJmF3BoL8E2p09K3hagwz/otcKtQ1+Q4+DaOYXWleqJrJUsnHs9UiL
# crVF0leL/Q1V5bshob2OTlZq0qzSdrMDLWdhyrUOxnZ+ojZ7UdTY4VnCuogbZ9Zs
# 9syJbg7ZUS9SVgYkowRsWv5jV4lbqTD+tG4FzhOwcRQwdb6A8zp2Nnd+s7VdCuYF
# sGgI41ucD8oxVfcAMjF9YX5N2s4mltkqnUe3/htVrnxKKDAwSYliaux2L7gKw+bD
# 1kEZ/5ozLRnJ3jjDkomTrPctokY/KaZ1qub0NUnmOKH+3xUK/plWJK8BOQYuU7gK
# YH7Yy9WSKNlP7pKj6i417+3Na/frInjnBkKRCJ/eYTvBH+s5guezpfQWtU4bNo/j
# 8Qw2vpTQ9w7flhH78Rmwd319+YTmhv7TcxDbWlyteaj4RK2wk3pY1oSz2JPE5PNu
# Nmd9Gmf6oePZgy7Ii9JLLq8SnULV7b+IP0UXRY9q+GdRjM2AEX6msZvvPCIoG0aY
# HQu9wZsKEK2jqvWi8/xdeeeSI9FN6K1w4oVQM4Mwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVWzCCFVcCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAVGejY9AcaMOQQAAAAABUTAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgW1aUJ//A
# XoZtrMMt6G72ZLxYaJSbe1y7/kqmNcIIh6wwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQAoon9aywDgX0MhcHmwWJqgYX7Q//jyhdAhPKmZheTl
# K0rlPbuv1/MB8KLSSdKwgS/3uUlLvDTssCDFvEfwIJw5PJSVCAb8dF1KpYvFyc6j
# 1pYGELg5WOUN2lpuMaLi12FngvINKQcefy7TjIgoY86bq38a1wK2y64A8YWvf3Fl
# h3MSGDsS+2emxdb9bpmJnvNbYn200+zIhFup+vkVp73ocjkgbedarJ8bU+rD3hpJ
# iBHeuK/5s3MA1M9ydEEVvNf6rT3mHXzCyFaKnwzH9l0L79RC4GzUT6/Fpvz2cI48
# Rd4jKFqyvcmw7fj6UZQ96CMbptiQzkplMDK2J48TW7vioYIS5TCCEuEGCisGAQQB
# gjcDAwExghLRMIISzQYJKoZIhvcNAQcCoIISvjCCEroCAQMxDzANBglghkgBZQME
# AgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASCATwwggE4AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIJlawWI7jHUMRVRvl4gnonR6ZRb9xJsAOcWcLKVE
# X4aJAgZcyyNhT2YYEzIwMTkwNzAxMjEwNTExLjIxMVowBIACAfSggdCkgc0wgcox
# CzAJBgNVBAYTAlVTMQswCQYDVQQIEwJXQTEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQg
# SXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1Mg
# RVNOOjA4NDItNEJFNi1DMjlBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
# cCBzZXJ2aWNloIIOPDCCBPEwggPZoAMCAQICEzMAAADYGuTMP3oR+uEAAAAAANgw
# DQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcN
# MTgwODIzMjAyNjUxWhcNMTkxMTIzMjAyNjUxWjCByjELMAkGA1UEBhMCVVMxCzAJ
# BgNVBAgTAldBMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlv
# bnMgTGltaXRlZDEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046MDg0Mi00QkU2LUMy
# OUExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIHNlcnZpY2UwggEiMA0G
# CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCUHjDkh1r1sGi48zCSTVJSLXVD5jFU
# XiSAruKahoBAeXEFg3XtdL97JewT2vEmLeGEPSdc5norl6+e6ZohVj/88wKR+w0l
# /AXEbbg2gM8g7XZ7UoGBBYj3fTJbNLk9BoAI4Q0+CyCLsJEUNxvXBJkX0KheXr3I
# ptpDZoagBlk/T3UaFHmTOfG6Yce5zRJ5LHQyvE0O9RnJDJMN5DoR5/zMZX7A2FF0
# DHXf4C/AWQQPYHQOV1fmNufxBlSwD4GFbOu1R8dL+SzNUze77HpTqg+6eLTUSsHN
# eVr4YKzrN81vmCx6aIu5iuWwcUWxwx7TgbqGr2ddg/V49W8iu9UsMvVDAgMBAAGj
# ggEbMIIBFzAdBgNVHQ4EFgQUn7ZWSx7uFNXfinZ6moMa55DjZuQwHwYDVR0jBBgw
# FoAU1WM6XIoxkPNDe3xGG8UzaFqFbVUwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDov
# L2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljVGltU3RhUENB
# XzIwMTAtMDctMDEuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0
# cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNUaW1TdGFQQ0FfMjAx
# MC0wNy0wMS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDCDAN
# BgkqhkiG9w0BAQsFAAOCAQEADlJwdt7IPyC1NLe7AZze8No7Mnd84D5SMHfxiRpL
# eOYXz+bgZ+I/b8Bn6bCg2XoS7UKbf0aeouUqu/TckDsOC6+fko0uW1LpOROUpCvc
# 9WTGv0VXj/oJAuXZRJTR3qeZHOgiYZ0qCyJShOyIImJKb43Ygz4t0k/JA0q5E+z2
# W/D2nKDVV+zTnK8SnROQ55WKeoJq9pBcJjd1nf7HvYd1MlyFhF3OwdCPFrM/Ftsc
# LO6GKVBivXpe03K9I2KsogJh27sCKXd07TN1hqUOVM54sVJbZofPnJEwig+NOhYS
# RijhS4T/fRa1VcLQ2rwhNMyQc9U++Q+W3+I2K8aDm0lOsTCCBnEwggRZoAMCAQIC
# CmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRp
# ZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIxMzY1NVoXDTI1MDcwMTIx
# NDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX9fp/aZRrdFQQ1aUKAIKF
# ++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkTjnxhMFmxMEQP8WCIhFRD
# DNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhHhjKEHnRhZ5FfgVSx
# z5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGKr0tkiVBisV39dx898Fd1
# rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox8NpOBpG2iAg16Hgc
# sOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEFTyJNAgMBAAGjggHmMIIB
# 4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIoxkPNDe3xGG8UzaFqF
# bVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1Ud
# EwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQwVgYD
# VR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwv
# cHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEB
# BE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9j
# ZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwgaAGA1UdIAEB/wSBlTCB
# kjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRtMEAGCCsGAQUFBwICMDQe
# MiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEAdABlAG0AZQBuAHQA
# LiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/gXEDPZ2joSFvs+umzPUx
# vs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgrUYJEEvu5U4zM9GAS
# inbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9Wj8c8pl5SpFSAK84Dxf1
# L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFwnzJKJ/1Vry/+tuWO
# M7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOdeyFtw5yjojz6f32WapB4
# pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1JeVk7Pf0v35jWSUPei45
# V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4TtxCd9ddJgiCGHasFAeb73x
# 4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5u+zGy9iCtHLNHfS4hQEe
# gPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3yKxO2ii4sanblrKn
# QqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Zta7cRDyXUHHXodLFVeNp
# 3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wknHNWzfjUeCLraNtvT
# X4/edIhJEqGCAs4wggI3AgEBMIH4oYHQpIHNMIHKMQswCQYDVQQGEwJVUzELMAkG
# A1UECBMCV0ExEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9u
# cyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjowODQyLTRCRTYtQzI5
# QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgc2VydmljZaIjCgEBMAcG
# BSsOAwIaAxUAZTHB3RFeHZDsjSiiSRUIWWArIoGggYMwgYCkfjB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAODEuwgwIhgPMjAx
# OTA3MDIwMTAyMDBaGA8yMDE5MDcwMzAxMDIwMFowdzA9BgorBgEEAYRZCgQBMS8w
# LTAKAgUA4MS7CAIBADAKAgEAAgIg4QIB/zAHAgEAAgIRtzAKAgUA4MYMiAIBADA2
# BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIB
# AAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBAAxQhw7P0tSm1QyVnPibIfU6y8HOYQL7
# CJhpz3Y/wgqKZFd1r2C1U6ar7LQAdoK5JWFZHFItD1TbKHwvOpkKS8Bg7oOy145J
# z3wUCew/07HxZxTyJZiUHHZasDPHsUQTDvXYFtyO1Vxwd2FVGA0A5dYTaS6pnucw
# GnJ1GzgBdXdcMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
# IDIwMTACEzMAAADYGuTMP3oR+uEAAAAAANgwDQYJYIZIAWUDBAIBBQCgggFKMBoG
# CSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQg/AusCP8r
# 9tB2b60ZPIOVj9kLXZooh9qvU3rUYM7a9NowgfoGCyqGSIb3DQEJEAIvMYHqMIHn
# MIHkMIG9BCBzO53HeFzo83Yp/++Elao9KUDRbwoE/yBrzBOfQS7YLTCBmDCBgKR+
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAA2BrkzD96EfrhAAAA
# AADYMCIEIP+ejoqBV+mJL9KzQpmdz5VFvW5WYpTSJ+P5mGlwZnanMA0GCSqGSIb3
# DQEBCwUABIIBAFK71D+svpycUqlW5nij62QmpfeFDMNsHKZ+/T9JIi4qL7lZOsyr
# ijP7STTWbKmpapADWa2vFFz8DweQXwqe0hdYCCjw+Hc2ZCNBwFoQk0nzOOQsPaKR
# G1jnea5Ktc9iU65Oh1KHXZ2DVmaW9ofWW9G9iB8aelzNZKJFYKYPyuAegAQwSg0G
# GJcth562gOhUgcTEdKA1btO+mZ5Qvj3tr/8C2ANA9gvbl7w5gr7eONSM9JLkT3bI
# +USUgQ+yIxIu7rPtzQAXwNc9lcKivuCLWZ91qNuIhjaDMnw3OSRFOVexz6M9md5b
# tzte3WlsHMaPYglzOQdCHIUJr3M9Brnwd4A=
# SIG # End signature block

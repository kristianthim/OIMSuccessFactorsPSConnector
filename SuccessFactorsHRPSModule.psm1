# Module file for SuccessFactors PowerShell Module
# Not aligned with template
function Get-SFHeaders
{
    param(
        [string]$token
    )

    $headers = @{ 
        "Authorization" = "Bearer $($token)" 
        "Content-Type" = "application/json;charset=utf-8"
        "Accept"       = "application/json;charset=utf-8"
    }

    return $headers
}



function Get-SFAssertion
{
    param(
        [string]$BaseUrl,
        [string]$User_id,
        [string]$client_id,
        [string]$token_url,
        [string]$private_key
    )

    $uri = "$BaseUrl/oauth/idp"

    $assertionHeader = @{
        "Content-Type" = "application/x-www-form-urlencoded"
    }
    
    $body = @{
        user_id         = $User_id
        client_id       = $client_id
        token_url       = $token_url
        private_key     = $private_key

    }

    return Invoke-RestMethod -Method Post -Uri $uri -Headers $assertionHeader -Body $body
}

function Get-SFToken
{
    param(
        [string]$BaseUrl,
        [String]$client_id,
        [String]$company_id,
        [String]$grant_type,
        [String]$assertion
        # Planned support for new_token
        #[bool]$new_token
    )

    $uri = "$BaseUrl/oauth/token"

    $tokenHeader = @{
        "Content-Type" = "application/x-www-form-urlencoded"
    }
    
    $body = @{
        client_id         = $client_id
        company_id        = $company_id
        grant_type        = $grant_type
        assertion         = $assertion
        #new_token         = $new_token
    }

    return Invoke-RestMethod -Method Post -Uri $uri -Headers $tokenHeader -Body $body
}

function Invoke-SFRestMethod
{
    param(
        [string]$BaseUrl,
        [string]$EndPoint,
        [string]$Append,
        [string]$ApiKey
    )
    
    $headers        = Get-SFHeaders -token $ApiKey
    $uri            = $BaseUrl + '/' + $EndPoint + $Append
    $result         = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
    $rows = $result.d.results

    While($result.d.__Next){
        $result     = Invoke-RestMethod -Method Get -Uri $result.d.__Next -Headers $headers
        $rows       += $result.d.Results
    }
    return $rows
    
}

function Get-SFUser
{
    param(
        [string]$BaseUrl,         [string]$ApiKey,
        [string]$Append
    )
    
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/User" -Append $Append
}

function Get-SFEmployments
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/EmpEmployment" -Append $Append
}

function Get-SFJobs
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/EmpJob" -Append $Append
}

function Get-SFCostCenter
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/FOCostCenter" -Append $Append
}

function Get-SFPosition
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/Position" -Append $Append
}


function Get-SFDepartment
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint 'odata/v2/FODepartment?$expand=parentNav,headOfUnitNav' -Append $Append
}

function Get-SFCompany
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/FOCompany" -Append $Append
}

function Get-SFLocation
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint 'odata/v2/FOLocation?$expand=addressNavDEFLT' -Append $Append
}

function Get-SFJobFunction
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint 'odata/v2/FOJobFunction?$expand=parentFunctionCodeNav' -Append $Append
}

function Get-SFPerPerson
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/PerPerson" -Append $Append
}

function Get-SFPerPersonal
{
    param(
        [string]$BaseUrl,
        [string]$ApiKey,
        [string]$Append
    )
    return Invoke-SFRestMethod -BaseUrl $BaseUrl -ApiKey $ApiKey -EndPoint "odata/v2/PerPersonal" -Append $Append
}

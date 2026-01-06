Import-Module ".\SuccessFactorPSModule.psm1" -Force -Verbose
# Set variables
# Replace the placeholders with actual values
# Base URL of the SuccessFactors instance
# Locate your SF URL here: https://help.sap.com/docs/SAP_SUCCESSFACTORS_EMPLOYEE_CENTRAL/1f3b2f3f3f8e4b4ea5d6e2c6f8c8e4b4/4.0/en-US/7a5e4b3f3f8e4b4ea5d6e2c6f8c8e4b4.htmls
$script:_baseUrl     = "https://api012.successfactors.eu"
$script:_AuthUrl     = " $($script:_baseUrl)"
$script:_clientId    = "[ClientId]"
$script:_privateKey  = "[PrivateKey]"
$script:_tokenURL    = "$($script:_baseUrl)/oauth/token"
$script:_userId      = "[UserId]"
$script:_companyId   = "[CompanyId]"
$script:_grantType   = "urn:ietf:params:oauth:grant-type:saml2-bearer"

# Authentication
$assertion = Get-SFAssertion -BaseUrl "$($script:_AuthUrl)" -client_id $script:_clientId -token_url $script:_tokenURL -private_key $script:_privateKey -User_id $script:_userId
$token     = Get-SFToken -BaseUrl $script:_AuthUrl -client_id $script:_clientId -grant_type $script:_grantType -company_id $script:_companyId -assertion $assertion
# Get Data examples
# All data
$jobs           = Get-SFJobs -BaseUrl $script:_baseUrl -ApiKey $token.access_token -Append ''
# Future data
$employments    = Get-SFEmployments     -BaseUrl $script:_baseUrl -ApiKey $token.access_token -Append '?fromDate=2026-01-31&toDate=2026-02-28&$filter=startDate gt datetime''2025-11-29T23:59:59Z'''
$positions      = Get-SFPosition        -BaseUrl $script:_baseUrl -ApiKey $token.access_token -Append '?fromDate=2026-01-31&toDate=2026-02-28&$filter=effectiveStartDate gt datetime''2025-11-29T23:59:59Z'''                                                                                         # - Fra "I morgen" til "30 dage frem"
$jobs           = Get-SFJobs -BaseUrl $script:_baseUrl -ApiKey $token.access_token -Append '?fromDate=2026-01-31&toDate=2026-02-28&$filter=startDate gt datetime''2025-11-29T23:59:59Z'''
# Specific object
$users          = Get-SFUser -BaseUrl $script:_baseUrl -ApiKey $token.access_token -Append "('11140023')"




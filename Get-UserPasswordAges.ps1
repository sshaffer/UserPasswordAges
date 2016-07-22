function Get-UserPasswordAges{
    [cmdletbinding()]

    param(
        [Parameter(Mandatory=$True)][string]$SearchBase,
        [int]$MaxExpiresInDays
            )
        

    try {
        Write-Verbose 'Attempting to import the ActiveDirectory module.'
        Import-Module -Name ActiveDirectory
    }
    catch {
        Write-Error 'ERROR:  There was an error importing the ActiveDirectory module.'
    }

    $MaxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
    $Users = Get-ADUser -Filter 'pwdLastSet -ne 0' -SearchBase $SearchBase -Properties *

    foreach ($User in $Users)
    {
        $PasswordAge = (Get-Date) - $User.PasswordLastSet
        $PassWordAgeDays = $PasswordAge.Days
        $ExpiresDays = $MaxPasswordAge - $PassWordAgeDays

       if (($MaxExpiresInDays -ne $null) -and ($ExpiresDays -ge 0) -and ($ExpiresDays -le $MaxExpiresInDays)) {
        Write-Verbose 'If statement matched.  Generating object.'
        $props = @{
            'Name' = $User.Name
            'UserName' = $User.SamAccountName
            'FirstName' = $User.GivenName
            'LastName' = $User.SurName
            'EmailAddress' = $User.EmailAddress
            'PasswordAgeDays' = $PassWordAgeDays
            'PasswordExpiresDays' = $ExpiresDays
        }
        $obj = New-Object -TypeName PSobject -Property $props
        Write-Output $obj
       }
       ElseIf ($MaxExpiresInDays -eq $null) {
       Write-Verbose 'Else condition matched.  Generating object.'
        $props = @{
            'Name' = $User.Name
            'UserName' = $User.SamAccountName
            'FirstName' = $User.GivenName
            'LastName' = $User.SurName
            'EmailAddress' = $User.EmailAddress
            'PasswordAgeDays' = $PassWordAgeDays
            'PasswordExpiresDays' = $ExpiresDays
        }
        $obj = New-Object -TypeName PSobject -Property $props
        Write-Output $obj
        }
    }
}

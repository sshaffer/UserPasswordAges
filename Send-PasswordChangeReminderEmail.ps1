function Send-PasswordChangeReminderEmail{
[cmdletbinding(SupportsShouldProcess=$true)]

param(
    [Parameter(ValueFromPipeline=$true)]$InputObject,
    #[Parameter(Mandatory=$True)][string[]]$Recipient,
    [Parameter(Mandatory=$True)][string]$Sender,
    [Parameter(Mandatory=$True)][string]$EmailServer,
    $MessageBody
    )


Begin{
    Write-Verbose 'Begin Block'
    $Subject = 'Your password is expiring soon.'
    if (-not $MessageBody){ $MessageBodySpecified = $false }
    Else { $MessageBodySpecified = $true}
}

Process{
    Write-Verbose 'Process Block'
    $Name = $InputObject.Name
    $UserName = $InputObject.UserName
    $EmailAddress = $InputObject.EmailAddress
    $PasswordExpiresDays = $InputObject.PasswordExpiresDays
    $FirstName = $InputObject.FirstName
    $LastName = $InputObject.LastName
    # -To will be $InputObject.EmailAddress or just $EmailAddress
    if ($MessageBodySpecified -eq $true){
        Write-Verbose "`$MessageBodySpecified evaluated to $MessageBodySpecified"
        Send-MailMessage -From $Sender -To $EmailAddress -SmtpServer $EmailServer -Subject $Subject -Body ($MessageBody -f $Name,$FirstName,$LastName,$UserName,$PasswordExpiresDays) -BodyAsHtml -Priority High
    }
    else{
        Write-Verbose "`$MessageBodySpecified evaluated to $MessageBodySpecified"
        $MessageBody = "<b>$FirstName</b>,<br>Your password expires in <b>$PasswordExpiresDays</b> days.  Please change it soon to avoid connectivity issues."
        Send-MailMessage -From $Sender -To $EmailAddress -SmtpServer $EmailServer -Subject $Subject -Body $MessageBody -BodyAsHtml -Priority High
    }
    
}

End{
    Write-Verbose 'End Block'
}


}
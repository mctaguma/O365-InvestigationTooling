# Refer to https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/exchange-online-powershell-v2/exchange-online-powershell-v2?view=exchange-ps
# Refer to https://www.powershellgallery.com/packages/ExchangeOnlineManagement/0.4578.0
# Run the following in an administrative PowerShell session, to install the Exchange Online PowerShell module: Install-Module ExchangeOnlineManagement; Update-Module ExchangeOnlineManagement
# This script can be run in a limited user PowerShell session

Connect-ExchangeOnline

#Enable global audit logging
foreach ($mailbox in Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" -or RecipientTypeDetails -eq "SharedMailbox" -or RecipientTypeDetails -eq "RoomMailbox" -or RecipientTypeDetails -eq "DiscoveryMailbox"})
{
    try
    {
        Set-Mailbox -Identity $mailbox.DistinguishedName -AuditEnabled $true -AuditLogAgeLimit 180 -AuditAdmin Update, MoveToDeletedItems, SoftDelete, HardDelete, SendAs, SendOnBehalf, Create, UpdateFolderPermission -AuditDelegate Update, SoftDelete, HardDelete, SendAs, Create, UpdateFolderPermissions, MoveToDeletedItems, SendOnBehalf -AuditOwner UpdateFolderPermission, MailboxLogin, Create, SoftDelete, HardDelete, Update, MoveToDeletedItems
    }
    catch
    {
        Write-Warning $_.Exception.Message
    }
}

#Double-Check It!
Get-Mailbox -ResultSize Unlimited | Select Name, AuditEnabled, AuditLogAgeLimit

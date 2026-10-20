# Connect to SharePoint Online
Connect-SPOService -Url https://DOMAIN-admin.sharepoint.com

# Import the CSV file
$sites = Import-Csv -Path "D:\SharePointSitesForDeletion.csv"

# Loop through each user in the CSV
foreach ($site in $sites) {
    # Use the SharePoint URL from the CSV file
    $SharePointUrl = $site.SharePointURL

    # Delete SharePoint Site and avoid deletion prompt
    Remove-SPOSite -Identity $SharePointUrl -Confirm:$false
}
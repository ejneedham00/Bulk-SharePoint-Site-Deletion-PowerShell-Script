<h1>Bulk Delete SharePoint Sites From a CSV List</h1>

<h2>What it does</h2>

<p>This script is for deleting a batch of SharePoint sites in one go. You give it a CSV of site URLs, and it goes through each one and sends it to the SharePoint recycle bin without asking for confirmation. Unlike many of my other scripts, this script is <b>NOT READ ONLY</b> and will actually make changes using a <code>REMOVE</code> command. Please use this script with caution.</p>

<h2>How it works</h2>

<ol>
  <li>Connects to SharePoint Online with <code>Connect-SPOService</code>, using the admin centre URL. <code>DOMAIN</code> needs replacing with your tenant name, and you'll get an interactive sign-in.</li>
  <li>Reads <code>D:\SharePointSitesForDeletion.csv</code> into <code>$sites</code> with <code>Import-Csv</code>. The CSV needs a column headed <code>SharePointURL</code>.</li>
  <li>Loops through each row and stores that row's site URL in <code>$SharePointUrl</code>.</li>
  <li>Runs <code>Remove-SPOSite</code> against that site with <code>-Confirm:$false</code>. This skips the "are you sure?" prompt, so every site in the list is deleted straight away with no chance to back out.</li>
  <li>Moves on to the next row. Nothing is printed, so there is no summary or confirmation.</li>
</ol>

<h2>Prerequisites</h2>

<ul>
  <li>The SharePoint Online Management Shell module (<code>Microsoft.Online.SharePoint.PowerShell</code>)</li>
  <li>An account with the SharePoint Administrator or Global Administrator role</li>
  <li>A CSV at the path shown, with a <code>SharePointURL</code> column containing full site URLs</li>
</ul>

<h2>Notes / Limitations</h2>

<ul>
  <li><b>Placeholder needs replacing.</b> <code>DOMAIN</code> in the admin URL must be changed to your tenant name before it will connect.</li>
  <li><b>Deleted sites go to the recycle bin, not gone for good.</b> <code>Remove-SPOSite</code> moves each site to the tenant's deleted sites list, where it stays for 93 days by default. Until then you can restore it with <code>Restore-SPODeletedSite</code>. It is only permanently removed if someone later runs <code>Remove-SPODeletedSite</code>, or the retention period runs out.</li>
  <li><b>There is no safety net in the script.</b> <code>-Confirm:$false</code> removes the prompt, and there is no <code>-WhatIf</code> step, so a wrong URL in the CSV means a wrong site gets deleted. Test it with <code>-WhatIf</code> first, and double-check every row.</li>
  <li><b>Check what else a site is attached to.</b> Deleting the site behind a Microsoft 365 group or a Team removes the connection to it, and can affect the group's files, calendar and Teams channels. Hub sites and sites with active sharing links can also cause problems.</li>
  <li><b>Retention and legal holds can block deletion.</b> A site under a retention policy or hold may fail to delete, or may be kept in the background.</li>
  <li>The URL must be exact. A typo, trailing space or a non-existent site produces an error. A URL that points at the wrong real site deletes that site instead.</li>
  <li>There is no error handling or logging. You'll only see red errors in the console, with no record of which rows succeeded, so keep a copy of the CSV and note the time it was run.</li>
  <li>A CSV with a different column name, such as <code>SharePointUrl</code> or <code>URL</code>, makes <code>$site.SharePointURL</code> come back empty. PowerShell's property matching ignores case, but not the name itself.</li>
  <li>The comment above the loop says "each user", but the loop works through sites, so it's a leftover from another script.</li>
</ul>

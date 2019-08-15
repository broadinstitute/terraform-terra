## SAM service account deployment manual steps
The steps below currently cannot be easily automated and must be performed manually after running this profile

### Create the subdomain of `test.firecloud.org`
1. In the GSuite admin console for `test.firecloud.org`, go to Domains -> Manage Domains -> Add a domain
2. Click on "Add another domain" (NOT domain alias)
3. For the name, enter `<google-project-name>.ephemeral.test.firecloud.org` and click continue
4. On the ownership verification page that follows, select Google Domains as the provider, and copy the verification text.
5. In the Google cloud console, go to Network services -> Cloud DNS -> `<google-project-name>.ephemeral.test.firecloud.org` -> Add record set
6. Change type to TXT, paste the verification text into the TXT data field, and save the record
7. Wait ~5 mins
8. Back in the GSuite admin console, click "verify"
9. You should get a screen congradulating you on verifying your ownership of the domain. If not, wait 5 more minutes and try clicking verify again.

### Create alias for the google admin user
1. In the GSuite admin console for `test.firecloud.org`, go to Users -> `google@test.firecloud.org` AKA "Google Administrator"
2. Click on the user, then User information
3. Edit the list of Email aliases and add an alias to `google@<google-project-name>.ephemeral.test.firecloud.org`

### Add scopes to SAs
1. In the GSuite admin console for `test.firecloud.org`, go to Security -> Advanced Settings -> Manage API client access
2. For each numeric directory SA ID that was output when this profile was run, add these scopes:
`https://www.googleapis.com/auth/admin.directory.group,https://www.googleapis.com/auth/admin.directory.user,https://www.googleapis.com/auth/apps.groups.settings`

### Enable domain-wide delegation
1. In the Google cloud console, For each of the directory SAs (IAM > Service accounts > search for `dir`) and for the SAM SA (should just be `<google-project-name>-sam@something`) enable domain-wide delegation
2. When prompted for a name for the oauth consent screen, enter the project name

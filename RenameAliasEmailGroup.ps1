Import-Module ActiveDirectory

$Groups = Import-csv C:\Users\Administrator\Desktop\testgroup.csv

foreach ($Group in $Groups){
	$TempOldName = $Group.OldName
	$TempNewName = $Group.NewName
	$TempDescription = $Group.Description
	$TempSamAccountName = $Group.sAMAccountName
	$TempEmail = $Group.Email
	$TempDisplayName = $Group.DisplayName
	
	try {
		"In try: working on $TempOldName"
		$Identity = Get-ADGroup "CN=$TempOldName,OU=Job Code Group Test,DC=Fabricam,DC=com"
		Set-ADGroup -Identity $Identity -sAMAccountName $TempSamAccountName
		Set-ADGroup -Identity $Identity -displayName $TempDisplayName
		Set-ADGroup -Identity $Identity -description $TempDescription
		Set-ADGroup -Identity $Identity -replace @{mail=$TempEmail}
		Rename-ADObject -Identity $Identity -NewName $TempNewName
		Write-Output ($TempOldName + " has been renamed to " + $TempNewName)
	} 

      catch {
		"In catch: error in execution on $TempOldName"
		Write-Output "Error: $_"
	}
}
 
<#Explanation:
So we get the new details from the csv through:
$Groups = Import-csv C:\Users\Administrator\Desktop\testgroup.csv
 
We then loop through these values per row, and store each column's value in temporary variables in each iteration.
	$TempOldName = $Group.OldName
	$TempNewName = $Group.NewName
	$TempDescription = $Group.Description
	$TempSamAccountName = $Group.sAMAccountName
	$TempEmail = $Group.Email
	$TempDisplayName = $Group.DisplayName
 
We use try and catch, so that we can monitor easily if the script ran fine or it returned an exception.
 
We then create the $Identity variable to store the identity from the active directory, of the group we are currently working on.
$Identity = Get-ADGroup "CN=$TempOldName,OU=Job Code Group Test,DC=Fabricam,DC=com"
 
Notes:
-sAMAccountName, -displayName and -description are special keywords in the Set-ADGroup command
this provides an easy mechanism to update the alias, display name, and the description
There is no -mail special keyword in Set-ADGroup
so we use what is the attribute name we can find in the Properties > Attribute Editor of the AD group
attribute name for email is mail, so we update it using the -rename command of Set-ADGroup

Lastly, we rename the object by using the Rename-ADObject command
we rename it at the end because if we have renamed it earlier, we should get an error that the AD Group is not found
if the AD Group is not found, the subsequent updates cannot be performed.
#>

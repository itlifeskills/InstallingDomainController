#Initial OU where the script starts searching for users
$userBase = "OU=Users,OU=ITLifeSkills,DC=hq,DC=itlifeskills,DC=local"

#Import the department groups from the CSV file
$deparmentGroups = Import-Csv -Path "D:\Scripts\Data\DepartmentGroups.csv"

#Foreach group found in the CSV file
foreach($group in $deparmentGroups){
    #Constructure the deparment name, group name and folder location
    $deptName = $group.Department
    $grpName = $group.GroupName
    $folderLocation = $group.FileServer + " | " + $group.Location

    #Get the current Description of the group
    $description = (Get-ADGroup -Identity $grpName -Properties Description).Description

    #If the Description is not the same as the folder location, then update
    if($description -ne $folderLocation){
        Set-ADGroup -Identity $grpName -Description $folderLocation
    }    

    #Get all members of the current group
    $members = Get-ADGroupMember -Identity $grpName 

    #Loop through each member
    foreach($member in $members){
        #Find the department of the user
        $detailmember = Get-ADUser -Identity $member.SamAccountName -Properties Department, Enabled
        #If the department is not matched then remove the member from the group
        if(($detailmember.Department -ne $deptName) -or ($detailmember.Enabled -eq $false)){            
            Remove-ADGroupMember -Identity $grpName -Members $member.SamAccountName -Confirm:$false        
        }    
    }
    
    #Find all the users of the current department who are not the member of the department group
    $deptUsers = Get-ADUser -Filter * -SearchBase $userBase -Properties Department, Enabled |
                 where {($_.Department -eq $deptName) -and ($_.SamAccountName -notin $members.SamAccountName)`
                 -and ($_.Enabled -eq $true) }
    
    #If found, Add all of these users to the department group
    if($deptUsers){
        foreach($user in $deptUsers){
            Add-ADGroupMember -Identity $grpName -Members $user.SamAccountName   
        }
    }
}
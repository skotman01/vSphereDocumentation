# vSphereDocumentation
Powershell script used to create documentation of vSphere environments.

# Summary
The script prompts the operator for their information (this info will show up in the footer of the resulting document), then will prompt to connect to at least 1 vcenter server. Once a connection to a vcenter is made, a list of clusters is presented. Select the clusters you wish to document.

# Requirements
VSphere Power CLI must be installed, either via the downloadable binary or from the Powershell gallery. This script was tested and run with an installable from the PS gallery.
Word 2013 or higher

# Instructions
1. Run script from PowerShell or Power CLI console
2. When prompted enter in all pertenant information such as your name, email, phone number and customer name, click Continue
3. Enter in vcenter addresses, if entering multiple servers, seperate with a ; (vcenter1;vcenter2;vcenter3)
4. Select the Clusters you wish to document, Click Document
5. Select a folder to save the Word and PDF documents in
6. Choose if you want one file per vcenter, or one file per cluster, default is one file per vcenter.
7. Watch as your documentation is created for you, documents will be saved as vCenterName.docx and vCenterName.pdf if you selected one file per vcenter, and will be named vCenterName-ClusterName.docx and vCenterName-CluserName.pdf if you selected one per cluster. 
8. Once the document has been created and saved in .docx and .pdf formats, you will be prompted to disconnect from all vcenters or not. If you need to run the script again, chose No.
9. Review the resulting documentation.

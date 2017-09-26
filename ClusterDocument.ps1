<#
.SYNOPSIS
   Script goes through the selected clusters and creates Word and PDF document of detailed information of the environment

.DESCRIPTION
   Script asks the operator to connect to a vcenter, then prompts to select one or more clusters. Once a cluster is selected the script goes through and pulls the required information to populate a word and PDF document.
.PARAMETER <paramName>
   None
.EXAMPLE
	Script can be run from ISE with PowerCLI loaded or PowerCLI console, Word must be installed
.AUTHORS  Scott Heath
#>


#Logging Function
#Example: Write-Log "Text data" "Yellow"
#Example: write-log -message "Text Data" -FGC "Yellow" -backgroundcolor "White"
<#
Possibile Color combinations
Black
DarkBlue
DarkGreen
DarkCyan
DarkRed
DarkMagenta
DarkYellow
Gray
DarkGray
Blue
Green
Cyan
Red
Magenta
Yellow
White	
#>
Function Write-Log{
[cmdletbinding()]
	param(
		[Parameter(Mandatory=$True,Position=0,ValueFromPipeline=$True)]
		[alias("message")]
		[string[]]$LogData,
		[Parameter(Mandatory=$False,Position=1)]
		[alias("foregroundcolor","FGC")]
		[string]$FGColor="White",
		[Parameter(Mandatory=$False,Position=2)]
		[alias("backgroundcolor","BGC")]
		[string]$BGColor="Black"
		)
	$LogData = ((Get-Date -Format o) + " " + $LogData)
#	add-content $Powerclilogfile $LogData
	write-host $LogData -foregroundcolor $FGColor -backgroundcolor $BGColor
}
Function Select-Folder {
    param(
        [Parameter(Mandatory=$True,Position=0)]
		[string[]]$Description        
    )
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    $SelectFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $SelectFolderDialog.Description = $Description
    $SelectFolderDialog.ShowDialog() | Out-Null
    $SelectFolderDialog.SelectedPath
}

function Connect-VCenters {

    #region Import the Assemblies
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
    #endregion

    #region Generated Form Objects
    $form1 = New-Object System.Windows.Forms.Form
    $checkBox1 = New-Object System.Windows.Forms.CheckBox
    $button1 = New-Object System.Windows.Forms.Button
    $label2 = New-Object System.Windows.Forms.Label
    $txtVcenters = New-Object System.Windows.Forms.TextBox
    $label1 = New-Object System.Windows.Forms.Label
    $panel1 = New-Object System.Windows.Forms.FlowLayoutPanel
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

    #endregion Generated Form Objects

    #----------------------------------------------
    #Generated Event Script Blocks
    #----------------------------------------------
    #Provide Custom Code for events specified in PrimalForms.
    $button1_OnClick= 
    {
    #TODO: Place custom script here


    $vCenterConnectList = $txtVcenters.Text.Split(";")
        ForEach ($vCenterConnect in $vCenterConnectList){
            If (!($checkBox1.Checked)){
                Try{
                    Connect-VIServer -Server $vCenterConnect -Credential $creds -ErrorAction Stop
                }
                catch{
                    $creds = Get-Credential -Message "Please enter credentials to connect to $vCenterConnect"
                    Connect-VIServer -Server $vCenterConnect -Credential $creds -ErrorAction Stop
                }
            
            }
            Else{
                Try{
                    $creds = Get-Credential -Message "Please enter credentials to connect to $($txtVcenters.Text)"
                    Connect-VIServer -Server $vCenterConnect -Credential $creds -ErrorAction Stop
                }
                Catch{
                    [System.Windows.Forms.MessageBox]::Show("Bad Credentials, Please try again", "Error!",[System.Windows.Forms.MessageBoxButtons]::Ok,[System.Windows.Forms.MessageBoxIcon]::Error)
                
                }
                    
            }
        }
    If ($global:DefaultVIServers){
        $NovcenterLabel = $null
        $vcenterLabel = $null
        forEach ($vCenter in $global:DefaultVIServers){
            $vcenterLabel = New-Object System.Windows.Forms.Label
            $vcenterLabel.Text = $vCenter
            $vcenterLabel.AutoSize = $true
            $vcenterLabel.Font = "Microsoft Sans Serif,8"
            $panel1.controls.Add($vcenterLabel)
        }
    }


    }


    $OnLoadForm_StateCorrection=
    {#Correct the initial state of the form to prevent the .Net maximized form issue
	    $form1.WindowState = $InitialFormWindowState
    }

    #----------------------------------------------
    #region Generated Form Code
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 400
    $System_Drawing_Size.Width = 678
    $form1.ClientSize = $System_Drawing_Size
    $form1.DataBindings.DefaultDataSourceUpdateMode = 0
    $form1.Name = "form1"
    $form1.Text = "Primal Form"


    $checkBox1.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 21
    $System_Drawing_Point.Y = 269
    $checkBox1.Location = $System_Drawing_Point
    $checkBox1.Name = "checkBox1"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 30
    $System_Drawing_Size.Width = 350
    $checkBox1.Size = $System_Drawing_Size
    $checkBox1.TabIndex = 5
    $checkBox1.Text = "Use same credentials for all vcenters above"
    $checkBox1.UseVisualStyleBackColor = $True

    $form1.Controls.Add($checkBox1)


    $button1.DataBindings.DefaultDataSourceUpdateMode = 0

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 21
    $System_Drawing_Point.Y = 310
    $button1.Location = $System_Drawing_Point
    $button1.Name = "button1"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 100
    $button1.Size = $System_Drawing_Size
    $button1.TabIndex = 4
    $button1.Text = "Connect"
    $button1.UseVisualStyleBackColor = $True
    $button1.add_Click($button1_OnClick)

    $form1.Controls.Add($button1)

    $label2.DataBindings.DefaultDataSourceUpdateMode = 0
    $label2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10,1,3,0)

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 418
    $System_Drawing_Point.Y = 13
    $label2.Location = $System_Drawing_Point
    $label2.Name = "label2"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 23
    $System_Drawing_Size.Width = 248
    $label2.Size = $System_Drawing_Size
    $label2.TabIndex = 3
    $label2.Text = "Existing vCenter Connections"

    $form1.Controls.Add($label2)

    $txtVcenters.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 21
    $System_Drawing_Point.Y = 82
    $txtVcenters.Location = $System_Drawing_Point
    $txtVcenters.Multiline = $True
    $txtVcenters.Name = "txtVcenters"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 171
    $System_Drawing_Size.Width = 372
    $txtVcenters.Size = $System_Drawing_Size
    $txtVcenters.TabIndex = 2

    $form1.Controls.Add($txtVcenters)

    $label1.DataBindings.DefaultDataSourceUpdateMode = 0
    $label1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",10,1,3,0)

    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 21
    $System_Drawing_Point.Y = 12
    $label1.Location = $System_Drawing_Point
    $label1.Name = "label1"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 57
    $System_Drawing_Size.Width = 372
    $label1.Size = $System_Drawing_Size
    $label1.TabIndex = 1
    $label1.Text = "Please enter vCenter(s) to connect to, seperate multiple vCenters with semicolon"
    $label1.add_Click($handler_label1_Click)

    $form1.Controls.Add($label1)

    $panel1.AutoScroll = $True
    $panel1.FlowDirection = "TopDown"

    $panel1.BorderStyle = 2
    $panel1.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 418
    $System_Drawing_Point.Y = 48
    $panel1.Location = $System_Drawing_Point
    $panel1.Name = "panel1"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 261
    $System_Drawing_Size.Width = 257
    $panel1.Size = $System_Drawing_Size
    $panel1.TabIndex = 0

    $form1.Controls.Add($panel1)
    If ($global:DefaultVIServers){
        forEach ($vCenter in $global:DefaultVIServers){
            $vcenterLabel = New-Object System.Windows.Forms.Label
            $vcenterLabel.Text = $vCenter
            $vcenterLabel.AutoSize = $true
            $vcenterLabel.Font = "Microsoft Sans Serif,8"
            $panel1.controls.Add($vcenterLabel)
        }
    }
    Else{
        $NovcenterLabel = New-Object System.Windows.Forms.Label
        $NovcenterLabel.Text = "No vCenters Currently Connected"
        $NovcenterLabel.AutoSize = $true
        $NovcenterLabel.Font = "Microsoft Sans Serif,8"
        $panel1.controls.Add($NovcenterLabel)
    }

    #endregion Generated Form Code

    #Save the initial state of the form
    $InitialFormWindowState = $form1.WindowState
    #Init the OnLoad event to correct the initial state of the form
    $form1.add_Load($OnLoadForm_StateCorrection)
    #Show the Form
    $form1.ShowDialog()| Out-Null


} #End Function

Function Get-Clusters{

    #region Import the Assemblies
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
    #endregion

    #region Generated Form Objects
    $form1 = New-Object System.Windows.Forms.Form
    $PanelClusters = New-Object System.Windows.Forms.FlowLayoutPanel
    $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
    $btnDocument = New-Object System.Windows.Forms.Button
    #endregion Generated Form Objects

    #region Generated Form Code
    $btnDocument_OnClick= 
    {
    #TODO: Place custom script here
        [System.Collections.ArrayList]$ClusterList = @()
        ForEach ($ClusterCheckBox in $ClusterCheckBoxes){
            If ($ClusterCheckBox.Checked){
                $ClusterList.Add($ClusterCheckBox.Name)    
            }
        }
    $form1.Close()
    }


    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 371
    $System_Drawing_Size.Width = 580
    $form1.ClientSize = $System_Drawing_Size
    $form1.DataBindings.DefaultDataSourceUpdateMode = 0
    $form1.Name = "form1"
    $form1.Text = "Primal Form"


    $PanelClusters.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point = New-Object System.Drawing.Point
    $System_Drawing_Point.X = 13
    $System_Drawing_Point.Y = 13
    $PanelClusters.Location = $System_Drawing_Point
    $PanelClusters.Name = "PanelClusters"
    $System_Drawing_Size = New-Object System.Drawing.Size
    $System_Drawing_Size.Height = 346
    $System_Drawing_Size.Width = 555
    $PanelClusters.Size = $System_Drawing_Size
    $PanelClusters.TabIndex = 0
    $PanelClusters.FlowDirection = "TopDown"


    ForEach($vcenter in $global:DefaultVIServers){
            $vCenterLabel = New-Object System.Windows.Forms.Label
            $vCenterLabel.Text = $vcenter
            $vCenterLabel.AutoSize = $true
            $vCenterLabel.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",8.25,1,3,0)
            $PanelClusters.controls.Add($vCenterLabel)

           $ClusterCheckBoxes = ForEach($cluster in (get-cluster -Server $vcenter)){
                $checkBox1 = New-Object System.Windows.Forms.CheckBox
                $checkBox1.Text = $cluster.Name
                $checkBox1.Name = "$vcenter~$cluster"
                $PanelClusters.controls.Add($checkBox1)
                $checkBox1
            }

    }


    $btnDocument.DataBindings.DefaultDataSourceUpdateMode = 0
    $System_Drawing_Point.X = 12
    $System_Drawing_Point.Y = 304
    $btnDocument.Location = $System_Drawing_Point
    $btnDocument.Name = "btnDocument"
    $btnDocument.Name = "btnDocument"
    $System_Drawing_Size.Height = 25
    $System_Drawing_Size.Width = 80
    $btnDocument.Size = $System_Drawing_Size
    $btnDocument.TabIndex = 0
    $btnDocument.Text = "Document"
    $btnDocument.UseVisualStyleBackColor = $True
    $btnDocument.add_Click($btnDocument_OnClick)
    $form1.Controls.Add($btnDocument)
    $form1.Controls.Add($PanelClusters)

    #endregion Generated Form Code

    #Save the initial state of the form
    $InitialFormWindowState = $form1.WindowState
    #Init the OnLoad event to correct the initial state of the form
    $form1.add_Load($OnLoadForm_StateCorrection)
    #Show the Form
    $form1.ShowDialog()| Out-Null
    Return $ClusterList
} #End Function


#Declare Forms
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

#Variable declaration 
$PowercliLogPath = $PSScriptRoot + "\VirtualPlatformLogs\"
$PowercliLogName = $MyInvocation.MyCommand.Name.TrimEnd("ps1") + "log"
$TimeStamp = (Get-Date -Format o |ForEach-Object {$_ -replace ":", "."}) + "-"
$Powerclilogfile = $PowerclilogPath + $TimeStamp + $PowercliLogName
##############do script pre-req checks##################

#Check for log directory, if it doesn't exist, create it, if unable to create, exit	  
if (!(Test-Path -Path $PowercliLogPath)) {
	Try{
		New-Item -ItemType Directory -Path $PowercliLogPath
	}
	Catch{
		Write-Warning "Unable to create directory for logs at $PowercliLogPath" -FGC "Red"
		Write-Warning "Please fix the log path and try again" -FGC "Red"
	    Write-Log "Terminating Script" -BGC "Red"
		Exit 99
	}
}

#Check for write access to log file, if unable, exit
Try{
	[io.file]::OpenWrite($Powerclilogfile).close()
}
Catch{
	Write-Warning "Unable to write logs to output directory $PowerclilogPath" -FGC "Red"
	Write-Warning "Please fix Log Path and try again" -FGC "Red"
	Write-Log "Terminating Script" -BGC "Red"
	exit 99
}

write-Log "Script log information can be found at $Powerclilogfile" -FGC "Yellow"

#check for elevated permissions (Administrator rights), if they don't exist, exit.
<#If (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Log "WARNING: You do not have Administrator rights to run this script!" -FGC "Red"
	Write-Log "Please re-run this script as an Administrator, Script will now exit" -FGC "Red"
	Exit 99
}


if ($psISE.CurrentFile -like "*ISE*"){
    Write-Log "This Script can't be run from the ISE... " -FGC Red
    Write-Log "Terminating Script" -FGC Red
#    Exit 99
}
else {
    Write-Log "This Script is running from a standard PS Session.... Continuing" 
}
#>

If (!(Get-Module -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue)) {
	Write-Log "Initialize PowerCLI Environment" -FGC "magenta" 
	.'C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1'
}
else { 
	Write-Log "PowerCLI Environment already Initialized" -FGC "magenta" 
}

Write-Log "Set Session Timeout to -1" -FGC "magenta" 
Set-PowerCLIConfiguration -WebOperationTimeoutSeconds -1 -Scope Session -Confirm:$False
Write-Log "Success"

If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Log "Set Session DefaultVIServerMode to Multiple" -FGC "magenta" 
    Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope AllUsers -Confirm:$false | Out-Null
    Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope User -Confirm:$false | Out-Null
    Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Scope Session -Confirm:$false | Out-Null
}
Else{
    Write-Log "Not running script with elevated permissions, leaving PowerCLI Config as-is"
}

$StartTime = Get-Date
Write-Log "Script start time $StartTime"



Connect-VCenters

$clusters = get-clusters



    $Word = New-Object -ComObject Word.Application
    $word.Visible = $True
    $pdf = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatPDF")
    $doc = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocument")
    $DoNotSave = [Microsoft.Office.Interop.Word.WdSaveOptions]::wdDoNotSaveChanges




$DestFolder = (Select-Folder -Description "Select folder where you'd like the documenation to be saved")
Switch([System.Windows.Forms.MessageBox]::Show("Would you like 1 file per vCenter? (if no, output is 1 file per cluster)", "Configure Output",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question,[System.Windows.Forms.MessageBoxDefaultButton]::Button2)){
    "Yes"{
        $OneFile = $True
        $FirstCluster = $True
    }
    "No"{
        $OneFile = $False
    }
}

foreach ($cluster in $clusters){
    $vc_vCenter = ($Cluster.Split("~"))[0]
    $cluster = get-cluster -Server $vc_vCenter -Name ($Cluster.Split("~"))[1]
    If ($OneFile){
        $Output = $DestFolder + "\" + $vc_vCenter.SubString(0,$vc_vCenter.IndexOf("."))
        if ($FirstCluster){
            $Document = $Word.Documents.Add()
            $Selection = $Word.Selection

            #Begin adding content to Word Doc
            $Selection.Style = "Title"
            $Selection.TypeText("Documentation for vSphere Cluster $Cluster")
            $selection.ParagraphFormat.Alignment = "wdAlignParagraphCenter"
            $Selection.TypeParagraph()        
            $FirstCluster = $False
        }
    }
    Else{
        $Output = $DestFolder + "\" + $vc_vCenter.SubString(0,$vc_vCenter.IndexOf(".")) + "-" + $cluster
        $Document = $Word.Documents.Add()
        $Selection = $Word.Selection

        #Begin adding content to Word Doc
        $Selection.Style = "Title"
        $Selection.TypeText("Documentation for vSphere Cluster $Cluster")
        $selection.ParagraphFormat.Alignment = "wdAlignParagraphCenter"
        $Selection.TypeParagraph()
    }
    
    
    $Selection.Style = "Heading 1"
    $Selection.TypeText("Information for $Cluster")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

    $Selection.TypeText("$Cluster resides in Datacenter $($($cluster | get-datacenter).Name) and contains $($($cluster | get-vmhost).count) VMHosts and $($($cluster | get-vm).count) VMs")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

#Get VMHost info

    $Selection.Style = "Heading 2"
    $Selection.TypeText("Host Summary")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()
    
    $vmhosts = get-vmhost -Location $cluster | sort

    $Range = @($Selection.Paragraphs)[-1].Range
    $Table = $Selection.Tables.add($Selection.Range,($vmhosts.Count+1),3,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
    $Table.Style = "Medium Shading 1 - Accent 1"
    $Table.cell(1,1).range.Bold=1
    $Table.cell(1,1).range.text = "ESX Host Name"
    $Table.cell(1,2).range.Bold=1
    $Table.cell(1,2).range.text = "Management Interface"
    $Table.cell(1,3).range.Bold=1
    $Table.cell(1,3).range.text = "ESX Host State"

    $row = 0
    foreach ($vmhost in $vmhosts){
        $Table.cell(($row+2),1).range.Bold = 0
        $Table.cell(($row+2),1).range.text = $vmhost.Name
        $Table.cell(($row+2),2).range.Bold = 0
        $Table.cell(($row+2),2).range.text = $(Get-VMHostNetworkAdapter -VMHost $vmhost -Name vmk0).IP
        $Table.cell(($row+2),3).range.Bold = 0
        $Table.cell(($row+2),3).range.text = $vmhost.ConnectionState
        $row++
    }
    $Word.Selection.Start= $Document.Content.End
    $Selection.TypeParagraph()

#Detailed host information
    $Selection.Style = "Heading 2"
    $Selection.TypeText("Host Details")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

foreach ($vmhost in $vmhosts){
    #Detailed host information
    $vmhostInfo = Get-VMHostHardware -VMHost $vmhost
    $Selection.Style = "Heading 3"
    $Selection.TypeText($vmhost.name)
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

    $Selection.Style = "Heading 4"
    $Selection.TypeText("Hardware")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()
        
    $Range = @($Selection.Paragraphs)[-1].Range
    $Table = $Selection.Tables.add($Selection.Range,10,2,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
    $Table.Style = "Medium Shading 1 - Accent 1"
    $Table.cell(1,1).range.Bold=1
    $Table.cell(1,1).range.text = "Property"
    $Table.cell(1,2).range.Bold=1
    $Table.cell(1,2).range.text = "Value"
    
    $Table.cell(2,1).range.Bold=0
    $Table.cell(2,1).range.text = "Make/Model"
    $Table.cell(2,2).range.Bold=0
    $Table.cell(2,2).range.text= "$($vmhost.Manufacturer) $($vmhost.Model)"
    
    $Table.cell(3,1).range.Bold=0
    $Table.cell(3,1).range.text = "Serial Number"
    $Table.cell(3,2).range.Bold=0
    $Table.cell(3,2).range.text= $vmhostInfo.SerialNumber

    $Table.cell(4,1).range.Bold=0
    $Table.cell(4,1).range.text = "Memory Total (GB)"
    $Table.cell(4,2).range.Bold=0
    $Table.cell(4,2).range.text= $vmhost.MemoryTotalGB

    $Table.cell(5,1).range.Bold=0
    $Table.cell(5,1).range.text = "Processor Type"
    $Table.cell(5,2).range.Bold=0
    $Table.cell(5,2).range.text= $vmhost.ProcessorType

    $Table.cell(6,1).range.Bold=0
    $Table.cell(6,1).range.text = "Hyper threading Active"
    $Table.cell(6,2).range.Bold=0
    $Table.cell(6,2).range.text= $vmhost.HyperthreadingActive

    $Table.cell(7,1).range.Bold=0
    $Table.cell(7,1).range.text = "CPU Total (ghz)"
    $Table.cell(7,2).range.Bold=0
    $Table.cell(7,2).range.text= "$($vmhost.CPUTotalMhz/1000)"

    $Table.cell(8,1).range.Bold=0
    $Table.cell(8,1).range.text = "CPU Count"
    $Table.cell(8,2).range.Bold=0
    $Table.cell(8,2).range.text= $vmhostInfo.CpuCount

    $Table.cell(9,1).range.Bold=0
    $Table.cell(9,1).range.text = "Core Count Total"
    $Table.cell(9,2).range.Bold=0
    $Table.cell(9,2).range.text= $vmhostInfo.CPUCoreCountTotal

    $Table.cell(10,1).range.Bold=0
    $Table.cell(10,1).range.text = "ESXi License Key"
    $Table.cell(10,2).range.Bold=0
    $Table.cell(10,2).range.text= $vmhost.LicenseKey

    $Word.Selection.Start= $Document.Content.End
    $Selection.TypeParagraph()

    #Detailed Network Info
    $Selection.Style = "Heading 4"
    $Selection.TypeText("Network")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()
    
    $NetworkInfo = Get-VMHostNetwork $vmhost   
    $adapterInfo = Get-VMHostNetworkAdapter -VMHost $vmhost -VMKernel
    $Range = @($Selection.Paragraphs)[-1].Range
    $Table = $Selection.Tables.add($Selection.Range,(($adapterInfo.count*3) + 4),2,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
    $Table.Style = "Medium Shading 1 - Accent 1"
    $Table.cell(1,1).range.Bold=1
    $Table.cell(1,1).range.text = "Property"
    $Table.cell(1,2).range.Bold=1
    $Table.cell(1,2).range.text = "Value"

    $Table.cell(2,1).range.Bold=0
    $Table.cell(2,1).range.text = "Default Gateway"
    $Table.cell(2,2).range.Bold=0
    $Table.cell(2,2).range.text= $NetworkInfo.VMKernelGateway

    $Table.cell(3,1).range.Bold=0
    $Table.cell(3,1).range.text = "DNS Server(s)"
    $Table.cell(3,2).range.Bold=0
    $Table.cell(3,2).range.text= $NetworkInfo.DnsAddress

    $Table.cell(4,1).range.Bold=0
    $Table.cell(4,1).range.text = "IPv6 Enabled"
    $Table.cell(4,2).range.Bold=0
    $Table.cell(4,2).range.text= $NetworkInfo.IPv6Enabled

    
    $adapterCount = 5
    foreach ($adapter in $adapterInfo){
        $Table.cell($adapterCount,1).range.Bold=0
        $Table.cell($adapterCount,1).range.text = "vmKernal Port"
        $Table.cell($adapterCount,2).range.Bold=0
        $Table.cell($adapterCount,2).range.text= $adapter.DeviceName
        $adapterCount++ 
        $Table.cell($adapterCount,1).range.Bold=0
        $Table.cell($adapterCount,1).range.text = "Port Group Name"
        $Table.cell($adapterCount,2).range.Bold=0
        $Table.cell($adapterCount,2).range.text= $adapter.PortGroupName
        $adapterCount++ 
        $Table.cell($adapterCount,1).range.Bold=0
        $Table.cell($adapterCount,1).range.text = "IP and Mask"
        $Table.cell($adapterCount,2).range.Bold=0
        $Table.cell($adapterCount,2).range.text= "IP: $($adapter.IP) Mask: $($adapter.SubnetMask)"
        $adapterCount++ 
    }
    $Word.Selection.Start= $Document.Content.End
    $Selection.TypeParagraph()

    $Selection.Style = "Heading 4"
    $Selection.TypeText("Virtual Switches")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

    $vDSwitch = Get-vdswitch -vmhost $vmhost
    $Selection.Style = "Heading 5"
    $Selection.TypeText("Distributed Virtual Switches")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()
    if ($vDSwitch){
        $Range = @($Selection.Paragraphs)[-1].Range
        $Table = $Selection.Tables.add($Selection.Range,($vDSwitch.count)+1,1,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
        $Table.Style = "Medium Shading 1 - Accent 1"
        $Table.cell(1,1).range.Bold=1
        $Table.cell(1,1).range.text = "Distributed vSwitch Name"
        $row = 2
        foreach ($switch in $vDSwitch){
            $Table.cell($row,1).range.Bold=0
            $Table.cell($row,1).range.text = $switch.Name
            $row++
        }
    $Word.Selection.Start= $Document.Content.End
    $Selection.TypeParagraph()
    }
    Else{
        $Selection.TypeText("No Distributed Virtual Switches found on $($vmhost.Name)")
#        $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
        $Selection.TypeParagraph()
    }

    $Selection.Style = "Heading 5"
    $Selection.TypeText("Standard Virtual Switches")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()
#List Standard switches
    $vSSwitch = Get-VirtualSwitch -vmhost $vmhost -Standard
    if ($vSSwitch){
        $Range = @($Selection.Paragraphs)[-1].Range
        $Table = $Selection.Tables.add($Selection.Range,($vSSwitch.count)+1,1,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
        $Table.Style = "Medium Shading 1 - Accent 1"
        $Table.cell(1,1).range.Bold=1
        $Table.cell(1,1).range.text = "Standard vSwitch Name"
        $row = 2
        foreach ($switch in $vSSwitch){
            $Table.cell($row,1).range.Bold=0
            $Table.cell($row,1).range.text = $switch.Name
            $row++
        }
    $Word.Selection.Start= $Document.Content.End
    $Selection.TypeParagraph()
    }
    Else{
        $Selection.TypeText("No Standard Virtual Switches found on $($vmhost.Name)")
#        $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
        $Selection.TypeParagraph()
    }
}


#list cluster datastores
    $Selection.Style = "Heading 2"
    $Selection.TypeText("Datastores")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

    $datastores = $cluster | Get-Datastore

    $Range = @($Selection.Paragraphs)[-1].Range
    $Table = $Selection.Tables.add($Selection.Range,($datastores.Count+1),6,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
    $Table.Style = "Medium Shading 1 - Accent 1"
    $Table.cell(1,1).range.Bold=1
    $Table.cell(1,1).range.text = "Datastore Name"
    $Table.cell(1,2).range.Bold=1
    $Table.cell(1,2).range.text = "Type"
    $Table.cell(1,3).range.Bold=1
    $Table.cell(1,3).range.text = "File System Version"
    $Table.cell(1,4).range.Bold=1
    $Table.cell(1,4).range.text = "Capacity (GB)"
    $Table.cell(1,5).range.Bold=1
    $Table.cell(1,5).range.text = "Free Space (GB)"
    $Table.cell(1,6).range.Bold=1
    $Table.cell(1,6).range.text = "Free Space (%)"

    
    $row = 0
    foreach($datastore in $datastores){
        $Table.cell(($row+2),1).range.Bold=0
        $Table.cell(($row+2),1).range.Font.Size = 8
        $Table.cell(($row+2),1).range.text = $datastore.Name
        $Table.cell(($row+2),2).range.Bold=0
        $Table.cell(($row+2),2).range.Font.Size = 8
        $Table.cell(($row+2),2).range.text = $datastore.Type
        $Table.cell(($row+2),3).range.Bold=0
        $Table.cell(($row+2),3).range.Font.Size = 8
        $Table.cell(($row+2),3).range.text = $datastore.FileSystemVersion
        $Table.cell(($row+2),4).range.Bold=0
        $Table.cell(($row+2),4).range.Font.Size = 8
        $Table.cell(($row+2),4).range.text = $datastore.CapacityGB
        $Table.cell(($row+2),5).range.Bold=0
        $Table.cell(($row+2),5).range.Font.Size = 8
        $Table.cell(($row+2),5).range.text = $datastore.FreeSpaceGB
        $Table.cell(($row+2),6).range.Bold=0
        $Table.cell(($row+2),6).range.Font.Size = 8
        $Table.cell(($row+2),6).range.text = "{0:P2}" -f ($datastore.FreeSpaceGB/$datastore.CapacityGB)
        $row++
    }
    $Word.Selection.Start= $Document.Content.End
    $Selection.TypeParagraph()

#List VMs
    $Selection.Style = "Heading 2"
    $Selection.TypeText("VM Summary")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

    $vms = get-vm -Location $cluster | sort

    $Range = @($Selection.Paragraphs)[-1].Range
    $Table = $Selection.Tables.add($Selection.Range,($vms.Count+1),5,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
    $Table.Style = "Medium Shading 1 - Accent 1"
    $Table.cell(1,1).range.Bold=1
    $Table.cell(1,1).range.text = "VM Name"
    $Table.cell(1,2).range.Bold=1
    $Table.cell(1,2).range.text = "Power State"
    $Table.cell(1,3).range.Bold=1
    $Table.cell(1,3).range.text = "Guest Host Name"
    $Table.cell(1,4).range.Bold=1
    $Table.cell(1,4).range.text = "Guest IP"
    $Table.cell(1,5).range.Bold=1
    $Table.cell(1,5).range.text = "Guest OS Family"

    $row = 0
    foreach ($vm in $vms){
        $vminfo = Get-VMGuest -vm $vm
        $Table.cell(($row+2),1).range.Bold = 0
        $Table.cell(($row+2),1).range.Font.Size = 8
        $Table.cell(($row+2),1).range.text = $vmInfo.VM
        $Table.cell(($row+2),2).range.Bold = 0
        $Table.cell(($row+2),2).range.Font.Size = 8
        $Table.cell(($row+2),2).range.text = $($vm.PowerState -creplace  '([A-Z\W_]|\d+)(?<![a-z])',' $&')
        $Table.cell(($row+2),3).range.Bold = 0
        $Table.cell(($row+2),3).range.Font.Size = 8
        $Table.cell(($row+2),3).range.text = $vmInfo.HostName
        $Table.cell(($row+2),4).range.Bold = 0
        $Table.cell(($row+2),4).range.Font.Size = 8
        $Table.cell(($row+2),4).range.text = $vmInfo.ExtensionData.IPAddress
        $Table.cell(($row+2),5).range.Bold = 0
        $Table.cell(($row+2),5).range.Font.Size = 8
        $Table.cell(($row+2),5).range.text = $($vmInfo.ExtensionData.GuestFamily  -creplace  '([A-Z\W_]|\d+)(?<![a-z])',' $&')
        $row++
    }
    $Word.Selection.Start= $Document.Content.End
    $Selection.TypeParagraph()


#List Portgroups on Distributed vSwitches

    $Selection.Style = "Heading 2"
    $Selection.TypeText("Port Groups")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

    $Selection.Style = "Heading 3"
    $Selection.TypeText("Port Groups on Distributed vSwitches")
    $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
    $Selection.TypeParagraph()

    $vdPortGroups = Get-VDPortgroup -VDSwitch (Get-VDSwitch -VMHost (get-vmhost -Location $cluster))
        if ($vdPortGroups){
            $Range = @($Selection.Paragraphs)[-1].Range
            $Table = $Selection.Tables.add($Selection.Range,($vdPortGroups.count)+1,4,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
            $Table.Style = "Medium Shading 1 - Accent 1"
            $Table.cell(1,1).range.Bold=1
            $Table.cell(1,1).range.text = "Distributed vSwitch Name"
            $Table.cell(1,2).range.Bold=1
            $Table.cell(1,2).range.text = "Portgroup Name"
            $Table.cell(1,3).range.Bold=1
            $Table.cell(1,3).range.text = "VLAN ID"
            $Table.cell(1,4).range.Bold=1
            $Table.cell(1,4).range.text = "VLAN Type"
            $row = 2
            ForEach ($vdPortGroup in $vdPortGroups){
                $Table.cell($row,1).range.Bold=0
                $Table.cell($row,1).range.text = $vdPortGroup.VDSwitch
                $Table.cell($row,2).range.Bold=0
                $Table.cell($row,2).range.text = $vdPortGroup.Name
                $Table.cell($row,3).range.Bold=0
                $Table.cell($row,3).range.text = $vdPortGroup.vlanconfiguration.vlanID
                $Table.cell($row,4).range.Bold=0
                $Table.cell($row,4).range.text = $vdPortGroup.vlanconfiguration.vlanType   
                $row++
            }
        $Word.Selection.Start= $Document.Content.End
        $Selection.TypeParagraph()
        }
        Else{
            $Selection.TypeText("No Distributed Virtual Switches found for cluster $cluster")
    #        $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
            $Selection.TypeParagraph()
        }
        $Selection.Style = "Heading 3"
        $Selection.TypeText("Port Groups on Standard vSwitches")
        $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
        $Selection.TypeParagraph()
       $vsPortGroups = Get-VirtualPortGroup -vmhost $vmhosts -Standard
        if ($vsPortGroups){
            $Range = @($Selection.Paragraphs)[-1].Range
            $Table = $Selection.Tables.add($Selection.Range,($vsPortGroups.count)+1,4,[Microsoft.Office.Interop.Word.wDDefaultTableBehavior]::wdWord9TableBehavior,[Microsoft.Office.Interop.Word.WdAutoFitBehavior]::wdAutoFitContent)
            $Table.Style = "Medium Shading 1 - Accent 1"
            $Table.cell(1,1).range.Bold=1
            $Table.cell(1,1).range.text = "ESXi Host Name"
            $Table.cell(1,2).range.Bold=1
            $Table.cell(1,2).range.text = "Standard vSwitch Name"
            $Table.cell(1,3).range.Bold=1
            $Table.cell(1,3).range.text = "Portgroup Name"
            $Table.cell(1,4).range.Bold=1
            $Table.cell(1,4).range.text = "VLAN ID"
            $row = 2
            ForEach ($vsPortGroup in $vsPortGroups){
                $Table.cell($row,1).range.Bold=0
                $Table.cell($row,1).range.text = $(Get-vmhost -id $vsPortGroup.VMHostId).Name
                $Table.cell($row,2).range.Bold=0
                $Table.cell($row,2).range.text = $vsPortGroup.VirtualSwitch
                $Table.cell($row,3).range.Bold=0
                $Table.cell($row,3).range.text = $vsPortGroup.Name
                $Table.cell($row,4).range.Bold=0
                $Table.cell($row,4).range.text = $vsPortGroup.vlanID
                $row++          
            }
        $Word.Selection.Start= $Document.Content.End
        $Selection.TypeParagraph()
        }
        Else{
            $Selection.TypeText("No Standard Virtual Switches found for cluster $cluster")
    #        $selection.ParagraphFormat.Alignment = "wdAlignParagraphLeft"
            $Selection.TypeParagraph()
        }

    #Close Word
    $Document.SaveAs([ref]($Output + ".pdf"),[ref]$pdf)
    $Document.SaveAs([ref]($Output + ".doc"),[ref]$doc)
    if (!($OneFile)){
        $Document.Close([ref]$DoNotSave)
    }
}
$word.quit()
$null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$word)
[gc]::Collect()
[gc]::WaitForPendingFinalizers()
Remove-Variable word

Write-Log "Finished creating documentation"
Disconnect-VIServer * -Confirm:$false
Exit 0
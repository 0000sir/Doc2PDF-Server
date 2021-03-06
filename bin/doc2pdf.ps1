#############################################
# Doc2PDF                                   #
# Created: April 30, 2016                   #
# Last Modified: June 16, 2016              #
# Version: 1.0                              #
# Supported Office: 2010*, 2013, 2016       #
# Supported PowerShell: 4, 5                #
# Copyright © 2016 Erick Scott Johnson      #
# All rights reserved.                      #
#############################################
#Input
$Input = $args[0]
$Mime = $args[1]

#Define Office Formats
$Wrd_Array = '*.docx', '*.doc', '*.odt', '*.rtf', '*.txt', '*.wpd'
$Exl_Array = '*.xlsx', '*.xls', '*.ods', '*.csv'
$Pow_Array = '*.pptx', '*.ppt', '*.odp'
$Pub_Array = '*.pub'
$Vis_Array = '*.vsdx', '*.vsd', '*.vssx', '*.vss'
$Off_Array = $Wrd_Array + $Exl_Array + $Pow_Array + $Pub_Array + $Vis_Array
$ExtChk    = [System.IO.Path]::GetExtension($Input)

#Convert Word to PDF
Function Wrd-PDF($f, $p)
{
    $Wrd     = New-Object -ComObject Word.Application
    $Version = $Wrd.Version
    try{
        $Doc     = $Wrd.Documents.Open($f, $null, $null, $null, "123456") # Guess the password is 123456
    } catch {
        echo "Cannot Open Password Protected File"
        return
    }
    

    #Check Version of Office Installed
    If ($Version -eq '16.0' -Or $Version -eq '15.0') {
        $Doc.SaveAs([ref] $p, [ref] 17) 
        $Doc.Close([ref] $False)
    }
    ElseIf ($Version -eq '14.0') {
        $Doc.SaveAs([ref] $p,[ref] 17)
        $Doc.Close([ref]$False)
    }
    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
    $Wrd.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Wrd)
    Remove-Variable Wrd
}

#Convert Excel to PDF
Function Exl-PDF($f, $p)
{
    $Exl = New-Object -ComObject Excel.Application
    #$Doc = $Exl.Workbooks.Open($f)
    try{
        $Doc = $Exl.Workbooks.Open($f, $null, $null, $null, "123456")
    } catch {
        echo "Cannot Open Password Protected File"
        return
    }
    $Doc.ExportAsFixedFormat([Microsoft.Office.Interop.Excel.XlFixedFormatType]::xlTypePDF, $p)
    $Doc.Close($False)
    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
    $Exl.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Exl)
    Remove-Variable Exl
}

#Convert PowerPoint to PDF
Function Pow-PDF($f, $p)
{
    $Pow = New-Object -ComObject PowerPoint.Application
    #$Doc = $Pow.Presentations.Open($f, $True, $True, $False)
    try{
        $Doc = $Pow.Presentations.Open($f, $True, $True, $False, "123456")
    } catch {
        echo "Cannot Open Password Protected File"
        return
    }
    $Doc.SaveAs($p, 32)
    $Doc.Close()
    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
    $Pow.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Pow)
    Remove-Variable Pow
}

#Convert Publisher to PDF
Function Pub-PDF($f, $p)
{
    $Pub = New-Object -ComObject Publisher.Application
    $Doc = $Pub.Open($f)
    $Doc.ExportAsFixedFormat([Microsoft.Office.Interop.Publisher.PbFixedFormatType]::pbFixedFormatTypePDF, $p)
    $Doc.Close()
    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
    $Pub.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Pub)
    Remove-Variable Pub
}

#Convert Visio to PDF
Function Vis-PDF($f, $p)
{
    $Vis = New-Object -ComObject Visio.Application
    $Doc = $Vis.Documents.Open($f)
    $Doc.ExportAsFixedFormat([Microsoft.Office.Interop.Visio.VisFixedFormatType]::xlTypePDF, $p)
    $Doc.Close()
    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
    $Vis.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Vis)
    Remove-Variable Vis
}

#Check for Word Formats
Function Wrd-Chk($f, $e, $p){
    $f = [string]$f
    For ($i = 0; $i -le $Wrd_Array.Length; $i++) {
        $Temp = [string]$Wrd_Array[$i]
        $Temp = $Temp.TrimStart('*')
        If ($e -eq $Temp) {
            Wrd-PDF $f $p
            break
        }
    }
}

#Check for Excel Formats
Function Exl-Chk($f, $e, $p){
    $f = [string]$f
    For ($i = 0; $i -le $Exl_Array.Length; $i++) {
        $Temp = [string]$Exl_Array[$i]
        $Temp = $Temp.TrimStart('*')
        If ($e -eq $Temp) {
            Exl-PDF $f $p
        }
    }
}

#Check for PowerPoint Formats
Function Pow-Chk($f, $e, $p){
    $f = [string]$f
    For ($i = 0; $i -le $Pow_Array.Length; $i++) {
        $Temp = [string]$Pow_Array[$i]
        $Temp = $Temp.TrimStart('*')
        If ($e -eq $Temp) {
            Pow-PDF $f $p
        }
    }
}

#Check for Publisher Formats
Function Pub-Chk($f, $e, $p){
    $f = [string]$f
    For ($i = 0; $i -le $Pub_Array.Length; $i++) {
        $Temp = [string]$Pub_Array[$i]
        $Temp = $Temp.TrimStart('*')
        If ($e -eq $Temp) {
            Pub-PDF $f $p
        }
    }
}

#Check for Visio Formats
Function Vis-Chk($f, $e, $p){
    $f = [string]$f
    For ($i = 0; $i -le $Vis_Array.Length; $i++) {
        $Temp = [string]$Vis_Array[$i]
        $Temp = $Temp.TrimStart('*')
        If ($e -eq $Temp) {
            Vis-PDF $f $p
        }
    }
}

Function Convert($File, $mime){
    $Path     = [System.IO.Path]::GetDirectoryName($File)
    $Filename = [System.IO.Path]::GetFileNameWithoutExtension($File)
    $Ext      = [System.IO.Path]::GetExtension($File).Trim()
    $PDF      = $Path + '\' + $Filename + '.pdf'
    if($Ext){
        Wrd-Chk $File $Ext $PDF
        Exl-Chk $File $Ext $PDF
        Pow-Chk $File $Ext $PDF
        Pub-Chk $File $Ext $PDF
        Vis-Chk $File $Ext $PDF
    }elseif($mime){
        switch -regex ($mime){
            "(word|wordprocessingml)" {Wrd-PDF $File $PDF; break}
            "(excel|spreadsheetml|x-ole-storage)" {Exl-PDF $File $PDF; break}
            "(powerpoint|presentationml)" {Pow-PDF $File $PDF; break}
            default {echo "no match"}
        }
    }else{
        echo "Cannot determin file type"
    }
}

Convert $Input $Mime

#Cleanup
Remove-Item Function:Wrd-PDF, Function:Wrd-Chk
Remove-Item Function:Exl-PDF, Function:Exl-Chk
Remove-Item Function:Pow-PDF, Function:Pow-Chk
Remove-Item Function:Pub-PDF, Function:Pub-Chk
Remove-Item Function:Vis-PDF, Function:Vis-Chk
##In Development
##Module will eventually emulate the functionality of the basic file system cmdlets in powershell using the AlphaFS classes to provide additional functionality

#region HelperModules
#Imports the AlphaFS modules.  only here to save typing and make things look a bit cleaner
Function Import-AlphaModule{
    try{
        $scriptPath = (Split-Path ((Get-Variable MyInvocation -Scope Script).Value.MyCommand.Path))
        Import-Module "$scriptPath\dll\Alphafs.dll"
    }catch{
        Import-Module ".\dll\AlphaFS.dll"
    }    
}
#endregion

#Will Emulate the copy-item command, currently basic file and directory copy's are implemented with the option to force
Function Copy-ItemAlpha{
    [cmdletbinding()]
    param(
      [parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)]
        $sourceFile,
      [parameter(Mandatory=$true,Position=2)]
        $destinationFile,
      [parameter(Mandatory=$False)]
        [switch]$force
    )    

    Import-AlphaModule
    if([Alphaleonis.Win32.Filesystem.File]::Exists($sourceFile)){
        if($force){
            [Alphaleonis.Win32.Filesystem.File]::Copy($sourceFile,$destinationFile,'overwrite=true')
        
        }else{
            [Alphaleonis.Win32.Filesystem.File]::Copy($sourceFile,$destinationFile)        
        }
    }
    if([Alphaleonis.Win32.Filesystem.Directory]::Exists($sourceFile)){
        if($force){
            [Alphaleonis.Win32.Filesystem.Directory]::Copy($sourceFile,$destinationFile,'overwrite=true')
        
        }else{
            [Alphaleonis.Win32.Filesystem.Directory]::Copy($sourceFile,$destinationFile)        
        }
    }
}

#Will Emulate Remove-Item, currently basic file and directory delete's are implemented with a force option
Function Remove-ItemAlpha {
    [cmdletbinding()]
    param(
      [parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)]
        $Path,
      [parameter(Mandatory=$False)]
        [switch]$force
    )
    Import-AlphaModule
    
    if([Alphaleonis.Win32.Filesystem.File]::Exists($path)){
        if($force){
            [Alphaleonis.Win32.Filesystem.File]::Delete($path,"ignorereadonly=true")
        }else{
            [Alphaleonis.Win32.Filesystem.File]::Delete($path)
        }
    }
    if([Alphaleonis.Win32.Filesystem.Directory]::Exists($path)){
        if($force){
            [Alphaleonis.Win32.Filesystem.Directory]::Delete($path,"ignorereadonly=true")
        }else{
            [Alphaleonis.Win32.Filesystem.Directory]::Delete($path)
        }
    }
}


#Using These will allow the helper functions to be hidden
<#
Export-ModuleMember Copy-ItemAlpha
Export-ModuleMember Remove-ItemAlpha
#>
﻿Function Format-APTemplate
{
    <#
    .SYNOPSIS

    Replaces tokens in a json template.

    .DESCRIPTION

    Replaces tokens in a json template. The json template tokens should be unique strings like '%Project%' or '__Collection__'. 
    By passing key value pairs with the InputObject parameter @{'%Project% = 'myProject'} the tokens will be replaced with the values.
    Templates can be created by using Get-APBuildDefinition or Get-APReleaseDefinition and tokenizing it.

    .PARAMETER Path
    
    Path to the build/release json template that contains tokens.
    
    .PARAMETER InputObject
    
    Object, that contains key value pairs for token replacement.

    .INPUTS
    

    .OUTPUTS

    PSobject, Azure Pipelines build/release template. Pass the template to Publish-APBuild or Publish-APRelease.

    .EXAMPLE

    C:\PS> $inputObject = @{
        %Project% = 'myProject'
    }
    C:\PS> Format-APTemplate -Path '.\myTemplate.json' -InputObject $inputObject

    .LINK

    https://docs.microsoft.com/en-us/rest/api/vsts/release/releases/list?view=vsts-rest-5.0
    #>
    Param
    (
        [Parameter(Mandatory)]
        [string]
        $Path,

        [Parameter(Mandatory)]
        [object]
        $InputObject
    )

    Begin
    {
    }
    Process
    {        
        $templateJson = Get-Content -Path $Path -Raw  
        $InputObject.Keys | ForEach-Object -Process { $templateJson = $templateJson -replace $_, $InputObject.Item($_) }
        ConvertFrom-Json -Inputobject $templateJson 
    }
}
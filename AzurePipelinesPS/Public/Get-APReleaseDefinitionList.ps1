function Get-APReleaseDefinitionList
{
    <#
    .SYNOPSIS

    Returns a list of Azure Pipeline release definition(s).

    .DESCRIPTION

    Returns a list of Azure Pipeline release definitions(s) based on a filter query, if one is not provided the default will return the top 50 releases for the project provided.

    .PARAMETER Instance
    
    The Team Services account or TFS server.
    
    .PARAMETER Collection
    
    For Azure DevOps the value for collection should be the name of your orginization. 
    For both Team Services and TFS The value should be DefaultCollection unless another collection has been created.

    .PARAMETER Project
    
    Project ID or project name.

    .PARAMETER ApiVersion
    
    Version of the api to use.

    .PARAMETER PersonalAccessToken
    
    Personal access token used to authenticate. https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=vsts

    .PARAMETER Credential

    Specifies a user account that has permission to send the request.

    .PARAMETER Session

    Azure DevOps PS session, created by New-APSession.
    
    .PARAMETER SearchText
    
    Releases with names starting with searchText.

    .PARAMETER Expand
    
    The property that should be expanded in the list of releases.

    .PARAMETER ArtifactType
    
    Release definitions with given artifactType will be returned. Values can be Build, Jenkins, GitHub, Nuget, Team Build (external), ExternalTFSBuild, Git, TFVC, ExternalTfsXamlBuild.

    .PARAMETER Top
    
    Number of releases to get. Default is 50.

    .PARAMETER ContinuationToken
    
    Gets the releases after the continuation token provided.

    .PARAMETER QueryOrder
    
    Gets the results in the defined order of created date for releases. Default is descending.

    .PARAMETER Path
    
    Gets the release definitions under the specified path.
    
    .PARAMETER IsExactNameMatch
    
    Set to 'true' to get the release definitions with exact match as specified in searchText. Default is 'false'.

    .PARAMETER TagFilter
    
    A comma-delimited list of tags. Only releases with these tags will be returned.

    .PARAMETER PropertyFilters
    
    A comma-delimited list of extended properties to retrieve.

    .PARAMETER DefinitionIdFilter
    
    A comma-delimited list of release definitions to retrieve.

    .PARAMETER IsDeleted
    
    Gets the soft deleted releases, if true.

    .INPUTS
    

    .OUTPUTS

    PSObject, Azure Pipelines release definition(s)

    .EXAMPLE

    C:\PS> Get-APReleaseDefinitionList -Instance 'https://myproject.visualstudio.com' -Collection 'DefaultCollection' -Project 'myFirstProject'

    .LINK

    https://docs.microsoft.com/en-us/rest/api/vsts/release/releases/list?view=vsts-rest-5.0
    #>
    [CmdletBinding(DefaultParameterSetName = 'ByPersonalAccessToken')]
    Param
    (
        [Parameter(Mandatory,
            ParameterSetName = 'ByPersonalAccessToken')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByCredential')]
        [uri]
        $Instance,

        [Parameter(Mandatory,
            ParameterSetName = 'ByPersonalAccessToken')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByCredential')]
        [string]
        $Collection,

        [Parameter(Mandatory,
            ParameterSetName = 'ByPersonalAccessToken')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByCredential')]
        [string]
        $Project,

        [Parameter(Mandatory,
            ParameterSetName = 'ByPersonalAccessToken')]
        [Parameter(Mandatory,
            ParameterSetName = 'ByCredential')]
        [string]
        $ApiVersion,

        [Parameter(ParameterSetName = 'ByPersonalAccessToken')]
        [Security.SecureString]
        $PersonalAccessToken,

        [Parameter(ParameterSetName = 'ByCredential')]
        [pscredential]
        $Credential,

        [Parameter(Mandatory,
            ParameterSetName = 'BySession')]
        [object]
        $Session,

        [Parameter()]
        [string]
        $SearchText,

        [Parameter()]
        [string]
        [ValidateSet('approvals', 'artifacts', 'environments', 'manualInterventions', 'none', 'tags', 'variables')]
        $Expand,

        [Parameter()]
        [string]
        $ArtifactType,

        [Parameter()]
        [string]
        $Top,

        [Parameter()]
        [string]
        $ContinuationToken,

        [Parameter()]
        [string]
        $QueryOrder,

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $IsExactNameMatch,

        [Parameter()]
        [string]
        $TagFilter,

        [Parameter()]
        [string]
        $PropertyFilters,

        [Parameter()]
        [string]
        $DefinitionIdFilter,

        [Parameter()]
        [bool]
        $IsDeleted
    )

    begin
    {
        If ($PSCmdlet.ParameterSetName -eq 'BySession')
        {
            $currentSession = $Session | Get-APSession
            If ($currentSession)
            {
                $Instance = $currentSession.Instance
                $Collection = $currentSession.Collection
                $Project = $currentSession.Project
                $ApiVersion = (Get-APApiVersion -Version $currentSession.Version)
                $PersonalAccessToken = $currentSession.PersonalAccessToken
            }
        }
    }
    
    process
    {
        $apiEndpoint = Get-APApiEndpoint -ApiType 'release-definitions'
        $queryParameters = Set-APQueryParameters -InputObject $PSBoundParameters
        $setAPUriSplat = @{
            Collection  = $Collection
            Instance    = $Instance
            Project     = $Project
            ApiVersion  = $ApiVersion
            ApiEndpoint = $apiEndpoint
            Query       = $queryParameters
        }
        [uri] $uri = Set-APUri @setAPUriSplat
        $invokeAPRestMethodSplat = @{
            Method              = 'GET'
            Uri                 = $uri
            Credential          = $Credential
            PersonalAccessToken = $PersonalAccessToken
        }
        $results = Invoke-APRestMethod @invokeAPRestMethodSplat | Select-Object -ExpandProperty value
        If ($results.count -eq 0)
        {
            Write-Error "[$($MyInvocation.MyCommand.Name)]: Unable to locate release." -ErrorAction Stop
        }
        Else
        {
            return $results
        }
    }
    
    end
    {
    }
}
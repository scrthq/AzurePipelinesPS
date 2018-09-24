function Get-APApiEndpoint
{    
    <#
    .SYNOPSIS

    Returns the api uri endpoint.

    .DESCRIPTION

    Returns the api uri endpoint.
    This function will return the api endpoint for that api type provided.

    .PARAMETER ApiType

    Type of the api endpoint to use.

    .OUTPUTS

    String, The uri endpoint that will be used by Set-APUri.

    .EXAMPLE

    C:\PS> Get-APApiEndpoint -ApiType release-releases

    .LINK

    https://docs.microsoft.com/en-us/rest/api/vsts/?view=vsts-rest-5.0
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory)]
        [string]
        $ApiType
    )

    begin
    {
    }

    process
    {
        Switch ($ApiType)
        {
            'build-builds'
            {
                Return '_apis/build/builds'
            }
            'build-definitions'
            {
                Return '_apis/build/definitions'
            }
            'build-definitionId'
            {
                Return '_apis/build/definitions/{0}'
            }
            'packages-agent'
            {
                Return '_apis/distributedTask/packages/agent'
            }
            'release-release'
            {
                Return '_apis/release/releases'
            }
            'release-definitions'
            {
                Return '_apis/release/definitions'
            }
            'release-releaseId'
            {
                Return '_apis/release/releases/{0}'
            }
            'release-manualInterventionId'
            {
                Return '_apis/release/releases/{0}/manualinterventions/{1}'
            }
            'release-environmentId'
            {
                Return '_apis/release/releases/{0}/environments/{1}'
            }
            'release-taskId'
            {
                Return '_apis/release/releases/{0}/environments/{1}/deployPhases/{2}/tasks/{3}'
            }
            default
            {
                Write-Error "[$($MyInvocation.MyCommand.Name)]: [$ApiType] is not supported" -ErrorAction Stop
            }
        }
    }

    end
    {
    }
}
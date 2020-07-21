<#
.SYNOPSIS
   Writes a given config object to disk
.DESCRIPTION
   Writes a given config object to disk
.FUNCTIONALITY
   Writes a given config object to disk
.EXAMPLE
   PS>Write-IcingaPowerShellConfig -Config $PSObject;
.PARAMETER Config
   A PSObject containing the entire configuration to write
.INPUTS
   System.Object
.LINK
   https://github.com/Icinga/icinga-powershell-framework
#>

function Write-IcingaPowerShellConfig()
{
    param(
        $Config
    );

    $ConfigDir  = Get-IcingaPowerShellConfigDir;
    $ConfigFile = Join-Path -Path $ConfigDir -ChildPath 'config.json';

    if (-Not (Test-Path $ConfigDir)) {
        New-Item -Path $ConfigDir -ItemType Directory | Out-Null;
    }

    $Content = ConvertTo-Json -InputObject $Config -Depth 100;

    Set-Content -Path $ConfigFile -Value $Content;

    if ($global:IcingaDaemonData.FrameworkRunningAsDaemon) {
        if ($global:IcingaDaemonData.ContainsKey('Config')) {
            $global:IcingaDaemonData.Config = $Config;
        }
    }
}

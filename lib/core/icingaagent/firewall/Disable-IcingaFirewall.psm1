function Disable-IcingaFirewall()
{
    param(
        [switch]$LegacyOnly
    );

    $FirewallConfig = Get-IcingaFirewallConfig -NoOutput;

    if ($FirewallConfig.LegacyFirewall) {
        $Firewall = Start-IcingaProcess -Executable 'netsh' -Arguments 'advfirewall firewall delete rule name="Icinga 2 Agent Inbound by PS-Module"';
        if ($Firewall.ExitCode -ne 0) {
            Write-IcingaConsoleError ([string]::Format('Failed to remove legacy firewall: {0}{1}', $Firewall.Message, $Firewall.Error));
        } else {
            Write-IcingaConsoleNotice 'Successfully removed legacy firewall rule';
        }
    }

    if ($LegacyOnly) {
        return;
    }

    if ($FirewallConfig.IcingaFirewall) {
        $Firewall = Start-IcingaProcess -Executable 'netsh' -Arguments 'advfirewall firewall delete rule name="Icinga Agent Inbound"';
        if ($Firewall.ExitCode -ne 0) {
            Write-IcingaConsoleError ([string]::Format('Failed to remove Icinga firewall: {0}{1}', $Firewall.Message, $Firewall.Error));
        } else {
            Write-IcingaConsoleNotice 'Successfully removed Icinga firewall rule';
        }
    }
}

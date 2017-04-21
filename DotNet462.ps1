Configuration Net462
{            
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {
        Script DownloadDotNet462
        {
            TestScript = {
                Test-Path "C:\WindowsAzure\NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
            }
            SetScript = {
                $source = "http://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
                $dest = "C:\WindowsAzure\NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
                Invoke-WebRequest $source -OutFile $dest
            }
            GetScript = {@{Result = "DownloadDotNet462"}}
        }
        Script InstallDotNet462
        {
            TestScript = {
                $dotNetFull = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
                Get-ItemProperty -name Version,Release -EA 0 |
                Where { $_.Version -match '4.6.01590' -and $_.PSChildName -eq 'Full' }
                If ($dotNetFull -eq $null) { $false } Else { $true }
            }
            SetScript ={
                $proc = Start-Process -FilePath "C:\WindowsAzure\NDP462-KB3151800-x86-x64-AllOS-ENU.exe" -ArgumentList "/quiet /norestart /log C:\WindowsAzure\NDP462-KB3151800-x86-x64-AllOS-ENU_install.log" -PassThru -Wait
                Switch($proc.ExitCode)
                {
                    0 {
                        # Success
                    }
                    1603 {
                        Throw "Failed installation"
                    }
                    1641 {
                        # Restart required
                        $global:DSCMachineStatus = 1
                    }
                    3010 {
                        # Restart required
                        $global:DSCMachineStatus = 1
                    }
                    5100 {
                        Throw "Computer does not meet system requirements."
                    }
                    default {
                        Throw "Unknown exit code $($proc.ExitCode)"
                    }
                }
            }
            GetScript = {@{Result = "InstallDotNet462"}}
            DependsOn = "[Script]DownloadDotNet462"
        }
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }
    }
}

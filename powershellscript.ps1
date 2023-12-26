# Display menu to choose option
Write-Output ""
Write-Host "			Choose an option:"
Write-Host ""
Write-Host "		1. Enumerate System Information" -ForegroundColor Yellow
Write-Host "		2. Extract Network Configuration" -ForegroundColor Yellow
Write-Host "		3. List Running Processes with Details" -ForegroundColor Yellow
Write-Host "		4. Scanning for Open Ports" -ForegroundColor Yellow
Write-Host "		5. Enumerating Domain Users" -ForegroundColor Yellow
Write-Host "		6. Enumerate AV software using wmic" -ForegroundColor Yellow
Write-Host "		7. Domain?" -ForegroundColor Yellow
Write-Host ""

# Get user input
$choice = Read-Host "Enter the option number (1, 2, 3, 4, 5)"

# Validate user input
if ($choice -eq "1") {
    # Execute option 1 to retrieves detailed information about the operating system, including version, build, and system architecture
    Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property *
}
elseif ($choice -eq "2") {
    # Execute option 2 to gathers network configuration details such as interface aliases, IPv4 and IPv6 addresses, and DNS server information
    Get-NetIPConfiguration | Select-Object -Property InterfaceAlias, IPv4Address, IPv6Address, DNServer
}
elseif ($choice -eq "3") {
    # Execute option 3 to lists all currently running processes on the system, sorted by CPU usage, and includes process names, IDs, and CPU time
    Get-Process | Select-Object -Property ProcessName, Id, CPU | Sort-Object -Property CPU -Descending
}
elseif ($choice -eq "4") {
    # Execute option 4 to scans the first 1024 ports on the local machine to check for open ports, which can be used to identify potentialvulnerabilities
    1..1024 | ForEach-Object { $sock = New-Object System.Net.Sockets.TcpClient; $async =$sock.BeginConnect('localhost', $_, $null, $null); $wait = $async.AsyncWaitHandle.WaitOne(100, $false);if($sock.Connected) { $_ } ; $sock.Close() }
}
elseif ($choice -eq "5") {
    # Execute option 5 to retrieves a list of all domain users, including their names, account status, and last logon dates.
    Get-ADUser -Filter * -Properties * | Select-Object -Property Name, Enabled, LastLogonDate
}
elseif ($choice -eq "6") {
    # Enumerate AV software using Windows built-in tools, such as wmic (Windows servers may not have SecurityCenter2 namespace, which may not work on the attached VM. Instead, it works for Windows workstations!)
    wmic /namespace:\\root\securitycenter2 path antivirusproduct
}
elseif ($choice -eq "7") {
    # Check whether the Windows machine is part of the AD environment
    systeminfo | findstr Domain
}
else {
    Write-Host "Invalid option. Please enter 1, 2, 3, 4, 5, 6, 7"
}

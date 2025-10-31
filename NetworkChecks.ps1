
$processList = Get-NetTCPConnection;

foreach ($process in $processList){
    $port = $process.RemotePort;
    if ($port -ne 80 -and $port -ne 443 -and $port -ne 0){
        $ProcessID = $process.OwningProcess;
        $ProgramName = Get-Process -Id $ProcessID;
        if ($ProgramName.ProcessName -eq "Idle"){
            Write-Host "[*] Serious Warning $ProgramName.ProcessName [$ProcessID] Listening on $port" -ForegroundColor Yellow;
        } else {
            Write-Host "[*] Warning $ProgramName.ProcessName [$ProcessID] Listening on $port";
        }
    } else {
        continue;
    }
}
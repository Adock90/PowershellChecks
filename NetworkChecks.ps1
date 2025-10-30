
$processList = Get-NetTCPConnection;

foreach ($process in $processList){
    $port = $process.RemotePort;
    if ($port -ne 80 -and $port -ne 443 -and $port -ne 0){
        $ProcessID = $process.OwningProcess;
        $ProgramName = Get-Process -Id $ProcessID;
        Write-Host "[*] Warning $ProgramName [$ProcessID] Listening on $port";
    } else {
        continue;
    }
}
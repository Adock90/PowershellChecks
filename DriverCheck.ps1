param(
    [Parameter(Mandatory=$False)]
    [string]$Mode
)

function Help(){
    Write-Host "Credits: Adock90 (Adam Croft)";
    Write-Host "DriverCheck 1.0";
    Write-Host "Designed to give a quick check for malicous and unsigned driver in Powershell for Windows. \n hi";
    
    Write-Host "DriverCheck [<Param>]";
    
    Write-Host "      --h            : Help for commands";
    Write-Host "      --Essential    : Outputs only essential alerts to console";
}

if ($Mode -eq "--h") {
    Write-Host "Help Granted";
    Help;
    Exit-PSSession;
}

$OutputDomp = "./DriverOutput.csv";

Write-Host "[*] Outputting Driver info in $OutputDomp";

driverquery /v /fo csv > $OutputDomp;

$RunCommand = Import-Csv $OutputDomp | ForEach-Object {
    $DriverModulePath = $_.'Path';
    if ($DriverModulePath -and (Test-Path -Path $DriverModulePath)){
        if ($Mode -ne "--Essential"){
            Write-Host "[*] Testing $DriverModulePath";
        }
        $DriverSignature = Get-AuthenticodeSignature $DriverModulePath;
        if ($DriverSignature.Status -ne "Valid"){
            Write-Host "[*] Unsigned Driver at $DriverModulePath";
        }
        if (($DriverModulePath -contains "AppData") -or ($DriverModulePath -contains "Temp")){
            Write-Host "[*] Suspicous Location: $DriverModulePath";
        }
    } else {
        Write-Host "[*] Invalid Path $DriverModulePath";
    }
} 
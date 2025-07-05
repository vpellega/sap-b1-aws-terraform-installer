$ErrorActionPreference = "Continue"
$logBuffer = New-Object System.Collections.ArrayList

Function Log($msg) {
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $entry = "$timestamp - $msg"
  $logBuffer.Add($entry) | Out-Null
  Write-Output $entry
}


Log "Iniciando script de instalação..."

# Instalar AWS CLI se necessário
try {
    if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
        Log "AWS CLI não encontrado. Iniciando download e instalação..."
        $cliInstaller = "$env:TEMP\AWSCLIV2.msi"
        Invoke-WebRequest "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile $cliInstaller
        Start-Process "msiexec.exe" -ArgumentList "/i `"$cliInstaller`" /qn" -Wait
        Log "AWS CLI instalado com sucesso."
        $env:Path += ";$env:ProgramFiles\Amazon\AWSCLIV2"
        $awsVersion = aws --version 2>&1
        Log "Versão da AWS CLI detectada: $awsVersion"
    } else {
        Log "AWS CLI já está disponível."
    }
} catch {
    Log "Erro ao instalar AWS CLI: $_"
}

# Instalar ODBC Driver 17 for SQL Server se necessário
try {
    $odbcDriver = Get-OdbcDriver | Where-Object { $_.Name -eq "ODBC Driver 17 for SQL Server" }
    if (-not $odbcDriver) {
        Log "ODBC Driver 17 for SQL Server não encontrado. Iniciando download e instalação..."
        $odbcInstaller = "$env:TEMP\msodbcsql17.msi"
        Invoke-Expression "aws s3 cp s3://sapb1-installer/prereq/msodbcsql17.msi `"$odbcInstaller`""
        Start-Process "msiexec.exe" -ArgumentList "/i `"$odbcInstaller`" /quiet /norestart IACCEPTMSODBCSQLLICENSETERMS=YES" -Wait
        Log "ODBC Driver 17 for SQL Server instalado com sucesso."
    } else {
        Log "ODBC Driver 17 for SQL Server já está disponível."
    }
} catch {
    Log "Erro ao instalar ODBC Driver 17: $_"
}

# Baixar o .zip do SAP B1
$zipPath = "C:\Installers\sapb1.zip"
try {
    Log "Iniciando download do SAP B1 .zip..."
    aws s3 cp s3://sapb1-installer/sap/10.0_FP2405/B11000_2405-70004131.zip $zipPath
    Log "Download concluído: $zipPath"
} catch {
    Log "Erro ao baixar o .zip do SAP B1: $_"
}

# Extrair o .zip
$extractPath = "C:\Installers\SAP_B1"
if (-not (Test-Path $extractPath)) {
    New-Item -ItemType Directory -Path $extractPath -Force | Out-Null
    Log "Diretório de extração criado: $extractPath"
}

try {
    Log "Extraindo arquivo para: $extractPath"
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
    Log "Extração concluída com sucesso."
} catch {
    Log "Erro ao extrair o .zip: $_"
}

# Salvar log e enviar para o S3
$logTempFile = "$env:TEMP\startup-log.txt"
$logBuffer | Out-File -FilePath $logTempFile -Encoding UTF8

try {
    Log "Enviando log para o S3..."
    aws s3 cp $logTempFile s3://sapb1-installer/logs/startup/startup-log.txt
    Log "Log enviado com sucesso."
} catch {
    Log "Erro ao enviar log para o S3: $_"
}
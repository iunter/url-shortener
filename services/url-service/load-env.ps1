
$ErrorActionPreference = 'Stop'

$envFile = Join-Path $PSScriptRoot '.env'
$wrapper = Join-Path $PSScriptRoot 'mvnw.cmd'

if (!(Test-Path -LiteralPath $envFile)) {
    Write-Error "No se encontró el archivo .env: $envFile"
    exit 1
}

Get-Content -LiteralPath $envFile | ForEach-Object {
    $line = $_.Trim()

    if (!$line -or $line.StartsWith('#')) {
        return
    }

    if ($line -match '^([A-Za-z_][A-Za-z0-9_]*)\s*=(.*)$') {
        $name = $matches[1]
        $value = $matches[2].Trim()

        if (($value.StartsWith('"') -and $value.EndsWith('"')) -or
            ($value.StartsWith("'") -and $value.EndsWith("'"))) {
            $value = $value.Substring(1, $value.Length - 2)
        }

        [Environment]::SetEnvironmentVariable($name, $value, 'Process')
    }
    else {
        throw "Formato inválido en .env: $line"
    }
}

& $wrapper @args
exit $LASTEXITCODE

param([Parameter(Mandatory)][string]$Exe)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$binary = Join-Path $root 'target\release\victory.exe'
if (!(Test-Path -LiteralPath $binary)) { throw 'Compile primeiro: cargo build --locked --release -p victory --features diagnostics,blake3/pure' }
$game = (Resolve-Path -LiteralPath $Exe).Path
foreach ($entry in @(Get-ChildItem Env:VICTORY_*)) {
    if ($entry.Name -notin @('VICTORY_CONFIG','VICTORY_GAME_DIR','VICTORY_CACHE_DIR','VICTORY_DATA_DIR')) {
        Remove-Item -LiteralPath ('Env:' + $entry.Name)
    }
}
if (!$env:VICTORY_GAME_DIR) { $env:VICTORY_GAME_DIR = Split-Path $game -Parent }
if (!$env:VICTORY_CACHE_DIR) { $env:VICTORY_CACHE_DIR = Join-Path $env:LOCALAPPDATA 'huster-projetct\cache' }
if (!$env:VICTORY_DATA_DIR) { $env:VICTORY_DATA_DIR = Join-Path $env:LOCALAPPDATA 'huster-projetct\data' }
$env:VICTORY_INDIRECT_WINDOW='1'
$env:VICTORY_INDIRECT_WINDOW_CHECK='0'
$env:VICTORY_LEVELS_ON_DEMAND='1'
$env:VICTORY_WINDOW_MAX='1280x720'
$env:VICTORY_LOG='warn,victory_gpu::host=info,victory_gpu::frame=debug'
# Preserve the upstream renderer defaults. Experimental controls are opt-in.
$ErrorActionPreference = 'Continue'
& $binary run $game --execute
exit $LASTEXITCODE

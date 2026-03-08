param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$TargetRoot,

    [Parameter(Mandatory = $true)]
    [string]$ExecutableRelativePath
)

$ErrorActionPreference = "Stop"

$excludePatterns = @("*.pch", "*.pdb", "*.ilk", "*.ipdb", "*.iobj", "*.obj", "*.lib", "*.exp")
$payloadRoot = Join-Path $TargetRoot "payload"

if (Test-Path $payloadRoot) {
    Remove-Item $payloadRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $payloadRoot -Force | Out-Null

$sourceRoot = (Resolve-Path $SourcePath).Path
$files = Get-ChildItem $sourceRoot -Recurse -File | Where-Object {
    $name = $_.Name
    -not ($excludePatterns | Where-Object { $name -like $_ })
}

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($sourceRoot.Length).TrimStart('\')
    $destinationPath = Join-Path $payloadRoot $relativePath
    New-Item -ItemType Directory -Path (Split-Path $destinationPath -Parent) -Force | Out-Null
    Copy-Item $file.FullName $destinationPath -Force
}

$manifest = [ordered]@{
    PackageId = Split-Path $TargetRoot -Leaf
    PayloadRoot = "payload"
    ExecutableRelativePath = $ExecutableRelativePath
    Files = @()
}

$payloadFiles = Get-ChildItem $payloadRoot -Recurse -File | Sort-Object FullName
foreach ($file in $payloadFiles) {
    $relativePath = $file.FullName.Substring($payloadRoot.Length).TrimStart('\')
    $manifest.Files += [ordered]@{
        RelativePath = $relativePath -replace '\\', '/'
        Size = [int64]$file.Length
    }
}

$manifest | ConvertTo-Json -Depth 6 | Set-Content -Path (Join-Path $TargetRoot "package.json")

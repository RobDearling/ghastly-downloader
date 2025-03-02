$url = "https://pokemmo.com/download_file/1/"
$response = Invoke-WebRequest -Uri $url -MaximumRedirection 0
$redirectUrl = $response.Headers.Location

if ($redirectUrl -match 'r=(\d+)') {
    $revision = $matches[1]
} else {
    Write-Error "Revision number not found in URL."
    exit 1
}

$revisionsFolder = Join-Path -Path (Get-Location) -ChildPath "revisions"
if (-not (Test-Path $revisionsFolder)) {
    New-Item -ItemType Directory -Path $revisionsFolder | Out-Null
}

$outputFile = Join-Path -Path $revisionsFolder -ChildPath ("{0}.zip" -f $revision)

if (Test-Path $outputFile) {
    Write-Output "Revision $revision already exists. Skipping download."
    exit 0
}
Write-Host "Downloading revision $revision..."
Invoke-WebRequest -Uri $redirectUrl -OutFile $outputFile
Write-Host "Download complete for revision $revision."

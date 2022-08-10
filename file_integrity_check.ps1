Function compute-file-hash($filepath) {
    $filepath = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filepath
}

$hash = compute-file-hash "D:\powershell_FIM\Files\test.txt"


Function remove-baseline () {
    $current_baseline = Test-Path -Path ./baseline.txt

    if($current_baseline) {
    # if the current baseline exits then we will delete it
    Remove-Item -Path ./baseline.txt
    }
}


Write-Host "what would you like to do?"

Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring files with Baseline?"

$response = Read-Host -Prompt "Please give your input: "
Write-Host ""
Write-Host "User entered $($response)" 

if ($response -eq "A".ToUpper()) {

    # Remove baseline file if it already exist.

    remove-baseline

    # calculate Hash from the target file and store in baseline.txt
    #collecting all files in single variable
    $files = Get-ChildItem -Path D:\powershell_FIM\Files

    #calculating hashes for each file
    foreach ($file in $files) {
    $hash = compute-file-hash $files.FullName
    "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath D:\powershell_FIM\baseline.txt -Append
    }
}

elseif ($response -eq "B".ToUpper()){
    #Begin monitoring files with saved baseline
    Write-Host "Read existing baseline.txt, start monitoring file" -ForegroundColor Green
}
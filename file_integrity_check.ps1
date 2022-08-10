Function compute-file-hash($filepath) {
    $filepath = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filepath
}

$hash = compute-file-hash "D:\powershell_FIM\Files\test.txt"


Function remove-baseline () {
    $current_baseline = Test-Path -Path D:\powershell_FIM\baseline.txt

    if($current_baseline) {
    # if the current baseline exits then we will delete it
    Remove-Item -Path D:\powershell_FIM\baseline.txt
    }
}


Write-Host "what would you like to do?"

Write-Host "A) Collect new Baseline?"
Write-Host "B) Begin monitoring files with Baseline?"

$response = Read-Host -Prompt "Please give your input: "
Write-Host ""
Write-Host "User entered $($response)" 

# Users wants to start fresh. ************************************

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

# Users want to examin an already created hash file ********************


elseif ($response -eq "B".ToUpper()){
    #Begin monitoring files with saved baseline
    Write-Host "Read existing baseline.txt, start monitoring file" -ForegroundColor Green

    # Load file hashes from file and store in dictionary structure.
    $filehash = @{}
    $filepath = Get-Content -Path D:\powershell_FIM\baseline.txt

    # Split the file location and hash value 
    foreach($f in $filepath){
        $filehash.Add($f.Split("|")[0], $f.Split("|")[1])
    }

    # File monotiring steps.
    while (True) {
        Start-Sleep -Seconds 1
        #we are collecting all the files in Files folder 

        $files = Get-ChildItem -Path D:\powershell_FIM\Files

        # calculate the hash value of each file. 

        foreach ($f in $files){
            $hash = compute-file-hash $f.FullName

            if ($null -eq $filehash[$hash.Path]) {
                Write-Host "$(hash.Path) has been created!" -ForegroundColor Green
            }
            else {
                if ($filehash[$hash.Path] -eq $hash.Hash){
                }
                else {
                    Write-Host "$($hash.Path) has been tampered." -ForegroundColor Red
                }
            }
        }

        foreach($key in $filehash.Keys){
            $baselinefileExists = Test-Path -Path $key
            if(-Not $baselinefileExists){
                #one or more baseline files must have been deleted. 
                Write-Host "$($key) has been deleted" -ForegroundColor DarkRed
            }
        }
    }
}
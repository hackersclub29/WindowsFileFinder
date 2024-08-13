# Script: Find-Files.ps1

# Function to find files
function Find-Files {
    param (
        [string]$searchTerm
    )

    # Determine if the search term is a file name or an extension
    if ($searchTerm -match '^\.\w+$') {
        Write-Host "Searching for files with the extension: $searchTerm"
    } else {
        Write-Host "Searching for files with the name: $searchTerm"
    }

    # Get all drives
    $drives = Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root

    # Initialize an empty array to store results
    $foundFiles = @()

    # Loop through each drive and search for files
    foreach ($drive in $drives) {
        Write-Host "Searching in drive: $drive"
        try {
            $files = Get-ChildItem -Path $drive -Recurse -ErrorAction SilentlyContinue |
                     Where-Object {
                        if ($searchTerm -match '^\.\w+$') {
                            $_.Extension -eq $searchTerm
                        } else {
                            $_.Name -eq $searchTerm
                        }
                     }

            # Add found files to the result array
            $foundFiles += $files
        } catch {
            Write-Host "Error accessing drive $drive. Skipping..."
        }
    }

    # Output results
    if ($foundFiles.Count -eq 0) {
        Write-Host "No files found matching '$searchTerm'."
    } else {
        Write-Host "Files found:"
        $foundFiles | ForEach-Object { Write-Host $_.FullName }
    }
}

# Prompt the user for input
$searchTerm = Read-Host "Enter the filename or extension (e.g., '.txt' or 'file.txt')"

# Call the Find-Files function
Find-Files -searchTerm $searchTerm

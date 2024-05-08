# Define the paths for the 'media' folder and the 'filtered' folder
$mediaPath = ".\media"
$filteredPath = ".\filtered_media"


# Create the 'filtered' directory if it doesn't already exist
try {
    if (-Not (Test-Path $filteredPath)) {
        New-Item -ItemType Directory -Path $filteredPath
    }
} catch {
    Write-Error "Failed to create the filtered directory: $_"
    exit
}

# Allowed file extensions
$allowedExtensions = @('.jpeg', '.jpg', '.png')

# Iterate through each subfolder in the 'media' directory
Get-ChildItem -Path $mediaPath -Directory | ForEach-Object {
    try {
        $subfolder = $_
        # Get the file inside the subfolder
        $file = Get-ChildItem -Path $subfolder.FullName -File
        
        # Extract the extension and check if it is in the allowed list
        if ($file.Extension.ToLower() -in $allowedExtensions) {
            $extension = $file.Extension.Substring(1) # remove the dot for folder naming
            $newDir = Join-Path -Path $filteredPath -ChildPath $extension

            # Create a new directory for this file type if it doesn't already exist
            if (-Not (Test-Path $newDir)) {
                New-Item -ItemType Directory -Path $newDir
            }
            
            # Copy the subfolder to the new directory
            $destinationPath = Join-Path -Path $newDir -ChildPath $subfolder.Name
            Copy-Item -Path $subfolder.FullName -Destination $destinationPath -Recurse
        }
    } catch {
        Write-Error "Failed processing ${subfolder}: $_"
    }
}

Write-Host "JPEG, JPG, and PNG files have been organized and copied."

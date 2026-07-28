# Convert drive letter to disk root
function ConvertTo-DriveRoot {
    param (
        [string] $letter
    )
    return "${letter}:\"
}
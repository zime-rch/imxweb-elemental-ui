<#  

    RCH_Customize_elemental-ui.ps1

    Customize Elemental UI of One Identity Manager Api Server Applications

    Description
    
    Modify the Standard Colors and Styles of One Identity Manager Angular Portal

    The colors and styles from the default themes of One Identity Manager
    are hardcoded in customized node_modules. To modify the standard colors and styles
    without creating additional themes, this script helps to write the customization  
    to the tgz package of imx-modules.

    Important: The two elemental-ui files in the imx-modules can be adjusted by the manufacturer with each release. 
    Therefore, it is important to run this script again when upgrading a release from One Identity.

    Author: https://github.com/zime-rch

#>

# Location imxweb
$D_imx_dir = "D:\TFS\GIT\IdentityManager.Imx\imxweb"

# Location of subdirectory imx-modules
$D_imxmodules_dir = Join-Path $D_imx_dir "imx-modules"

# The temp dir, that will be deleted after the script has ran
$rch_temp_dir = "D:\TFS\GIT\IdentityManager.Imx\rch_temp"

# Location where 7zip is installed
$7zipexe = "D:\Entwickler\Utils\7-Zip\7z.exe"

Set-Location $D_imx_dir

# Extract the elemental-ui files of One Identity

$packagename = "elemental-ui_cadence-icon"

& $7zipexe x "$D_imxmodules_dir\$packagename.tgz" -o"$rch_temp_dir" -y
& $7zipexe x -ttar "$rch_temp_dir\$packagename.tar" -o"$rch_temp_dir\$packagename" -y

$packagename = "elemental-ui_core"

& $7zipexe x "$D_imxmodules_dir\$packagename.tgz" -o"$rch_temp_dir" -y
& $7zipexe x -ttar "$rch_temp_dir\$packagename.tar" -o"$rch_temp_dir\$packagename" -y

# PowerShell Function for Search and Replace

function SearchAndReplaceInFiles {
    param (
        [string]$FilePath,
        [string]$SearchString,
        [string]$ReplaceString
    )
    $verzeichnisPfad = $FilePath
    $dateien = Get-ChildItem -Path $verzeichnisPfad -Include ('*.scss', '*.mjs') -Recurse 
    foreach ($datei in $dateien) {
        try {
            $FileFullName = Join-Path $datei.DirectoryName $datei.Name
            $Content = Get-Content -Path $FileFullName -Raw
            If ( $Content -match $SearchString ) {
                $ModifiedContent = $Content -replace $SearchString, $ReplaceString
                Set-Content -Path $FileFullName -Value $ModifiedContent
                Write-Host "File verarbeitet $FileFullName, und angepasst..." -ForegroundColor Green
            } Else {
                Write-Host "File verarbeitet $FileFullName" -ForegroundColor Gray
            }
        } catch {
            Write-Host "Fehler: $_"
       }
       
    }
}

# Replace all color codes

# Main Colors

SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#e36a00" -ReplaceString "#9b8453"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#edbe8e" -ReplaceString "#9b8453"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#db2534" -ReplaceString "#b8312e"

# _eui_palette.scss

SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#f2fcff" -ReplaceString "#dfe4e6" #color-blue-10
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#cbe8f2" -ReplaceString "#c4cacc" #color-blue-20
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#8acbe3" -ReplaceString "#919799" #color-blue-40
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#0a96d1" -ReplaceString "#333333" #color-blue-60
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#016b91" -ReplaceString "#2f3233" #color-blue-80
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#00384d" -ReplaceString "#16191A" #color-blue-90

# _palette.scss

#$iris-blue-palette

SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#e1f5fb" -ReplaceString "#e7e7e7"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#b4e6f4" -ReplaceString "#c2c2c2"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#82d5ed" -ReplaceString "#999999"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#50c4e6" -ReplaceString "#707070"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#2bb7e0" -ReplaceString "#525252"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#05aadb" -ReplaceString "#333333"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#04a3d7" -ReplaceString "#2e2e2e"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#0499d2" -ReplaceString "#272727"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#0390cd" -ReplaceString "#202020"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#017fc4" -ReplaceString "#141414"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#ecf8ff" -ReplaceString "#ef6e6e"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#b9e3ff" -ReplaceString "#ea4040"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#86cfff" -ReplaceString "#f60000"
SearchAndReplaceInFiles -FilePath $rch_temp_dir -SearchString "#6dc5ff" -ReplaceString "#dd0000"


# After changing the files, they must be packaged again to the original file names

$packagename = "elemental-ui_cadence-icon"

Remove-Item -Path "$rch_temp_dir\$packagename.tar"
& $7zipexe a -ttar "$rch_temp_dir\$packagename.tar" "$rch_temp_dir\$packagename\*"
& $7zipexe a "$D_imxmodules_dir\$packagename.tgz" "$rch_temp_dir\$packagename.tar" -y

$packagename = "elemental-ui_core"

Remove-Item -Path "$rch_temp_dir\$packagename.tar"
& $7zipexe a -ttar "$rch_temp_dir\$packagename.tar" "$rch_temp_dir\$packagename\*"
& $7zipexe a "$D_imxmodules_dir\$packagename.tgz" "$rch_temp_dir\$packagename.tar" -y

# Remove Cache und temporary files of Elemental UI

Remove-Item -Path "D:\TFS\GIT\IdentityManager.Imx\imxweb\.angular" -Recurse -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path "D:\TFS\GIT\IdentityManager.Imx\imxweb\node_modules\@elemental-ui" -Recurse -Confirm:$false -ErrorAction SilentlyContinue
Remove-Item -Path $rch_temp_dir -Recurse -Confirm:$false -ErrorAction SilentlyContinue

# After changing the files in imx-modules they need to be installedwith the command "npm install", 
# so that they are used for the next build

npm install -s "@elemental-ui/cadence-icon"
npm install -s "@elemental-ui/core"


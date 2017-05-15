<#
.SYNOPSIS
    Publie la brève en cours et prépare la brève suivante
.EXAMPLE
    Publish-It
#>

[CmdletBinding()]
[OutputType([Void])]
Param (
    [switch] $NoNewVersion
)

begin {
    [string]$FileInfo = "./info.json"
    [psobject]$info = get-content $FileInfo | ConvertFrom-Json
    $git = Get-Command "git"
} 

process {
    [string]$commit_msg = "dernier commit de n" + $info.version.courante
    [string]$tag_name = "publish_n" + $info.version.courante
    &$git add --all
    &$git commit -m $commit_msg
    &$git tag $tag_name
    &$git checkout master

    [int]$DerniereVersion = $info.version.courante
    [int]$CouranteVersion = $info.version.courante + 1
    $info.publication = $(Get-Date -Format s)
    $info.version.derniere = $DerniereVersion
    $info.version.courante = $CouranteVersion
    ConvertTo-Json $info | Set-Content $FileInfo
    $commit_msg = "Creation de n" + $info.version.courante
    &$git add --all
    &$git commit -m $commit_msg

    [string]$NewBranch = "n" + $info.version.courante
    &$git checkout -b $NewBranch

}

end {
}

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$requiredFiles = @(
    'README.md',
    '.gitignore',
    'docs/project-story.md',
    'docs/publication-boundary.md',
    'assets/README.md',
    'assets/r1-overview.png',
    'assets/r1-gripper.png',
    'assets/r1-chassis.png',
    'assets/r1-arm.png',
    'assets/r1-lift-module.png'
)

foreach ($relativePath in $requiredFiles) {
    $path = Join-Path $root $relativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Missing required portfolio file: $relativePath"
    }
}

function Assert-Contains {
    param(
        [string]$Path,
        [string]$Pattern
    )

    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root $Path)
    if ($content -notmatch [regex]::Escape($Pattern)) {
        throw "Expected '$Pattern' in $Path"
    }
}

Assert-Contains 'README.md' '# 2026 Robocon'
Assert-Contains 'README.md' 'SolidWorks'
Assert-Contains 'README.md' 'assets/'
Assert-Contains 'README.md' 'assets/r1-overview.png'
Assert-Contains 'README.md' '<!-- GRIPPER_EVIDENCE -->'
Assert-Contains 'README.md' 'assets/r1-gripper.png'
Assert-Contains 'README.md' '<!-- CHASSIS_EVIDENCE -->'
Assert-Contains 'README.md' 'assets/r1-chassis.png'
Assert-Contains 'README.md' '<!-- ARM_EVIDENCE -->'
Assert-Contains 'README.md' 'assets/r1-arm.png'
Assert-Contains 'README.md' '<!-- LIFT_EVIDENCE -->'
Assert-Contains 'README.md' 'assets/r1-lift-module.png'
Assert-Contains 'README.md' '<!-- VIDEO_SECTION -->'
Assert-Contains 'README.md' 'https://www.bilibili.com/video/BV1jUNB6QEiM/'
Assert-Contains 'README.md' '<!-- KEY_ACTIONS -->'
Assert-Contains 'README.md' '<!-- CONFIRMED_ACTION_MAPPING -->'
Assert-Contains 'README.md' 'R2'
Assert-Contains 'README.md' 'KFS'
Assert-Contains 'README.md' '50-60 cm'
Assert-Contains 'README.md' '<!-- MECHANISM_MAPPING -->'
Assert-Contains 'README.md' 'mechanism mapping'
Assert-Contains 'docs/project-story.md' 'SolidWorks'
Assert-Contains 'docs/project-story.md' '3D'
Assert-Contains 'docs/project-story.md' 'assets/r1-overview.png'
Assert-Contains 'docs/project-story.md' '<!-- GRIPPER_EVIDENCE -->'
Assert-Contains 'docs/project-story.md' '../assets/r1-gripper.png'
Assert-Contains 'docs/project-story.md' '<!-- CHASSIS_EVIDENCE -->'
Assert-Contains 'docs/project-story.md' '../assets/r1-chassis.png'
Assert-Contains 'docs/project-story.md' '<!-- ARM_EVIDENCE -->'
Assert-Contains 'docs/project-story.md' '../assets/r1-arm.png'
Assert-Contains 'docs/project-story.md' '<!-- LIFT_EVIDENCE -->'
Assert-Contains 'docs/project-story.md' '../assets/r1-lift-module.png'
Assert-Contains 'docs/project-story.md' '<!-- KEY_ACTIONS -->'
Assert-Contains 'docs/project-story.md' '<!-- CONFIRMED_ACTION_MAPPING -->'
Assert-Contains 'docs/project-story.md' 'KFS'
Assert-Contains 'docs/project-story.md' '<!-- MECHANISM_MAPPING -->'
Assert-Contains 'docs/project-story.md' '<!-- VIDEO_SECTION -->'
Assert-Contains 'docs/project-story.md' 'https://www.bilibili.com/video/BV1jUNB6QEiM/'
Assert-Contains 'docs/publication-boundary.md' 'SolidWorks'

$ignore = Get-Content -Raw -LiteralPath (Join-Path $root '.gitignore')
foreach ($pattern in @('*.SLDASM', '*.SLDPRT', '*.SLDDRW', '*.STEP', '*.STP', '*.docx', '*.pdf', '*.zip')) {
    if ($ignore -notmatch [regex]::Escape($pattern)) {
        throw "Missing sensitive file pattern in .gitignore: $pattern"
    }
}

$publicText = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root 'README.md')
if ($publicText -match '13336068650|1479336168@qq\.com') {
    throw 'Private contact data must not be included in the public README'
}

Write-Output 'Portfolio structure checks passed.'

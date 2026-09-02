$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$requiredFiles = @(
    'README.md',
    '.gitignore',
    'docs/project-story.md',
    'docs/smart-garbage-sorting.md',
    'docs/publication-boundary.md',
    'assets/README.md',
    'assets/r1-overview.png',
    'assets/r1-gripper.png',
    'assets/r1-chassis.png',
    'assets/r1-arm.png',
    'assets/r1-lift-module.png',
    'assets/smart-garbage-sorter-overview.jpeg',
    'assets/smart-garbage-sorter-cad.png',
    'assets/smart-garbage-sorter-gripper.jpeg',
    'assets/smart-garbage-sorter-internal.jpeg'
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
Assert-Contains 'README.md' 'docs/smart-garbage-sorting.md'
Assert-Contains 'README.md' '第十二届浙江省大学生工程实践与创新能力大赛「智能+」垃圾分类'
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

Assert-Contains 'docs/smart-garbage-sorting.md' '# 第十二届浙江省大学生工程实践与创新能力大赛「智能+」垃圾分类'
Assert-Contains 'docs/smart-garbage-sorting.md' 'Core-XY'
Assert-Contains 'docs/smart-garbage-sorting.md' '柔性夹爪'
Assert-Contains 'docs/smart-garbage-sorting.md' 'SolidWorks'
Assert-Contains 'docs/smart-garbage-sorting.md' '省级银奖'
Assert-Contains 'docs/smart-garbage-sorting.md' '../assets/smart-garbage-sorter-overview.jpeg'
Assert-Contains 'docs/smart-garbage-sorting.md' '../assets/smart-garbage-sorter-cad.png'
Assert-Contains 'docs/smart-garbage-sorting.md' '../assets/smart-garbage-sorter-gripper.jpeg'

$smartPlusPage = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $root 'docs/smart-garbage-sorting.md')
if ($smartPlusPage -match '排球机器人|发球机构|武林探秘') {
    throw 'The 智能+ page must not contain unrelated volleyball or 武林探秘 content'
}

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

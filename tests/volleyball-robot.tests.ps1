$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$pagePath = Join-Path $root 'docs/volleyball-robot.md'
$readmePath = Join-Path $root 'README.md'
$assetPath = Join-Path $root 'assets/volleyball-robot-overview.jpeg'

if (-not (Test-Path -LiteralPath $pagePath -PathType Leaf)) {
    throw 'Missing volleyball project page: docs/volleyball-robot.md'
}
if (-not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
    throw 'Missing volleyball project image: assets/volleyball-robot-overview.jpeg'
}

$page = Get-Content -Raw -Encoding UTF8 -LiteralPath $pagePath
$readme = Get-Content -Raw -Encoding UTF8 -LiteralPath $readmePath
$requiredPage = @(
    '# 2026 ROBOCON 排球机器人挑战赛',
    '摆臂击打式',
    '双 GO 关节电机串联',
    '肩关节—肘关节',
    'SolidWorks',
    '发球机构',
    '排球比赛一等奖'
)

foreach ($text in $requiredPage) {
    if ($page -notmatch [regex]::Escape($text)) {
        throw "Missing volleyball project content: $text"
    }
}

foreach ($text in @(
    '### 2026 ROBOCON 排球机器人挑战赛',
    'docs/volleyball-robot.md',
    '排球比赛一等奖'
)) {
    if ($readme -notmatch [regex]::Escape($text)) {
        throw "Missing README volleyball project content: $text"
    }
}

$smartPlus = [regex]::Match($readme, '(?s)### 第十二届浙江省大学生工程实践与创新能力大赛「智能\+」垃圾分类.*?(?=### |## |$)').Value
if (-not $smartPlus) {
    throw 'Could not isolate the 智能+ project section'
}
if ($smartPlus -match '发球机构|排球机器人') {
    throw 'The 智能+ section must not contain the volleyball robot serving mechanism'
}

foreach ($text in @(
    '迅雷连发',
    '中国机器人及人工智能大赛',
    '15 m/s',
    '3-5 ms',
    '13336068650',
    '1479336168@qq.com',
    'C:\\Users\\14793',
    'D:\\国家级学生科创课题',
    '待补充',
    'TBD',
    'TODO'
)) {
    if ($page -match [regex]::Escape($text)) {
        throw "Forbidden volleyball page content found: $text"
    }
}

Write-Output 'Volleyball project checks passed.'


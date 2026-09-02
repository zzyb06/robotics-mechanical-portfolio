$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$path = Join-Path $root 'docs/github-profile-readme.md'

if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
    throw 'Missing profile README draft: docs/github-profile-readme.md'
}

$content = Get-Content -Raw -Encoding UTF8 -LiteralPath $path
$required = @(
    '# zzyb06',
    '宁波工程学院',
    '机器人工程',
    'SolidWorks',
    'BOM',
    '末端执行器',
    'ROBOCON',
    '国家级大学生创新创业项目',
    'https://github.com/zzyb06/robotics-mechanical-portfolio',
    '一等奖',
    '二等奖',
    '银奖'
)

foreach ($text in $required) {
    if ($content -notmatch [regex]::Escape($text)) {
        throw "Missing required profile content: $text"
    }
}

$forbidden = @(
    '13336068650',
    '1479336168@qq.com',
    'C:\\Users\\14793',
    'D:\\国家级学生科创课题',
    '\.SLDASM',
    '\.SLDPRT',
    '\.SLDDRW',
    'TBD',
    'TODO',
    '待补充'
)

foreach ($text in $forbidden) {
    if ($content -match $text) {
        throw "Forbidden profile content found: $text"
    }
}

Write-Output 'GitHub profile README checks passed.'


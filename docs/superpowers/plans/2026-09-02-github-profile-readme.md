# GitHub 个人主页 README Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 创建并发布 `zzyb06` GitHub 个人主页 README，让招聘者快速了解用户的机器人机械方向、岗位技能、代表项目和竞赛成果。

**Architecture:** 现有作品集仓库继续作为完整项目资料入口，`zzyb06` 特殊仓库只承载个人主页 README。主页内容以一份位于现有作品集仓库 `docs/` 下的公开草稿为源，发布时复制到独立 profile 仓库，避免混入原始 CAD 或内部材料。

**Tech Stack:** Markdown、PowerShell 检查脚本、Git、GitHub CLI

---

### Task 1: Add Profile Content Contract

**Files:**
- Create: `tests/github-profile-readme.tests.ps1`
- Test: `docs/github-profile-readme.md`

- [ ] **Step 1: Write the failing content check**

Create `tests/github-profile-readme.tests.ps1` with the following exact content:

```powershell
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
```

- [ ] **Step 2: Run the check to verify it fails before the draft exists**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\github-profile-readme.tests.ps1
```

Expected: FAIL with `Missing profile README draft: docs/github-profile-readme.md`.

- [ ] **Step 3: Commit the content contract**

Run:

```powershell
git add tests/github-profile-readme.tests.ps1
git commit -m "test: define GitHub profile README content contract"
```

Expected: one new commit containing the profile README check.

### Task 2: Write the Profile README Draft

**Files:**
- Create: `docs/github-profile-readme.md`
- Test: `tests/github-profile-readme.tests.ps1`

- [ ] **Step 1: Create the draft with the complete public content**

Create `docs/github-profile-readme.md` with the following exact content:

```markdown
# zzyb06

> 宁波工程学院机器人工程本科生｜机器人机械结构设计与制造｜寻找实习机会

我是一名机器人工程专业大三学生，专业前 30%。主要负责竞赛机器人和科创项目中的机械系统，关注从任务分析、SolidWorks 建模、工程图与 BOM，到加工制造、整机装配和现场调试的完整流程。

## 核心技能

- **3D CAD 与工程图：**SolidWorks 三维建模、装配体干涉检查、二维工程图、公差规范、尺寸配合、标准紧固件选型和 BOM 编制
- **制造与原型：**机加工（车、铣、磨）、激光切割、钣金折弯和 3D 打印；使用铝合金、碳纤维、工程塑料、铝型材和铝方管完成结构装配
- **机电集成：**电机、视觉/压力传感器、线缆和执行器的机械安装与结构集成
- **控制与测试：**具备 STM32、ROS 和 C 语言基础，能够进行整机装配、改装、现场调试、故障排查和结构迭代

## 精选项目

### 国家级大学生创新创业项目：工业场景多模态重载搬运机器人

`2026.03 - 至今｜项目负责人`

- 面向工业场景开展轮式重载搬运机器人研发，以 2026 Robocon「武林探秘」R1 机械系统为实践基础开展方案验证
- 独立完成全向轮底盘、塔吊式伸缩重载机构，以及气动夹爪、真空吸盘等多个末端执行器的机械结构设计
- 负责公差规范、三维模型、二维工程图和 BOM；对接供应商，跟进机加工和 3D 打印零部件的生产、检验与质量改进
- 完成整机机械装配，将电机、传感器和线缆集成到结构中，协同完成整机联调

### 第 25 届全国大学生机器人大赛 ROBOCON：R1 机器人

`2026.03 - 2026.08｜R1 机器人负责人`

- 独立负责 R1 机器人整机结构设计与制造，覆盖气动爪、纵梁式麦克纳姆轮底盘、塔吊式机械臂、真空吸盘和剪叉式抬升机构
- 在样机装配和比赛调试过程中进行故障排查、结构迭代、材料优化和配合公差调整，提升动作精度与运行可靠性

## 竞赛成果

- 2026.07｜ROBOCON 2026 主赛「武林探秘」｜崇武探幽技能赛：一等奖；R1 机器人负责人
- 2026.07｜ROBOCON 2026 主赛「武林探秘」｜九宫藏宝技能赛：一等奖
- 2026.07｜ROBOCON 2026 主赛「武林探秘」｜竞技赛：二等奖
- 2026.07｜ROBOCON「排球比赛」：一等奖
- 2025.11｜浙江省大学生工程实践与创新能力大赛「智能+」垃圾分类：省级银奖；队长
- 2025.08｜第十三届 TI 杯全国大学生电子设计竞赛浙江赛区：二等奖；负责小车制作与寻迹调试

## 作品集

[查看完整机器人机械作品集](https://github.com/zzyb06/robotics-mechanical-portfolio)

## 当前关注

机器人机械结构、末端执行器、加工落地、供应商生产检验、整机装配与测试迭代。
```

- [ ] **Step 2: Run both content checks**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\github-profile-readme.tests.ps1
powershell -ExecutionPolicy Bypass -File .\tests\portfolio-structure.tests.ps1
git diff --check
```

Expected: both PowerShell checks print a `passed` message, and `git diff --check` exits with code 0.

- [ ] **Step 3: Commit the draft**

Run:

```powershell
git add docs/github-profile-readme.md
git commit -m "docs: add GitHub profile README draft"
```

Expected: one new commit containing the public profile README draft.

### Task 3: Create and Publish the Profile Repository

**Files:**
- Create: `tmp/github-profile/README.md` (ignored local publishing source)
- Create remotely: `zzyb06/README.md`

- [ ] **Step 1: Create the special GitHub profile repository**

Run:

```powershell
gh repo create zzyb06 --public --description "Robotics engineering student profile and mechanical design portfolio"
```

Expected: GitHub creates `https://github.com/zzyb06/zzyb06` as a public repository.

- [ ] **Step 2: Initialize a clean local publishing directory**

Run:

```powershell
New-Item -ItemType Directory -Force tmp\github-profile | Out-Null
git -C tmp\github-profile init
git -C tmp\github-profile branch -M main
Copy-Item docs\github-profile-readme.md tmp\github-profile\README.md -Force
git -C tmp\github-profile add README.md
git -C tmp\github-profile commit -m "docs: add GitHub profile README"
git -C tmp\github-profile remote add origin https://github.com/zzyb06/zzyb06.git
```

Expected: the local profile repository has one clean `main` commit and the remote is `zzyb06/zzyb06`.

- [ ] **Step 3: Push the profile README**

Run:

```powershell
git -C tmp\github-profile push -u origin main
```

Expected: GitHub accepts `main` and the profile repository contains `README.md`.

### Task 4: Verify the Public Profile

**Files:**
- Verify: `tmp/github-profile/README.md`
- Verify remotely: `https://github.com/zzyb06`

- [ ] **Step 1: Verify repository metadata and remote commit**

Run:

```powershell
gh repo view zzyb06 --json nameWithOwner,visibility,url,defaultBranchRef
git -C tmp\github-profile ls-remote --heads origin main
git -C tmp\github-profile status --short --branch
```

Expected: repository name is `zzyb06/zzyb06`, visibility is `PUBLIC`, default branch is `main`, the remote `main` commit matches the local `HEAD`, and the local profile repository is clean.

- [ ] **Step 2: Re-run content checks and inspect the account URL**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\github-profile-readme.tests.ps1
gh browse https://github.com/zzyb06
```

Expected: the content check passes and the account page displays the new profile README with the portfolio link.

- [ ] **Step 3: Publish the reviewed profile draft reference in the portfolio repository**

Run:

```powershell
git add docs/github-profile-readme.md docs/superpowers/specs/2026-09-02-github-profile-readme-design.md docs/superpowers/plans/2026-09-02-github-profile-readme.md tests/github-profile-readme.tests.ps1
git commit -m "docs: add GitHub profile publishing guide"
git push origin master
```

Expected: the portfolio repository contains the reviewed profile draft, design, plan and content check; `master` is synchronized with `origin/master`.

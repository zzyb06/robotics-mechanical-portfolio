# 2026 ROBOCON 排球机器人项目页 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将 2026 ROBOCON 排球机器人挑战赛及用户负责的摆臂击打式发球机构加入现有 GitHub 机械作品集，并与“智能+”项目完全分开。

**Architecture:** 在 `docs/volleyball-robot.md` 中维护完整项目故事，在根目录 `README.md` 中维护一段可快速扫描的项目卡片。附件说明书中的机器人实物图只作为经过筛选的展示素材，附件原文件、文档比赛背景、拦截端内容和未经核验的性能数据不进入仓库。

**Tech Stack:** Markdown、PNG/JPEG 图片、PowerShell 内容检查、Git

---

### Task 1: Add the Volleyball Project Content Contract

**Files:**
- Create: `tests/volleyball-robot.tests.ps1`
- Test: `README.md`, `docs/volleyball-robot.md`, `assets/volleyball-robot-overview.jpeg`

- [ ] **Step 1: Write the failing content check**

Create `tests/volleyball-robot.tests.ps1` and save it as UTF-8 with BOM so Windows PowerShell 5.1 can parse the Chinese strings:

```powershell
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

$smartPlus = [regex]::Match($readme, '(?s)### 浙江省大学生工程实践与创新能力大赛「智能\+」.*?(?=### |## |$)').Value
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
```

- [ ] **Step 2: Run the check to verify it fails before the page exists**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\volleyball-robot.tests.ps1
```

Expected: FAIL with `Missing volleyball project page: docs/volleyball-robot.md`.

- [ ] **Step 3: Commit the content contract**

Run:

```powershell
git add tests/volleyball-robot.tests.ps1
git commit -m "test: define Robocon volleyball project contract"
```

Expected: one new commit containing the publish-boundary and content checks.

### Task 2: Add the Project Page, README Card, and Screened Image

**Files:**
- Create: `docs/volleyball-robot.md`
- Modify: `README.md`
- Modify: `assets/README.md`
- Create: `assets/volleyball-robot-overview.jpeg`

- [ ] **Step 1: Create the independent project page**

Create `docs/volleyball-robot.md` with this exact content:

```markdown
# 2026 ROBOCON 排球机器人挑战赛

> 摆臂击打式发球机构设计与优化

## 项目概况

**项目时间：**2026.03 - 2026.08

**负责模块：**排球机器人发球机构

**比赛成果：**2026 ROBOCON 排球比赛一等奖

本项目面向 2026 ROBOCON 排球机器人挑战赛，重点展示排球机器人的发球机构设计。我的工作集中在发球机构的机械方案、结构建模、样机制造、装配调试和结构优化。

## 个人职责

- 负责发球机构总体机械方案和结构布局
- 使用 SolidWorks 完成发球机构三维建模与装配关系检查
- 负责发球机构相关零件的加工落地、样机装配和现场调试
- 根据发球动作和样机测试现象进行结构调整与迭代
- 配合团队完成排球机器人整机联调

## 发球机构总体方案

发球机构采用摆臂击打式方案，通过摆臂末端与排球接触，将电机输出的运动转化为排球的击打发球动作。相较于固定轨迹的简单推出方式，摆臂结构能够提供连续的击打过程和姿态调整空间，更适合在机器人平台上完成发球动作。

## 双关节串联摆臂结构

发球臂采用双 GO 关节电机串联结构，形成类似“肩关节—肘关节”的双段摆臂。两个关节共同完成发球臂的姿态变化和击球动作：前段关节负责建立摆臂的整体运动趋势，后段关节配合完成末端击球姿态。

这种串联结构的设计重点包括：

- 为摆臂提供足够的运动空间和击球路径
- 保证双关节之间的连接刚度和装配可靠性
- 为电机、线缆和支撑结构预留安装及维护空间
- 通过结构布局减少运动过程中的干涉

## 摆臂击打式发球动作链

```text
排球进入发球位置
    -> 双关节摆臂调整初始姿态
    -> 肩关节与肘关节协同摆动
    -> 末端击球部件接触排球
    -> 排球完成击打发球
```

调试时重点观察摆臂运动是否顺畅、击球位置是否稳定、发球方向是否满足比赛要求，以及连续动作过程中连接件和支撑结构是否可靠。

## 建模、制造与装配

我使用 SolidWorks 建立发球机构的零件和装配模型，围绕电机安装、关节连接、摆臂支撑和末端击球空间检查结构关系。样机落地过程中，根据零件形状、受力和修改频率选择合适的加工方式，并完成发球机构的装配和现场调整。

机械设计与制造流程如下：

```text
比赛动作分析
    -> 发球机构方案设计
    -> SolidWorks 三维建模
    -> 零件拆分与加工规划
    -> 样机加工与装配
    -> 发球测试
    -> 结构迭代与整机联调
```

## 测试与结构迭代

发球机构的优化围绕发球动作的稳定性、方向一致性、击球位置和连续运行可靠性展开。测试中根据实际现象检查摆臂轨迹、关节连接、末端击球姿态和结构干涉，并针对问题修改零件或装配关系。

这部分重点体现机械设计从模型到实物的闭环：先用 SolidWorks 验证结构关系，再通过样机测试发现问题，最后回到零件和装配体中完成迭代。

## 项目展示

### 排球机器人实物总装

![2026 ROBOCON 排球机器人实物总装图](../assets/volleyball-robot-overview.jpeg)

该图展示排球机器人整机结构和发球机构所在的安装区域。后续补充发球机构近景图时，可进一步标出双段摆臂、电机、支撑结构和末端击球部件。

## 项目成果

- 完成 2026 ROBOCON 排球机器人的发球机构设计与样机落地
- 完成双 GO 关节电机串联摆臂的装配、调试和结构优化
- 参与排球机器人整机联调
- 获得 2026 ROBOCON 排球比赛一等奖

## 项目边界

本页面只展示 2026 ROBOCON 排球机器人及我负责的发球机构，不公开原始 SolidWorks 文件、工程图、完整 BOM、内部比赛资料和未核验的性能数据。
```

- [ ] **Step 2: Add the project card to README and separate the 智能+ description**

Insert the following block after the existing 2026 ROBOCON R1 project block and before the Zhejiang competition block in `README.md`:

```markdown
### 2026 ROBOCON 排球机器人挑战赛

**2026.03 - 2026.08｜发球机构负责人**

负责排球机器人摆臂击打式发球机构的机械方案、SolidWorks 建模、样机制造、装配调试和结构优化。机构采用双 GO 关节电机串联的“肩关节—肘关节”式双段摆臂，完成排球击打发球动作，最终获得 2026 ROBOCON 排球比赛一等奖。

详细说明见：[2026 ROBOCON 排球机器人项目页](docs/volleyball-robot.md)。
```

Replace the current `智能+` contribution paragraph:

```markdown
统筹整机方案设计，重点负责排球机器人发球机构这一末端执行器的设计与优化。通过多轮原型测试提升抛射精准度，最终获得省级银奖。
```

with:

```markdown
统筹整机方案设计，作为队长推进项目实施，最终获得省级银奖。
```

- [ ] **Step 3: Add the screened robot image to the public assets**

Copy only the actual robot overview image extracted from the attached document; do not copy the DOCX itself:

```powershell
Copy-Item tmp\volleyball-doc-media\image2.jpeg assets\volleyball-robot-overview.jpeg -Force
```

Append this entry to `assets/README.md`:

```markdown
### `volleyball-robot-overview.jpeg`

- 用途：2026 ROBOCON 排球机器人项目页的实物总装展示
- 来源：用户提供的排球机器人项目说明书中的机器人实物图
- 发布前检查：不包含原始 CAD、个人联系方式或本地文件路径
```

- [ ] **Step 4: Run all content and structure checks**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\volleyball-robot.tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\portfolio-structure.tests.ps1
git diff --check
```

Expected: both PowerShell checks print a `passed` message, and `git diff --check` exits with code 0.

- [ ] **Step 5: Commit the project page and assets**

Run:

```powershell
git add README.md docs/volleyball-robot.md assets/README.md assets/volleyball-robot-overview.jpeg
git diff --cached --check
git commit -m "docs: add Robocon volleyball robot project"
```

Expected: one new commit containing the independent volleyball robot page, README link, screened image and asset documentation.

### Task 3: Publish and Verify the Updated Portfolio

**Files:**
- Verify: `README.md`
- Verify: `docs/volleyball-robot.md`
- Verify remotely: `https://github.com/zzyb06/robotics-mechanical-portfolio`

- [ ] **Step 1: Push the new project page**

Run:

```powershell
git push origin master
```

Expected: `master` is updated on the public portfolio repository.

- [ ] **Step 2: Verify local and remote state**

Run:

```powershell
$local = (git rev-parse HEAD).Trim()
$remote = ((git ls-remote --heads origin master).Trim() -split '\s+')[0]
if ($local -ne $remote) { throw "Portfolio remote mismatch: local=$local remote=$remote" }
gh api repos/zzyb06/robotics-mechanical-portfolio/contents/docs/volleyball-robot.md --jq '{name: .name, path: .path, sha: .sha}'
git status --short --branch
```

Expected: the remote SHA matches local `HEAD`, GitHub returns `docs/volleyball-robot.md`, and the worktree is clean.

- [ ] **Step 3: Re-run the final content checks**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\volleyball-robot.tests.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\portfolio-structure.tests.ps1
```

Expected: both checks print a `passed` message with exit code 0.

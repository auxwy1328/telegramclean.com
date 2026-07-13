$ErrorActionPreference = 'Stop'
$basePath = 'D:\telegramclean'

# 获取所有需要处理的HTML文件（排除backup）
$htmlFiles = Get-ChildItem "$basePath\*.html" | Where-Object { $_.Name -notmatch 'backup' }

# 站点信息映射
$siteInfo = @{
    'index.html'         = @{ title = 'Telegram自动删除消息设置｜群组定时清理聊天记录教程'; desc = '讲解Telegram群组、私聊自动删消息功能，教你设置定时清理聊天记录，规范群聊管理。25篇实用教程，覆盖自动删除、私聊清理、群组管理、定时规则、记录维护5大分类。'; type = 'website'; section = '' }
    'category1.html'     = @{ title = '自动删消息设置教程 - TelegramClean'; desc = 'Telegram自动删除消息设置教程合集，包含开启、关闭、秘密聊天自毁计时器、常见问题解答等4篇详细教程。'; type = 'collection'; section = '自动删消息设置' }
    'category2.html'     = @{ title = '私聊记录清理教程 - TelegramClean'; desc = 'Telegram私聊记录清理教程合集，包含手动清理、批量删除、恢复记录、存储空间优化等4篇详细教程。'; type = 'collection'; section = '私聊记录清理' }
    'category3.html'     = @{ title = '群组消息管理教程 - TelegramClean'; desc = 'Telegram群组消息管理教程合集，包含自动清理、管理员权限、消息置顶、防垃圾消息等4篇详细教程。'; type = 'collection'; section = '群组消息管理' }
    'category4.html'     = @{ title = '定时清理规则教程 - TelegramClean'; desc = 'Telegram定时清理规则教程合集，包含时长选择、Bot定时清理、第三方工具对比、脚本编写等4篇详细教程。'; type = 'collection'; section = '定时清理规则' }
    'category5.html'     = @{ title = '聊天记录维护教程 - TelegramClean'; desc = 'Telegram聊天记录维护教程合集，包含备份清理、导出教程、云端存储、多设备同步等4篇详细教程。'; type = 'collection'; section = '聊天记录维护' }
    'disclaimer.html'    = @{ title = '免责声明 - TelegramClean'; desc = 'TelegramClean免责声明，本站仅提供Telegram客户端使用教程与功能科普。'; type = 'page'; section = '' }
    'privacy.html'       = @{ title = '隐私政策 - TelegramClean'; desc = 'TelegramClean隐私政策，说明本站如何处理用户信息。'; type = 'page'; section = '' }
    'copyright.html'      = @{ title = '版权声明 - TelegramClean'; desc = 'TelegramClean版权声明。'; type = 'page'; section = '' }
    'contact.html'        = @{ title = '联系方式 - TelegramClean'; desc = 'TelegramClean联系方式。'; type = 'page'; section = '' }
}

# article文件的模式匹配
$articlePattern = @{
    'article1.html'  = @{ title = 'Telegram开启私聊自动删除消息设置步骤（2026最新）'; desc = '详细讲解Telegram私聊自动删除消息功能的开启步骤，保护隐私安全，包含Android、iOS、桌面版详细教程。'; section = '自动删消息设置' }
    'article2.html'  = @{ title = '手动一键清理Telegram单条/全部聊天记录方法'; desc = '详细讲解Telegram手动清理单条消息和清空全部聊天记录的方法，适用于Android、iOS和桌面版。'; section = '私聊记录清理' }
    'article3.html'  = @{ title = 'Telegram群组开启自动清理历史消息教程（管理员必看）'; desc = 'Telegram群组管理员必看教程：如何开启群组自动清理历史消息，包括权限要求、操作步骤、注意事项。'; section = '群组消息管理' }
    'article4.html'  = @{ title = 'TG不同时长自动删消息规则适用场景说明（1天/1周/1月）'; desc = '详细分析Telegram自动删除消息三种时长（1天、1周、1月）的适用场景，帮你选择最合适的设置。'; section = '定时清理规则' }
    'article5.html'  = @{ title = 'Telegram聊天记录备份与定期清理合理方案（数据安全）'; desc = 'Telegram聊天记录备份与定期清理的完整方案，保护数据安全，涵盖导出、清理、云存储策略。'; section = '聊天记录维护' }
    'article6.html'  = @{ title = '如何关闭Telegram自动删除消息功能（取消自毁计时器）'; desc = '详细讲解如何关闭Telegram私聊和群组的自动删除消息功能，适用于Android、iOS和桌面版。'; section = '自动删消息设置' }
    'article7.html'  = @{ title = 'Telegram秘密聊天自毁计时器设置教程（端到端加密·2026最新）'; desc = '详细讲解Telegram秘密聊天的自毁计时器设置方法，包括端到端加密、秒级自毁、安全特性等。'; section = '自动删消息设置' }
    'article8.html'  = @{ title = 'Telegram自动删除消息常见问题大全（2026最新解答·最全FAQ）'; desc = '汇总Telegram自动删除消息功能的28个常见问题与解答，涵盖开启/关闭、时长选择、消息恢复等。'; section = '自动删消息设置' }
    'article9.html'  = @{ title = '批量删除Telegram私聊记录方法（多选/按日期/按联系人·2026最新）'; desc = '详细讲解Telegram批量删除私聊记录的方法，包括多选消息、按日期范围、按联系人批量清理。'; section = '私聊记录清理' }
    'article10.html' = @{ title = '如何恢复删除的Telegram聊天记录（2026最新方法汇总）'; desc = '汇总5种恢复已删除Telegram聊天记录的方法，包括已保存消息、其他设备、本地缓存等途径。'; section = '私聊记录清理' }
    'article11.html' = @{ title = 'Telegram私聊存储空间优化指南（释放手机内存·2026最新）'; desc = 'Telegram存储空间优化完整指南，教你清理缓存、管理媒体文件、设置自动下载规则来释放手机内存。'; section = '私聊记录清理' }
    'article12.html' = @{ title = 'Telegram群组管理员权限设置详解（2026最新完整指南）'; desc = '详细讲解Telegram群组管理员权限体系，包括12种权限逐一说明、自定义权限设置、最佳分配方案。'; section = '群组消息管理' }
    'article13.html' = @{ title = 'Telegram群组消息置顶技巧（管理员必会·2026最新）'; desc = 'Telegram群组消息置顶技巧完整教程，包括Android/iOS/桌面版操作步骤、置顶管理、与公告的区别。'; section = '群组消息管理' }
    'article14.html' = @{ title = 'Telegram群组防垃圾消息设置指南（管理员手册·2026最新）'; desc = 'Telegram群组防垃圾消息完整指南，包括内置反垃圾功能、审核模式、权限限制、Bot辅助等方案。'; section = '群组消息管理' }
    'article15.html' = @{ title = '使用Telegram Bot定时清理消息教程（自动化方案·2026最新）'; desc = '详细讲解如何使用Telegram Bot实现定时清理消息，包括推荐Bot、配置方法、安全注意事项。'; section = '定时清理规则' }
    'article16.html' = @{ title = '第三方Telegram清理工具对比（2026最新评测）'; desc = '2026年最新第三方Telegram清理工具对比评测，从功能、价格、安全性、易用性四个维度全面对比。'; section = '定时清理规则' }
    'article17.html' = @{ title = 'Telegram自动清理脚本编写教程（Python/Node.js·2026最新）'; desc = '详细讲解如何编写Telegram自动清理脚本，包含Python和Node.js两种版本的完整代码。'; section = '定时清理规则' }
    'article18.html' = @{ title = 'Telegram聊天记录导出完整教程（HTML/JSON格式·2026最新）'; desc = '详细讲解Telegram聊天记录导出方法，支持HTML和JSON格式，适用于Windows和Mac桌面版。'; section = '聊天记录维护' }
    'article19.html' = @{ title = 'Telegram云端存储详解（无限量存储机制·2026最新）'; desc = '深入解析Telegram云端存储的工作原理、免费无限量存储、云端vs本地、Premium特权等。'; section = '聊天记录维护' }
    'article20.html' = @{ title = 'Telegram多设备聊天同步技巧（手机/平板/电脑·2026最新）'; desc = 'Telegram多设备聊天同步完整教程，包括设备数量限制、登录方法、同步延迟处理、设备丢失安全处理。'; section = '聊天记录维护' }
}

$successCount = 0
$failCount = 0

foreach ($file in $htmlFiles) {
    $name = $file.Name
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # 跳过已处理的文件
    if ($content -match 'og:title') {
        Write-Output "SKIP: $name (already has OG tags)"
        continue
    }
    
    # 获取页面信息
    $info = $null
    if ($siteInfo.ContainsKey($name)) {
        $info = $siteInfo[$name]
    } elseif ($articlePattern.ContainsKey($name)) {
        $info = $articlePattern[$name]
        $info['type'] = 'article'
    } else {
        # 未知文件，尝试从HTML中提取title
        if ($content -match '<title>([^<]+)</title>') {
            $info = @{ title = $Matches[1]; desc = ''; type = 'page'; section = '' }
        } else {
            Write-Output "SKIP: $name (no info found)"
            continue
        }
    }
    
    $pageTitle = ($info.title -replace '&','&amp;' -replace '"','&quot;' -replace '<','&lt;' -replace '>','&gt;')
    $pageDesc = ($info.desc -replace '&','&amp;' -replace '"','&quot;' -replace '<','&lt;' -replace '>','&gt;')
    $section = ($info.section -replace '&','&amp;' -replace '"','&quot;' -replace '<','&lt;' -replace '>','&gt;')
    $pageType = $info.type
    $pageUrl = "https://telegramclean.com/$name"
    $siteName = 'TelegramClean'
    
    # 构建Schema.org + OG标签
    $schemaOg = @"
    <!-- Open Graph / Schema.org SEO -->
    <meta property="og:site_name" content="$siteName">
    <meta property="og:type" content="$pageType">
    <meta property="og:title" content="$pageTitle">
    <meta property="og:description" content="$pageDesc">
    <meta property="og:url" content="$pageUrl">
    <meta property="og:locale" content="zh_CN">
    <link rel="canonical" href="$pageUrl">
"@
    
    # 文章类型添加Schema.org Article结构化数据
    if ($pageType -eq 'article') {
        $schemaData = @"
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"Article","headline":"$($info.title)","description":"$($info.desc)","url":"$pageUrl","publisher":{"@type":"Organization","name":"$siteName","url":"https://telegramclean.com"},"datePublished":"2026-06-22","dateModified":"2026-06-22","author":{"@type":"Organization","name":"$siteName"},"articleSection":"$section","inLanguage":"zh-CN"}</script>
"@
        $schemaOg = $schemaOg + "`n" + $schemaData
    } elseif ($pageType -eq 'website') {
        $schemaData = @"
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"WebSite","name":"$siteName","url":"https://telegramclean.com","description":"Telegram使用教程与功能科普，25篇实用教程覆盖自动删除、私聊清理、群组管理、定时规则、记录维护5大分类。","inLanguage":"zh-CN"}</script>
"@
        $schemaOg = $schemaOg + "`n" + $schemaData
    }
    
    # 插入到</head>之前
    $content = $content -replace '(?s)(\s*</head>)', "`n    $schemaOg`n`$1"
    
    try {
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        Write-Output "OK: $name"
        $successCount++
    } catch {
        Write-Output "FAIL: $name - $_"
        $failCount++
    }
}

Write-Output "`nDone! Success: $successCount, Failed: $failCount"

// TelegramClean 主脚本
// 创建日期：2026-06-22

// 返回顶部功能
function scrollToTop() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
}

// 移动端导航菜单切换（如果需要在移动端添加汉堡菜单）
document.addEventListener('DOMContentLoaded', function() {
    // 平滑滚动（针对锚点链接）
    const links = document.querySelectorAll('a[href^="#"]');
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // 吸底下载条显示/隐藏逻辑（可选）
    const stickyDownload = document.querySelector('.sticky-download');
    if (stickyDownload) {
        // 可以在这里添加显示/隐藏逻辑
        // 比如：滚动超过100px后显示
        window.addEventListener('scroll', function() {
            if (window.scrollY > 100) {
                stickyDownload.style.display = 'flex';
            }
        });
    }
});

// 文章页目录高亮（可选）
function highlightTOC() {
    const tocLinks = document.querySelectorAll('.table-of-contents a');
    const sections = document.querySelectorAll('.article-content h2, .article-content h3');
    
    window.addEventListener('scroll', function() {
        let current = '';
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            if (window.scrollY >= sectionTop - 100) {
                current = section.getAttribute('id');
            }
        });
        
        tocLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === '#' + current) {
                link.classList.add('active');
            }
        });
    });
}

// ===== 动态文章列表加载（方案B：半自动化） =====
// 从 data/articles.json 读取文章数据，自动渲染首页教程列表
// 新增文章时只需更新 articles.json，首页自动更新

const categoryConfig = {
    'category1': { icon: '🗑️', name: '自动删消息设置' },
    'category2': { icon: '🧹', name: '私聊记录清理' },
    'category3': { icon: '👥', name: '群组消息管理' },
    'category4': { icon: '⏰', name: '定时清理规则' },
    'category5': { icon: '💾', name: '聊天记录维护' }
};

function renderArticles(articles) {
    const container = document.getElementById('articles-container');
    if (!container) return;
    
    // 按分类分组
    const grouped = {};
    articles.forEach(function(article) {
        var cat = article.categoryId;
        if (!grouped[cat]) grouped[cat] = [];
        grouped[cat].push(article);
    });
    
    var html = '';
    // 按分类顺序渲染
    ['category1','category2','category3','category4','category5'].forEach(function(catId) {
        var cfg = categoryConfig[catId];
        var catArticles = grouped[catId] || [];
        
        html += '<h3 class="cat-heading">' + cfg.icon + ' ' + cfg.name + '</h3>';
        html += '<div class="article-grid">';
        
        catArticles.forEach(function(a) {
            html += '<a href="/article' + a.id + '.html" class="article-card">';
            html += '<img class="article-image" src="' + a.cover + '" alt="Telegram教程" loading="lazy">';
            html += '<div class="article-content"><h3>' + a.title + '</h3>';
            html += '<p class="article-meta">分类：' + cfg.name + '</p></div></a>';
        });
        
        html += '</div>';
    });
    
    container.innerHTML = html;
}

function loadArticles() {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            try {
                var articles = JSON.parse(xhr.responseText);
                renderArticles(articles);
            } catch(e) {
                document.getElementById('articles-container').innerHTML = 
                    '<p style="text-align:center;color:#999;">教程列表加载失败，请刷新页面重试。</p>';
            }
        }
    };
    xhr.open('GET', 'data/articles.json', true);
    xhr.send();
}

// 初始化
if (document.querySelector('#articles-container')) {
    loadArticles();
}

if (document.querySelector('.article-container')) {
    highlightTOC();
}

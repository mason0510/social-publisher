# Social Publisher

> 🚀 一个优雅的社交媒体内容发布工具，支持多平台编排和自动化发布

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.7%2B-blue)](https://www.python.org/downloads/)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)](https://github.com/)

---

## 📋 简介

**Social Publisher** 是一个分层架构的社交媒体内容发布工具，采用平台管理与工作流编排分离的设计，支持多平台内容发布、故障隔离和自动化编排。

**核心特性**:
- 🎯 **统一接口**: 一套命令管理多平台发布
- 🛡️ **故障隔离**: 单点失败不影响整体
- 🔌 **模块化设计**: 易于扩展新平台
- 🤖 **智能识别**: Claude Code Skill 自动触发
- 📊 **结构化输出**: JSON 格式支持编程集成

---

## ✨ 核心功能

### ts - Twitter/X 完整管理

- ✅ 搜索推文和推荐流
- ✅ 发布文本和多图推文（1-4张）
- ✅ 发布 Thread（双格式支持）
- ✅ 回复推文
- ✅ 删除推文
- ✅ JSON 输出

### social - 多平台编排

- ✅ 平台配置管理
- ✅ 单平台发布
- ✅ 多平台发布
- ✅ Thread 编排
- ✅ 故障隔离

---

## 🎯 适用场景

- 📝 **个人内容创作者**: 一键发布到多平台
- 🤖 **自动化营销**: Bot 自动发布内容
- 📊 **数据分析**: JSON 输出便于统计分析
- 🔄 **工作流集成**: Claude Code Skill 智能触发
- 🧪 **快速原型**: 测试不同平台的发布效果

---

## 🚀 快速开始

### 1. 安装

```bash
# 克隆仓库
git clone https://github.com/yourusername/social-publisher.git
cd social-publisher

# 创建软链接
ln -sf $(pwd)/src/tsearch /usr/local/bin/ts
ln -sf $(pwd)/src/social /usr/local/bin/social

# 验证安装
ts --help
social --help
```

### 2. 配置

```bash
# 复制环境变量模板
cp .env.example ~/.claude/credentials/.env

# 编辑配置，填入你的 Twitter API 密钥
# 获取地址: https://developer.twitter.com/
```

### 3. 使用

```bash
# 查看 platform 列表
social config list

# 发布推文
ts post "Hello from Social Publisher!"

# 发布多图推文
ts post "Check this out!" --images img1.jpg img2.jpg img3.jpg

# 发布 Thread
ts thread --file examples/thread-example.txt

# 多平台发布
social post "重要公告" --platforms twitter
```

---

## 📚 详细文档

### ts 命令

**搜索**:
```bash
ts "AI" -n 10                      # 搜索推文
ts --feed                          # 推荐流
ts --following                     # 关注流
```

**发布**:
```bash
ts post "content"                  # 纯文本
ts post --file tweet.txt           # 从文件
ts post --images a.jpg b.jpg       # 多图（1-4张）
```

**Thread**:
```bash
ts thread --file thread.txt        # 发布 Thread
ts thread --file thread.txt --images cover.jpg
```

**Thread 文件格式**（支持两种）:

*格式1 - 分隔符*:
```
第一条推文
---
第二条推文
---
第三条推文
```

*格式2 - 编号*:
```
1/ 第一条推文

2/ 第二条推文

3/ 第三条推文
```

**其他**:
```bash
ts reply 1234567890 "回复内容"    # 回复推文
ts delete 1234567890               # 删除推文
```

### social 命令

**配置管理**:
```bash
social config list                 # 列出所有平台
social config enable twitter       # 启用平台
social config disable weibo        # 禁用平台
```

**发布**:
```bash
# 单平台
social post "content" --platforms twitter
social post --file post.txt --images img.jpg --platforms twitter

# 多平台（所有已启用平台）
social post "content" --all
social post --file post.txt --all

# Thread
social thread --file thread.txt --platforms twitter
```

---

## 🏗️ 架构设计

```
┌─────────────────────────────────────┐
│  Layer 3: 工作流编排                │
│  social 命令                         │
│  - 多平台协调                        │
│  - 故障隔离                          │
│  - 结果汇总                          │
└────────────┬────────────────────────┘
             │
             ├──────────────┬──────────────┬───────
             │              │              │
             ▼              ▼              ▼
    ┌────────────┐  ┌────────────┐  ┌────────────┐
    │  Layer 2   │  │  Layer 2   │  │  Layer 2   │
    │  ts (实现) │  │ weibo(未来)│  │  xhs(未来) │
    │            │  │            │  │            │
    └─────┬──────┘  └────────────┘  └────────────┘
          │
          ▼
    ┌─────────────────────────────┐
    │  Layer 1: Twitter API v2    │
    │  - OAuth 1.0a               │
    │  - 发推/删推/回复           │
    │  - 图片上传                 │
    └─────────────────────────────┘
```

---

## 🔌 扩展新平台

### 步骤1: 注册平台

编辑 `src/social`:
```python
PLATFORMS = {
    'twitter': {...},
    'weibo': {
        'name': '微博',
        'cli': 'weibo',
        'enabled': False,
        'features': ['post', 'images']
    }
}
```

### 步骤2: 实现 CLI

创建 `src/weibo`:
```python
#!/usr/bin/env python3
# 实现 weibo post 子命令
# 支持 --json 输出
# 返回: {"success": bool, "post_id": str, "url": str}
```

### 步骤3: 添加调用逻辑

在 `src/social` 中添加:
```python
def post_to_weibo(content, images=None, json_output=False):
    cmd = ['weibo', 'post', content, '--json']
    if images:
        cmd.extend(['--images'] + images)
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
    return json.loads(result.stdout)
```

### 步骤4: 测试

```bash
social config enable weibo
social post "测试" --platforms weibo
```

详细指南: [扩展开发文档](docs/DEVELOPMENT.md)

---

## 🤖 Claude Code Skill

Social Publisher 包含 Claude Code Skill，支持自然语言触发：

```bash
# 安装 Skill
mkdir -p ~/.claude/skills/social-publisher
cp docs/SKILL.md ~/.claude/skills/social-publisher/

# 使用
# 在 Claude Code 中：
发推：AI时代需要新的思维模式
```

触发短语:
- "发推"、"发布到Twitter"
- "发Thread"
- "多平台发布"
- "回复推文"、"删除推文"

详细使用: [Skill 使用指南](docs/SKILL_USAGE.md)

---

## 📊 性能数据

| 操作 | 耗时 |
|------|------|
| 单图上传 | 2-3秒 |
| 多图上传(4张) | 5-8秒 |
| Thread(5条) | 12-15秒 |
| social 调用 | 3-5秒 |

---

## ⚠️ 限制说明

### Twitter API 限制
- Free tier: 300 推文 / 3小时
- 图片: 最多 4 张，每张 < 5MB
- 字符: 标准 280 字符，Premium 4000 字符
- Thread: 建议 < 25 条

### 平台支持
- ✅ Twitter/X (已实现)
- 🚧 微博 (计划中)
- 🚧 小红书 (计划中)
- 🚧 Facebook (计划中)

---

## 🛠️ 开发

### 环境要求
- Python 3.7+
- macOS/Linux

### 依赖
```bash
pip install requests requests-oauthlib
```

### 测试
```bash
# 运行测试
pytest tests/

# 测试覆盖率
pytest --cov=src tests/
```

---

## 📝 贡献指南

欢迎贡献！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

详细贡献指南: [CONTRIBUTING.md](docs/CONTRIBUTING.md)

---

## 📜 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- [Twitter API v2](https://developer.twitter.com/)
- [requests-oauthlib](https://requests-oauthlib.readthedocs.io/)
- [Claude Code](https://claude.ai/code)

---

## 📞 联系方式

- 作者: Mason
- 项目地址: [https://github.com/yourusername/social-publisher](https://github.com/yourusername/social-publisher)
- 问题反馈: [Issues](https://github.com/yourusername/social-publisher/issues)

---

## 🗺️ 路线图

### v1.1 (计划中)
- [ ] 添加微博平台支持
- [ ] 添加小红书平台支持
- [ ] 实现并发发布
- [ ] 添加重试机制

### v1.2 (计划中)
- [ ] 定时发布功能
- [ ] 草稿管理系统
- [ ] 推文模板系统
- [ ] 发布历史统计

### v2.0 (长期)
- [ ] Web Dashboard
- [ ] AI 内容生成集成
- [ ] A/B 测试功能
- [ ] 智能发布时间推荐

---

**⭐ 如果这个项目对你有帮助，请给个 Star！**

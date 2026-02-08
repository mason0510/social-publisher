# 内容发布工具生态系统

## 🌐 完整工具矩阵

```
┌─────────────────────────────────────────────────────────────────┐
│                     内容发布工具生态系统                          │
└─────────────────────────────────────────────────────────────────┘

🌍 国际平台                          🇨🇳 国内平台
─────────────────────────────────────────────────────────────────

┌─────────────────────────┐         ┌─────────────────────────┐
│   social-publisher      │         │     tech-publish        │
│   国际社交媒体工具        │         │   技术内容发布工具        │
├─────────────────────────┤         ├─────────────────────────┤
│ ✅ X/Twitter            │         │ ✅ 掘金 (Juejin)        │
│ 📝 Reddit (TODO)        │         │ ✅ CSDN                 │
│ 📝 YouTube (TODO)       │         │ ✅ 知乎 (Zhihu)         │
│ 📝 TikTok (TODO)        │         └─────────────────────────┘
│ 📝 Instagram (远期)      │
│ 📝 LinkedIn (远期)       │         ┌─────────────────────────┐
│ 📝 Facebook (远期)       │         │     douyin-cli          │
└─────────────────────────┘         │   抖音短视频工具          │
                                    ├─────────────────────────┤
                                    │ ✅ 视频上传              │
                                    │ ✅ 标题/话题标签         │
                                    │ ✅ 定时发布              │
                                    └─────────────────────────┘

                                    ┌─────────────────────────┐
                                    │      xhs-cli            │
                                    │   小红书发布工具          │
                                    ├─────────────────────────┤
                                    │ ✅ 图文笔记              │
                                    │ ✅ 短视频                │
                                    │ ✅ 话题标签              │
                                    └─────────────────────────┘

                                    ┌─────────────────────────┐
                                    │     weibo-cli           │
                                    │   微博发布工具            │
                                    ├─────────────────────────┤
                                    │ 📝 规划中                │
                                    └─────────────────────────┘
```

---

## 🎯 工具选择指南

### 我应该用哪个工具？

| 发布目标 | 推荐工具 | 命令示例 |
|---------|---------|---------|
| **发布到 Twitter/X** | `social-publisher` | `ts post "Hello World"` |
| **发布技术文章到掘金** | `tech-publish` | `tech-publish article.md -p juejin` |
| **发布短视频到抖音** | `douyin-cli` | `douyin upload video.mp4` |
| **发布笔记到小红书** | `xhs-cli` | `xhs post --text "..." --images img.jpg` |
| **同时发布到多个国际平台** | `social-publisher` | `social post "..." --all` |
| **同时发布到多个技术平台** | `tech-publish` | `tech-publish article.md --all` |

---

## 🔍 技术对比

### 为什么国内外平台需要不同工具？

| 维度 | 国际平台 | 国内平台 |
|------|---------|---------|
| **API 可用性** | ✅ 完善的 REST API | ❌ API 受限或无公开 API |
| **认证方式** | OAuth 2.0 / API Key | 手机验证 + 实名认证 + 图形验证码 |
| **内容审核** | 相对宽松 | 严格审核 + 敏感词过滤 |
| **技术实现** | REST API 调用 | 浏览器自动化（Playwright） |
| **开发复杂度** | 🟢 低-中 | 🔴 高 |
| **维护成本** | 🟢 低 | 🔴 高（平台频繁变更） |

---

## 🚀 快速开始

### 安装所有工具

```bash
# 国际平台工具
cd social-publisher && ./install.sh && cd ..

# 技术内容平台工具
cd tech-publish && ./install.sh && cd ..

# 抖音工具
cd douyin-cli && ./install.sh && cd ..

# 小红书工具
cd xhs-cli && ./install.sh && cd ..
```

### 配置凭证

```bash
# 国际平台
cp social-publisher/.env.example ~/.claude/credentials/.env.social

# 国内平台
cp tech-publish/.env.example ~/.claude/credentials/.env.tech
cp douyin-cli/.env.example ~/.claude/credentials/.env.douyin
cp xhs-cli/.env.example ~/.claude/credentials/.env.xhs
```

---

## 📊 平台覆盖范围

### 已支持平台（7个）

#### 国际平台（1个）
- ✅ X/Twitter - 完整支持

#### 国内平台（6个）
- ✅ 掘金 - 技术文章
- ✅ CSDN - 技术文章
- ✅ 知乎 - 技术文章/问答
- ✅ 抖音 - 短视频
- ✅ 小红书 - 图文/短视频

### 规划中平台（TODO）

#### 国际平台（3个 - 欢迎贡献）
- 📝 Reddit - TODO
- 📝 YouTube - TODO
- 📝 TikTok - TODO

#### 国内平台（1个）
- 📝 微博 - TODO

#### 未来可能支持（远期 TODO）
- 📝 Instagram - 仅作为可能方向
- 📝 LinkedIn - 仅作为可能方向

---

## 🤝 贡献

### 国际平台
贡献到 `social-publisher` 项目

### 国内平台
- 技术内容: 贡献到 `tech-publish` 项目
- 短视频: 贡献到 `douyin-cli` 项目
- 社交电商: 贡献到 `xhs-cli` 项目

---

## 📄 相关文档

- [social-publisher README](../README.md)
- [平台支持详情](./PLATFORMS.md)
- [API 使用文档](./API.md)
- [故障排除指南](./TROUBLESHOOTING.md)

---

**Built with ❤️ for content creators worldwide**

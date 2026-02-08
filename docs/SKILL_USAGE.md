# social-publisher 技能使用指南

## 🎯 什么是 social-publisher 技能？

social-publisher 是一个专为 AI Agent 设计的社交媒体发布技能，支持从 Claude Code 直接发布内容到 Twitter/X（微博/小红书即将支持）。

**核心特性**：
- ✅ **CLI 模式** - 命令行快速发布
- ✅ **Agent 模式** - JSON 输出，AI 友好
- ✅ **Thread 支持** - 自动发布长推文
- ✅ **多图支持** - 1-4 张图片
- ✅ **Pebble Spec v1.1 兼容** - 标准化输出格式

---

## 🚀 快速开始

### 安装

```bash
# 克隆仓库
git clone https://github.com/mason0510/social-publisher.git
cd social-publisher

# 安装
cargo install --path .

# 或使用安装脚本
./install.sh
```

### 配置

```bash
# 设置 Twitter API 凭证
export TWITTER_API_KEY="your_api_key"
export TWITTER_API_SECRET="your_api_secret"
export TWITTER_ACCESS_TOKEN="your_access_token"
export TWITTER_ACCESS_SECRET="your_access_secret"
```

---

## 📖 在 Claude Code 中使用

### 方式 1：直接命令（推荐）

在 Claude Code 对话中说：

```
发推："Hello, World!"
```

```
发布 Thread 并配图
```

```
回复推文 1234567890："Great post!"
```

### 方式 2：使用技能调用

```
social-publisher post "Hello, World!"
```

```
social-publisher thread --file thread.md --images img1.jpg img2.jpg
```

---

## 🔧 支持的操作

### 1. 基础发布

```bash
# 发布纯文本推文
ts post "Hello, World!"

# 发布带图片的推文
ts post "Check this out!" --images screenshot.jpg

# 发布多图推文（最多4张）
ts post "Multiple images" --images img1.jpg img2.jpg img3.jpg img4.jpg
```

### 2. Thread 发布

```bash
# 从文件发布 Thread
ts thread --file thread.txt

# Thread + 图片
ts thread --file thread.txt --images cover.jpg

# Thread + 多图
ts thread --file thread.txt --images img1.jpg img2.jpg img3.jpg img4.jpg
```

**Thread 文件格式**：

```
推文内容1

---

推文内容2

---

推文内容3
```

或使用编号格式：

```
1/5 推文内容1
2/5 推文内容2
3/5 推文内容3
4/5 推文内容4
5/5 推文内容5
```

### 3. 回复推文

```bash
# 回复指定推文
ts reply 1234567890 "Great post! Thanks for sharing."

# 回复 + 图片
ts reply 1234567890 "Here's a screenshot" --images screenshot.jpg
```

### 4. 删除推文

```bash
# 删除单条推文
ts delete 1234567890

# 批量删除
ts delete 1234567890 1234567891 1234567892
```

### 5. Agent 模式（JSON 输出）

```bash
# 发布并返回 JSON 结果
ts post "Hello" --json

# 输出示例：
{"tweet_id":"1234567890","url":"https://twitter.com/user/status/1234567890","status":"success"}
```

**为什么重要**？
- AI Agent 可以解析 JSON 输出
- 支持自动化工作流
- 便于错误处理和重试

---

## 🎨 使用场景示例

### 场景 1：快速分享想法

```bash
ts post "刚刚完成了一个新功能，social-publisher 现在支持 Thread 了！🧵

#rustlang #opensource #cli"
```

### 场景 2：发布项目公告（Thread）

```bash
# 创建 thread.txt
cat > thread.txt << 'EOF'
1/5 🚀 social-publisher v1.0 发布！

这是一个专为 AI Agent 设计的社交媒体发布工具。

---

2/5 💡 核心特性

✅ CLI 模式 - 命令行快速发布
✅ Agent 模式 - JSON 输出
✅ Thread 支持 - 自动发布长推文
✅ 多图支持 - 1-4 张图片

---

3/5 🛠️ 技术亮点

• Rust 编写，单文件二进制
• Pebble Spec v1.1 兼容
• JSON Lines 输出
• 零配置，开箱即用

---

4/5 📦 安装使用

git clone github.com/mason0510/social-publisher
cd social-publisher
cargo install --path .

ts post "Hello World"

---

5/5 🔗 链接

GitHub: github.com/mason0510/social-publisher
文档: 见仓库 README

#rustlang #cli #opensource
EOF

# 发布 Thread
ts thread --file thread.txt
```

### 场景 3：AI Agent 集成

```bash
# Agent 模式发布，解析 JSON 结果
result=$(ts post "Automated post" --json)

# 提取推文 ID 和 URL
tweet_id=$(echo $result | jq -r '.tweet_id')
url=$(echo $result | jq -r '.url')

echo "发布成功！"
echo "推文 ID: $tweet_id"
echo "链接: $url"
```

### 场景 4：批量发布

```bash
# 从 CSV 文件批量发布
while IFS=',' read -r content images; do
  if [ -z "$images" ]; then
    ts post "$content"
  else
    ts post "$content" --images $images
  fi
  sleep 60  # 避免速率限制
done < posts.csv
```

---

## 📊 Pebble Spec v1.1 兼容

social-publisher 遵循 Pebble Spec v1.1 规范，确保 AI 友好性：

### 1. --manifest 输出

```bash
ts --manifest

# 输出：
{
  "name": "social-publisher",
  "version": "1.0.0",
  "description": "Multi-platform social media publisher",
  "capabilities": [
    "post",
    "thread",
    "reply",
    "delete"
  ]
}
```

### 2. 结构化输出（--json）

```bash
ts post "test" --json

# 输出：
{"tweet_id":"12345","url":"https://...","status":"success"}
```

### 3. 标准错误格式

```bash
ts post "test"

# 锓误时：
❌ 发布失败
   错误: Invalid credentials
   建议解决方案: 检查 TWITTER_ACCESS_TOKEN 环境变量
```

### 4. JSON Lines 支持

```bash
# 批量操作，每行一个 JSON
ts batch-delete 12345 12346 12347 --json

# 输出：
{"tweet_id":"12345","status":"deleted"}
{"tweet_id":"12346","status":"deleted"}
{"tweet_id":"12347","status":"deleted"}
```

---

## 🔐 安全最佳实践

### 1. 环境变量配置

**推荐**：使用环境变量存储敏感信息

```bash
# ~/.zshrc 或 ~/.bashrc
export TWITTER_API_KEY="your_api_key"
export TWITTER_API_SECRET="your_api_secret"
export TWITTER_ACCESS_TOKEN="your_access_token"
export TWITTER_ACCESS_SECRET="your_access_secret"
```

**不推荐**：命令行传递凭证

```bash
# ❌ 不要这样做
ts post "test" --api-key "xxx" --api-secret "xxx"
```

### 2. 凭证文件权限

```bash
# 确保凭证文件权限正确
chmod 600 ~/.config/social-publisher/credentials.toml
```

### 3. 日志安全

```bash
# 日志文件自动脱敏
ts post "test" --log-level debug

# 输出中的凭证会被替换为 ***
[DEBUG] API Request: POST https://api.twitter.com/2/tweets
[DEBUG] Authorization: Bearer ***
```

---

## ⚡ 性能优化

### 1. 批量操作

```bash
# ✅ 批量删除（单次 API 调用）
ts batch-delete 12345 12346 12347

# ❌ 循环删除（多次 API 调用）
for id in 12345 12346 12347; do
  ts delete $id
done
```

### 2. 图片压缩

```bash
# 压缩图片后再上传（避免超时）
convert large.jpg -resize 1080x1080 -quality 85 compressed.jpg
ts post "test" --images compressed.jpg
```

### 3. 并发控制

```bash
# 设置并发限制（避免速率限制）
ts batch-post --file posts.txt --concurrent 3
```

---

## 🐛 故障排查

### 问题 1：认证失败

```
❌ 认证失败
错误: 401 Unauthorized
```

**解决方案**：
1. 检查环境变量是否正确设置
2. 验证 Twitter API 凭证是否有效
3. 确认访问权限（读/写）

```bash
# 测试凭证
ts verify-credentials
```

### 问题 2：速率限制

```
❌ 发布失败
状态码: 429
响应: {"title":"Too Many Requests"}
```

**解决方案**：
1. 等待 15 分钟后重试
2. 检查当前速率限制状态
3. 考虑升级 Twitter API 计划

```bash
# 查看速率限制状态
ts rate-limit
```

### 问题 3：图片上传失败

```
❌ 图片上传失败
错误: File size exceeds limit
```

**解决方案**：
1. 压缩图片（推荐 < 5MB）
2. 检查图片格式（支持 JPG/PNG/GIF）
3. 验证图片尺寸（推荐 1080x1080）

```bash
# 压缩图片
convert input.jpg -resize 1080x1080 -quality 85 output.jpg
```

### 问题 4：Thread 发布中断

```
❌ [3/7] 发布失败，Thread 中断
```

**解决方案**：
1. 检查失败推文内容
2. 修改后手动发布剩余推文
3. 使用 `--continue` 参数继续

```bash
# 继续未完成的 Thread
ts thread --file thread.txt --continue-from 3
```

---

## 📚 进阶用法

### 1. 自定义模板

```bash
# 创建自定义模板
cat > ~/.config/social-publisher/templates/announcement.md << 'EOF'
1/3 📢 {TITLE}

{CONTENT}

---

2/3 💡 关键特性

{FEATURES}

---

3/5 🔗 链接

{LINKS}
#hashtags
EOF

# 使用模板
ts thread --template announcement.md \
  --vars "TITLE=新功能发布,CONTENT=...,FEATURES=..."
```

### 2. Webhook 集成

```bash
# 配置 Webhook
ts webhook create https://your-server.com/twitter/events

# 当推文发布成功时触发 Webhook
ts post "test" --webhook
```

### 3. 定时发布

```bash
# 定时发布（需要 cron 支持）
ts post "Scheduled post" --schedule "2024-02-08 09:00"
```

---

## 🤝 贡献指南

欢迎贡献！详见 [CONTRIBUTING.md](./CONTRIBUTING.md)

### 开发

```bash
# 克隆仓库
git clone https://github.com/mason0510/social-publisher.git
cd social-publisher

# 运行测试
cargo test

# 本地开发
cargo run -- post "test"
```

详见 [DEVELOPMENT.md](./DEVELOPMENT.md)

---

## 📄 许可证

MIT License - 详见 [LICENSE](../LICENSE)

---

## 🔗 相关链接

- **GitHub**: https://github.com/mason0510/social-publisher
- **问题反馈**: https://github.com/mason0510/social-publisher/issues
- **更新日志**: [CHANGELOG.md](../CHANGELOG.md)
- **Pebble Spec**: https://pebblespec.org

---

**开始使用 social-publisher，让 AI Agent 轻松发布社交媒体内容！** 🚀

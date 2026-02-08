# Social Publisher

> 🌍 International Social Media Publishing Tool - Focus on X/Twitter, Reddit, YouTube, TikTok and other global platforms

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.7%2B-blue)](https://www.python.org/downloads/)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)](https://github.com/)

---

## 📋 Introduction

**Social Publisher** is a content publishing tool designed specifically for **international social media platforms**, featuring layered architecture and supporting automated publishing and orchestration across X/Twitter, Reddit, YouTube, TikTok and other global platforms.

**Design Principles**:
- 🌍 **Focus on International Platforms**: Dedicated to X, Reddit, YouTube, TikTok and other global social media
- 🇨🇳 **Separate Chinese Platforms**: Chinese platforms are handled by separate CLI tools (due to more complex authentication and review mechanisms)
  - `tech-publish` - Juejin, CSDN, Zhihu (tech content platforms)
  - `douyin-cli` - Douyin/TikTok China (short videos)
  - `xhs-cli` - Xiaohongshu/RED (social e-commerce)

**Core Features**:
- 🎯 **Unified Interface**: Single command set for multi-platform publishing
- 🛡️ **Fault Isolation**: Single-point failure doesn't affect overall system
- 🔌 **Modular Design**: Easy to extend with new platforms
- 🤖 **Smart Recognition**: Claude Code Skill auto-triggering
- 📊 **Structured Output**: JSON format for programmatic integration

---

## ✨ Supported Platforms

### ✅ Implemented

#### X/Twitter (Full Support)
- ✅ Publish text and multi-image tweets (1-4 images)
- ✅ Publish threads (dual format support)
- ✅ Quote tweets (retweet with comment)
- ✅ Reply to tweets
- ✅ Search tweets and feeds
- ✅ Delete tweets
- ✅ JSON output

**Command**: `ts`

### 📝 Planned (TODO)

#### Reddit
- 📝 Publish posts to specific Subreddits
- 📝 Comment and reply
- 📝 Cross-subreddit publishing

**Command**: `reddit` (TODO - contributions welcome)

#### YouTube
- 📝 Upload videos
- 📝 Set title, description, tags
- 📝 Manage playlists

**Command**: `youtube` (TODO - contributions welcome)

#### TikTok
- 📝 Upload short videos
- 📝 Add titles and hashtags
- 📝 Scheduled publishing

**Command**: `tiktok` (TODO - contributions welcome)

---

## 🎯 Multi-Platform Orchestration (social command)

- ✅ Platform configuration management
- ✅ Single platform publishing
- ✅ Multi-platform publishing
- ✅ Thread orchestration
- ✅ Fault isolation (single platform failure doesn't affect others)

---

## 🎯 Use Cases

- 📝 **Content Creators**: One-click publish to multiple platforms
- 🤖 **Automated Marketing**: Bot auto-publishing
- 📊 **Data Analysis**: JSON output for statistics
- 🔄 **Workflow Integration**: Claude Code Skill smart trigger
- 🧪 **Rapid Prototyping**: Test different platforms

---

## 🚀 Quick Start

### 1. Installation

```bash
# Clone repository
git clone https://github.com/yourusername/social-publisher.git
cd social-publisher

# Create symlinks
ln -sf $(pwd)/src/tsearch /usr/local/bin/ts
ln -sf $(pwd)/src/social /usr/local/bin/social

# Verify installation
ts --help
social --help
```

### 2. Configuration

```bash
# Copy environment template
cp .env.example ~/.claude/credentials/.env

# Edit config and add your Twitter API credentials
# Get credentials: https://developer.twitter.com/
```

### 3. Usage

```bash
# List platforms
social config list

# Publish tweet
ts post "Hello from Social Publisher!"

# Publish multi-image tweet
ts post "Check this out!" --images img1.jpg img2.jpg img3.jpg

# Publish thread
ts thread --file examples/thread-example.txt

# Multi-platform publish
social post "Important announcement" --platforms twitter
```

---

## 📚 Documentation

### ts Command

**Search**:
```bash
ts "AI" -n 10                      # Search tweets
ts --feed                          # Recommended feed
ts --following                     # Following feed
```

**Publish**:
```bash
ts post "content"                  # Plain text
ts post --file tweet.txt           # From file
ts post --images a.jpg b.jpg       # Multi-image (1-4)
```

**Thread**:
```bash
ts thread --file thread.txt        # Publish thread
ts thread --file thread.txt --images cover.jpg
```

**Thread File Formats** (supports two):

*Format 1 - Delimiter*:
```
First tweet
---
Second tweet
---
Third tweet
```

*Format 2 - Numbered*:
```
1/ First tweet

2/ Second tweet

3/ Third tweet
```

**Others**:
```bash
ts reply 1234567890 "Reply text"   # Reply to tweet
ts delete 1234567890               # Delete tweet
```

### social Command

**Configuration**:
```bash
social config list                 # List all platforms
social config enable twitter       # Enable platform
social config disable weibo        # Disable platform
```

**Publishing**:
```bash
# Single platform
social post "content" --platforms twitter
social post --file post.txt --images img.jpg --platforms twitter

# Multi-platform (all enabled)
social post "content" --all
social post --file post.txt --all

# Thread
social thread --file thread.txt --platforms twitter
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│  Layer 3: Workflow Orchestration   │
│  social command                     │
│  - Multi-platform coordination     │
│  - Fault isolation                  │
│  - Result aggregation               │
└────────────┬────────────────────────┘
             │
             ├──────────────┬──────────────┬───────
             │              │              │
             ▼              ▼              ▼
    ┌────────────┐  ┌────────────┐  ┌────────────┐
    │  Layer 2   │  │  Layer 2   │  │  Layer 2   │
    │  ts (impl) │  │ weibo(fut) │  │  xhs(fut)  │
    │            │  │            │  │            │
    └─────┬──────┘  └────────────┘  └────────────┘
          │
          ▼
    ┌─────────────────────────────┐
    │  Layer 1: Twitter API v2    │
    │  - OAuth 1.0a               │
    │  - Post/Delete/Reply        │
    │  - Media upload             │
    └─────────────────────────────┘
```

---

## 🔌 Extending New Platforms

### Step 1: Register Platform

Edit `src/social`:
```python
PLATFORMS = {
    'twitter': {...},
    'weibo': {
        'name': 'Weibo',
        'cli': 'weibo',
        'enabled': False,
        'features': ['post', 'images']
    }
}
```

### Step 2: Implement CLI

Create `src/weibo`:
```python
#!/usr/bin/env python3
# Implement weibo post subcommand
# Support --json output
# Return: {"success": bool, "post_id": str, "url": str}
```

### Step 3: Add Call Logic

In `src/social` add:
```python
def post_to_weibo(content, images=None, json_output=False):
    cmd = ['weibo', 'post', content, '--json']
    if images:
        cmd.extend(['--images'] + images)
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
    return json.loads(result.stdout)
```

### Step 4: Test

```bash
social config enable weibo
social post "Test" --platforms weibo
```

Detailed guide: [Development Documentation](docs/DEVELOPMENT.md)

---

## 🤖 Claude Code Skill

Social Publisher includes Claude Code Skill with natural language triggering:

```bash
# Install Skill
mkdir -p ~/.claude/skills/social-publisher
cp docs/SKILL.md ~/.claude/skills/social-publisher/

# Usage
# In Claude Code:
发推：AI时代需要新的思维模式
```

Trigger phrases:
- "发推", "publish to Twitter"
- "发Thread", "publish thread"
- "多平台发布", "multi-platform publish"
- "回复推文", "reply to tweet"
- "删除推文", "delete tweet"

Detailed usage: [Skill Usage Guide](docs/SKILL_USAGE.md)

---

## 📊 Performance

| Operation | Time |
|-----------|------|
| Single image upload | 2-3s |
| Multi-image (4) | 5-8s |
| Thread (5 tweets) | 12-15s |
| social call | 3-5s |

---

## ⚠️ Limitations

### Twitter API Limits
- Free tier: 300 tweets per 3 hours
- Images: Max 4 images, each < 5MB
- Characters: 280 standard, 4000 Premium
- Thread: Recommend < 25 tweets

### Platform Support
- ✅ Twitter/X (Implemented)
- 🚧 Weibo (Planned)
- 🚧 Xiaohongshu (Planned)
- 🚧 Facebook (Planned)

---

## 🛠️ Development

### Requirements
- Python 3.7+
- macOS/Linux

### Dependencies
```bash
pip install requests requests-oauthlib
```

### Testing
```bash
# Run tests
pytest tests/

# Coverage
pytest --cov=src tests/
```

---

## 📝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

Detailed guide: [CONTRIBUTING.md](docs/CONTRIBUTING.md)

---

## 📜 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details

---

## 🙏 Acknowledgments

- [Twitter API v2](https://developer.twitter.com/)
- [requests-oauthlib](https://requests-oauthlib.readthedocs.io/)
- [Claude Code](https://claude.ai/code)

---

## 📞 Contact

- Author: Mason
- Project: [https://github.com/yourusername/social-publisher](https://github.com/yourusername/social-publisher)
- Issues: [Issues](https://github.com/yourusername/social-publisher/issues)

---

## 🗺️ Roadmap

### v1.1 (Planned)
- [ ] Weibo platform support
- [ ] Xiaohongshu platform support
- [ ] Concurrent publishing
- [ ] Retry mechanism

### v1.2 (Planned)
- [ ] Scheduled publishing
- [ ] Draft management
- [ ] Tweet templates
- [ ] Publishing statistics

### v2.0 (Long-term)
- [ ] Web Dashboard
- [ ] AI content generation
- [ ] A/B testing
- [ ] Smart time recommendation

---

**⭐ If this project helps you, please give it a Star!**

# 开发指南

本文档面向想要扩展或修改 Social Publisher 的开发者。

---

## 🏗️ 项目架构

### 三层架构

```
Layer 3: Workflow Orchestration (social)
    ├─ Multi-platform coordination
    ├─ Fault isolation
    └─ Result aggregation

Layer 2: Platform Management (ts, weibo, xhs)
    ├─ Complete platform functionality
    ├─ Standardized interface
    └─ JSON output

Layer 1: Platform API
    ├─ Twitter API v2
    ├─ Weibo API
    └─ Xiaohongshu API
```

### 核心组件

#### ts - Twitter CLI
- **位置**: `src/tsearch`
- **功能**: Twitter 完整管理
- **输出**: JSON 格式
- **依赖**: `requests`, `requests-oauthlib`

#### social - Orchestrator
- **位置**: `src/social`
- **功能**: 多平台编排
- **输出**: JSON 格式
- **依赖**: Python subprocess

---

## 🔌 扩展新平台

### 步骤 1: 注册平台

编辑 `src/social` 的 `PLATFORMS` 字典：

```python
PLATFORMS = {
    'twitter': {
        'name': 'Twitter/X',
        'cli': 'ts',
        'enabled': True,
        'features': ['post', 'thread', 'reply', 'images']
    },
    'weibo': {
        'name': '微博',
        'cli': 'weibo',
        'enabled': False,  # 默认禁用
        'features': ['post', 'images']  # 支持的功能
    }
}
```

### 步骤 2: 实现 CLI

创建 `src/weibo`，实现以下功能：

```python
#!/usr/bin/env python3
"""
weibo - 微博 CLI 工具
"""

import argparse
import json
import sys

def post_weibo(content, images=None):
    """发布微博

    Args:
        content: 微博内容
        images: 图片列表

    Returns:
        dict: {'success': bool, 'post_id': str, 'url': str, 'error': str}
    """
    # 实现微博 API 调用
    api_key = os.getenv('WEIBO_APP_KEY')
    # ... 调用微博 API

    return {
        'success': True,
        'post_id': '1234567890',
        'url': 'https://weibo.com/1234567890'
    }

def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest='command')

    # post 子命令
    post_parser = subparsers.add_parser('post', help='发布微博')
    post_parser.add_argument('text', help='微博内容')
    post_parser.add_argument('--images', nargs='+', help='图片路径')
    post_parser.add_argument('--json', action='store_true', help='JSON输出')

    args = parser.parse_args()

    if args.command == 'post':
        result = post_weibo(args.text, args.images)

        if args.json:
            print(json.dumps(result, ensure_ascii=False, indent=2))
        else:
            if result['success']:
                print(result['url'])
            else:
                print(f"Error: {result['error']}", file=sys.stderr)
                sys.exit(1)

if __name__ == '__main__':
    main()
```

### 步骤 3: 添加调用逻辑

在 `src/social` 中添加：

```python
def post_to_weibo(content, images=None, json_output=False):
    """发布到微博

    Args:
        content: 内容
        images: 图片列表
        json_output: 是否JSON输出

    Returns:
        dict: 发布结果
    """
    cmd = ['weibo', 'post', content, '--json']

    if images:
        cmd.extend(['--images'] + images)

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30
        )

        if result.returncode == 0:
            return json.loads(result.stdout)
        else:
            return {
                'success': False,
                'error': result.stderr.strip() or result.stdout.strip()
            }

    except subprocess.TimeoutExpired:
        return {
            'success': False,
            'error': '微博发布超时（30秒）'
        }
    except FileNotFoundError:
        return {
            'success': False,
            'error': 'weibo 命令未找到'
        }
    except Exception as e:
        return {
            'success': False,
            'error': f'发布异常: {str(e)}'
        }
```

### 步骤 4: 更新发布逻辑

在 `publish_to_platforms` 函数中添加：

```python
for platform_id in platforms:
    print(f"\n📤 正在发布到 {PLATFORMS[platform_id]['name']}...", file=sys.stderr)

    if platform_id == 'twitter':
        result = post_to_twitter(content, images, json_output)
    elif platform_id == 'weibo':
        result = post_to_weibo(content, images, json_output)
    else:
        result = {
            'success': False,
            'error': f'平台 {platform_id} 尚未实现'
        }

    results[platform_id] = result
```

### 步骤 5: 测试

```bash
# 启用平台
social config enable weibo

# 测试发布
social post "测试内容" --platforms weibo

# 多平台测试
social post "测试内容" --all
```

---

## 🧪 测试

### 运行测试

```bash
# 所有测试
pytest tests/

# 特定文件
pytest tests/test_twitter.py

# 带覆盖率
pytest --cov=src tests/

# 详细输出
pytest -v tests/
```

### 编写测试

```python
import pytest
from unittest.mock import patch, MagicMock
from social import post_to_twitter

def test_post_to_twitter_success():
    """测试成功发布到 Twitter"""
    with patch('subprocess.run') as mock_run:
        mock_run.return_value = MagicMock(
            returncode=0,
            stdout='{"success": true, "tweet_id": "123", "url": "https://twitter.com/123"}'
        )

        result = post_to_twitter("Test content")

        assert result['success'] is True
        assert result['tweet_id'] == '123'

def test_post_to_twitter_failure():
    """测试发布失败"""
    with patch('subprocess.run') as mock_run:
        mock_run.return_value = MagicMock(
            returncode=1,
            stderr="API Error"
        )

        result = post_to_twitter("Test content")

        assert result['success'] is False
        assert 'error' in result
```

---

## 🐛 调试

### 启用调试日志

```bash
# 设置环境变量
export DEBUG=1

# 运行命令
ts post "测试内容"
```

### 常见问题

**1. 命令未找到**

```bash
# 检查 PATH
which ts
which social

# 重新创建软链接
ln -sf $(pwd)/src/tsearch /usr/local/bin/ts
```

**2. API 认证失败**

```bash
# 检查环境变量
cat ~/.claude/credentials/.env

# 测试 API 连接
python -c "from requests_oauthlib import OAuth1; print('OK')"
```

**3. 图片上传失败**

```bash
# 检查图片
file image.jpg
ls -lh image.jpg

# 应该 < 5MB
```

---

## 📝 代码规范

### Python 风格

遵循 PEP 8：

```python
# ✅ 好的命名
def publish_tweet(content, images=None):
    pass

# ❌ 不好的命名
def pub(c, i=None):
    pass
```

### 文档字符串

使用 Google 风格：

```python
def post_tweet(text, image_paths=None, reply_to=None):
    """发布推文（支持多图、回复）

    Args:
        text (str): 推文内容
        image_paths (list[str], optional): 图片路径列表（最多4张）
        reply_to (str, optional): 回复的推文ID

    Returns:
        dict: {'success': bool, 'tweet_id': str, 'url': str}
    """
    pass
```

---

## 🔄 发布流程

### 版本号

遵循语义化版本：

```
MAJOR.MINOR.PATCH

例: 1.2.3

MAJOR: 不兼容的 API 变更
MINOR: 向后兼容的功能新增
PATCH: 向后兼容的 Bug 修复
```

### 发布步骤

1. 更新版本号
2. 更新 CHANGELOG.md
3. 创建 git tag
4. 构建 release
5. 发布到 GitHub

```bash
# 更新版本
vim VERSION  # 1.2.3

# 更新 CHANGELOG
vim CHANGELOG.md

# 提交
git add .
git commit -m "chore: release v1.2.3"

# 创建 tag
git tag v1.2.3
git push origin v1.2.3
```

---

## 📚 资源

### 相关文档

- [Twitter API v2](https://developer.twitter.com/en/docs/twitter-api)
- [Weibo API](https://open.weibo.com/wiki/%E9%A6%96%E9%A1%B5)
- [requests-oauthlib](https://requests-oauthlib.readthedocs.io/)

### 开发工具

- **代码格式化**: `black`
- **代码检查**: `flake8`
- **类型检查**: `mypy`
- **测试框架**: `pytest`

---

## 💡 最佳实践

### 1. 错误处理

```python
# ✅ 明确的错误处理
try:
    result = api_call()
except APIError as e:
    logger.error(f"API call failed: {e}")
    raise
except Exception as e:
    logger.exception(f"Unexpected error: {e}")
    raise
```

### 2. 日志记录

```python
import logging

logger = logging.getLogger(__name__)

logger.info("Publishing to Twitter")
logger.error(f"Failed to publish: {error}")
```

### 3. 超时处理

```python
result = subprocess.run(
    cmd,
    capture_output=True,
    text=True,
    timeout=30  # 总是设置超时
)
```

---

**有问题？** [创建 Issue](https://github.com/yourusername/social-publisher/issues)

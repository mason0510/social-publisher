# 贡献指南

感谢你对 Social Publisher 的关注！我们欢迎所有形式的贡献。

---

## 🤝 如何贡献

### 报告 Bug

如果你发现了 Bug，请：

1. 检查 [Issues](https://github.com/yourusername/social-publisher/issues) 是否已有相同问题
2. 如果没有，创建新的 Issue，包含：
   - 清晰的标题
   - 详细的问题描述
   - 复现步骤
   - 预期行为 vs 实际行为
   - 环境信息（OS、Python 版本）
   - 错误日志（如有）

### 提出新功能

如果你有新功能建议：

1. 先在 Issues 中讨论
2. 说明功能的用途和价值
3. 提供可能的实现思路
4. 等待维护者反馈

### 提交代码

#### 1. Fork 仓库

点击右上角的 Fork 按钮

#### 2. 克隆你的 Fork

```bash
git clone https://github.com/yourusername/social-publisher.git
cd social-publisher
```

#### 3. 创建特性分支

```bash
git checkout -b feature/your-feature-name
```

分支命名规范：
- `feature/xxx` - 新功能
- `fix/xxx` - Bug 修复
- `docs/xxx` - 文档更新
- `refactor/xxx` - 代码重构

#### 4. 编写代码

遵循项目的代码规范：

```python
# 使用清晰的变量名
def publish_tweet(content, images=None):
    """发布推文

    Args:
        content: 推文内容
        images: 图片路径列表（可选）

    Returns:
        dict: 发布结果
    """
    pass
```

#### 5. 测试

确保你的代码：
- ✅ 通过现有测试
- ✅ 添加新的测试用例
- ✅ 不破坏现有功能

```bash
# 运行测试
pytest tests/

# 检查代码风格
flake8 src/
```

#### 6. 提交代码

```bash
git add .
git commit -m "feat: add weibo platform support"
```

提交信息格式：
- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `refactor:` 代码重构
- `test:` 测试相关
- `chore:` 构建/工具相关

#### 7. 推送到你的 Fork

```bash
git push origin feature/your-feature-name
```

#### 8. 创建 Pull Request

1. 访问你 Fork 的页面
2. 点击 "Compare & pull request"
3. 填写 PR 模板
4. 等待代码审查

---

## 📋 PR 检查清单

提交 PR 前，请确认：

- [ ] 代码符合项目的代码规范
- [ ] 添加了必要的测试
- [ ] 所有测试通过
- [ ] 更新了相关文档
- [ ] 提交信息清晰明确
- [ ] PR 描述详细说明了改动

---

## 🎨 代码规范

### Python 代码

遵循 PEP 8 规范：

```python
# ✅ 好的命名
def publish_to_platform(content, platform):
    pass

# ❌ 不好的命名
def pub(c, p):
    pass

# ✅ 好的注释
# 检查图片大小，确保 < 5MB
if image_size > 5 * 1024 * 1024:
    raise ValueError("Image too large")

# ❌ 不必要的注释
# 设置 i 为 0
i = 0
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

### 错误处理

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

# ❌ 捕获所有错误
try:
    result = api_call()
except:
    pass  # 永远不要这样做
```

---

## 🧪 测试规范

### 编写测试

```python
import pytest
from social_publisher import post_tweet

def test_post_tweet_success():
    """测试成功发布推文"""
    result = post_tweet("Hello World")
    assert result['success'] is True
    assert 'tweet_id' in result
    assert 'url' in result

def test_post_tweet_with_images():
    """测试发布带图推文"""
    result = post_tweet("Check this out", images=['test.jpg'])
    assert result['success'] is True

def test_post_tweet_too_many_images():
    """测试图片数量超限"""
    with pytest.raises(ValueError):
        post_tweet("Too many images", images=['1.jpg'] * 5)
```

### 运行测试

```bash
# 所有测试
pytest tests/

# 特定文件
pytest tests/test_tweet.py

# 带覆盖率
pytest --cov=src tests/

# 详细输出
pytest -v tests/
```

---

## 📖 文档贡献

文档同样重要！你可以：

1. 修正错别字和语法错误
2. 改进示例代码
3. 添加使用场景说明
4. 翻译文档

---

## 🎯 优先事项

当前最需要的贡献：

- 🚧 **微博平台支持**: 实现 `src/weibo` CLI
- 🚧 **小红书平台支持**: 实现 `src/xhs` CLI
- 📚 **文档完善**: 补充使用案例
- 🧪 **测试覆盖**: 提高测试覆盖率
- 🌍 **国际化**: 完善英文文档

---

## 💬 讨论

如果你有任何问题：

- 在 Issues 中提问
- 加入 Discussions（如果可用）
- 查阅 [文档](README.md)

---

## 📜 行为准则

请尊重所有贡献者：

- 使用友好的语言
- 接受建设性批评
- 关注对社区最有利的事情
- 对不同观点保持开放

---

## 🙏 致谢

感谢所有贡献者！你的贡献让 Social Publisher 变得更好。

---

**有问题？** [创建 Issue](https://github.com/yourusername/social-publisher/issues)

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Weibo platform support
- Xiaohongshu platform support
- Concurrent publishing
- Retry mechanism

---

## [1.0.0] - 2026-02-08

### Added
- ✨ Initial release of Social Publisher
- ✨ `ts` command for complete Twitter/X management
  - Search tweets and feeds
  - Publish text and multi-image tweets (1-4 images)
  - Publish threads with dual format support
  - Reply to tweets
  - Delete tweets
  - JSON output for programmatic integration
- ✨ `social` command for multi-platform orchestration
  - Platform configuration management
  - Single platform publishing
  - Multi-platform publishing
  - Thread orchestration
  - Fault isolation
- ✨ Claude Code Skill integration
  - Natural language triggering
  - Smart intent recognition
- ✨ Comprehensive documentation
  - README (Chinese & English)
  - Contributing guide
  - Development guide
  - Usage examples

### Features
- 🎯 Unified interface for multi-platform publishing
- 🛡️ Fault isolation mechanism
- 🔌 Modular design for easy platform extension
- 📊 Structured JSON output
- 🤖 Claude Code Skill with auto-triggering
- 📚 Complete documentation in Chinese and English

### Documentation
- Added README.md (Chinese)
- Added README_EN.md (English)
- Added CONTRIBUTING.md
- Added DEVELOPMENT.md
- Added CHANGELOG.md
- Added example files for threads and posts

### Architecture
- Three-layer architecture: Workflow Orchestration → Platform Management → Platform API
- Standardized JSON output format
- Subprocess-based platform isolation

---

## [0.1.0] - 2026-02-08 (Initial Beta)

### Added
- Basic Twitter posting functionality
- Simple multi-platform orchestrator framework
- Initial documentation

---

[Unreleased]: https://github.com/yourusername/social-publisher/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/social-publisher/compare/v0.1.0...v1.0.0
[0.1.0]: httpsgithub.com/yourusername/social-publisher/releases/tag/v0.1.0

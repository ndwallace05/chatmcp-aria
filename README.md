<div align="center">
<img src="./assets/logo.png" alt="logo" width="120" height="120">
<h1>chatmcp</h1>

Cross-platform `Macos | Windows | Linux | iOS | Android | Web` AI Chat Client

[English](./README.md) | [简体中文](./README_ZH.md) | [Türkçe](./README_TR.md)

</div>

## Install

| macOS                                                   | Windows                                                 | Linux                                                     | iOS                                                      | Android                                                 | Web                                                    |
|---------------------------------------------------------|---------------------------------------------------------|-----------------------------------------------------------|----------------------------------------------------------|---------------------------------------------------------|--------------------------------------------------------|
| [Release](https://github.com/daodao97/chatmcp/releases) | [Release](https://github.com/daodao97/chatmcp/releases) | [Release](https://github.com/daodao97/chatmcp/releases) ¹ | [TestFlight](https://testflight.apple.com/join/dCXksFJV) | [Release](https://github.com/daodao97/chatmcp/releases) | [GitHub Pages](https://daodao97.github.io/chatmcp) ² |

¹ **Linux Notes:** 
- See Linux requirements below for AppImage/DEB runtime dependencies on Ubuntu 22.04 and 24.04
- Improved Experience: Latest versions include better dark theme support, unified data storage following [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), and optimized UI layout for Linux desktop environments is planned
- Tested on major distributions: Ubuntu, Fedora, Arch Linux, openSUSE

² Note: Web version runs entirely in your browser with local storage for chat history and settings.

## Documentation

Also, you can use DeepWiki to get more information about chatmcp.  
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/daodao97/chatmcp) DeepWiki is an AI-powered platform that transforms any
public GitHub repository into a fully interactive, easy-to-understand wiki. By analysing code, documentation, and configuration files, it creates
clear explanations, interactive diagrams, and even allows for real-time Q&A with the AI.

## Preview

![Artifact Display](./docs/preview/artifact.gif)
![Thinking Mode](./docs/preview/think.webp)
![Generate Image](./docs/preview/gen_img.webp)
![LaTeX Support](./docs/preview/latex.webp)
![HTML Preview](./docs/preview/html-preview.webp)
![Mermaid Diagram](./docs/preview/mermaid.webp)
![MCP Workflow](./docs/preview/mcp-workerflow.webp)
![MCP InMemory](./docs/preview/mcp-inmemory.webp)
![MCP Tools](./docs/preview/mcp-tools.webp)
![LLM Provider](./docs/preview/llm-provider.webp)
![MCP Stdio](./docs/preview/mcp-stdio.webp)
![MCP SSE](./docs/preview/mcp-sse.webp)

### Data Sync

ChatMCP applications can sync data within the same local area network

![Data sync](./docs/preview/data-sync.webp)

## Usage

Make sure you have installed `uvx` or `npx` in your system

### MacOS

```bash
# uvx
brew install uv

# npx
brew install node 
```

### Linux

```bash
# uvx
curl -LsSf https://astral.sh/uv/install.sh | sh

# npx (using apt)
sudo apt update
sudo apt install nodejs npm
```

### Linux Requirements (Ubuntu 22.04 and 24.04)

For running ChatMCP AppImage/DEB on Ubuntu and derivatives, install the following runtime packages:

- AppImage (FUSE): `libfuse2`
- GTK 3: `libgtk-3-0`
- Graphics/EGL:
  - Ubuntu 22.04: `libegl1-mesa`, `libgles2`, `libgl1-mesa-dri`, `libglx-mesa0`
  - Ubuntu 24.04: `libegl1`, `libgles2`, `libgl1-mesa-dri`, `libglx-mesa0`
- X11 utilities and SQLite: `libx11-6`, `xdg-utils`, `libsqlite3-0`

Install commands:

- Ubuntu 22.04:
```bash
sudo apt install -y libfuse2 libgtk-3-0 libegl1-mesa libgles2 libgl1-mesa-dri libglx-mesa0 libx11-6 xdg-utils libsqlite3-0 libsqlite3-dev
```

- Ubuntu 24.04:
```bash
sudo apt install -y libfuse2 libgtk-3-0 libegl1 libgles2 libgl1-mesa-dri libglx-mesa0 libx11-6 xdg-utils libsqlite3-0 libsqlite3-dev
```

Optional (recommended): `mesa-vulkan-drivers`, `mesa-utils` (for diagnostics like glxinfo)

1. Configure Your LLM API Key and Endpoint in `Setting` Page
2. Install MCP Server from `MCP Server` Page
3. Chat with MCP Server

- stdio mcp server
  ![](./docs/mcp_stdio.png)

- sse mcp server
  ![](./docs/mcp_sse.png)

## Data Storage

ChatMCP follows platform-specific best practices for data storage:

### Storage Locations

**macOS:**
```bash
~/Library/Application Support/ARIA/
```

**Windows:**
```bash
%APPDATA%\\ARIA\\
```

**Linux:**
```bash
~/.local/share/ARIA/           # Honors $XDG_DATA_HOME if set
~/.local/share/run.daodao.chatmcp # Flutter dependency
```

**Mobile:**
- Application Documents Directory

### File Structure

All platforms store data in a unified directory structure:
- `logs` folder - Application logs
- `chatmcp.db` - Main database file containing chat history and messages
- `shared_preferences.json` - Application settings and preferences
- `mcp_server.json` - MCP server configurations

### Reset Application Data

To completely reset the application (delete all chat history, settings, and configurations):

**macOS:**
```bash
rm -rf ~/Library/Application\ Support/ARIA
```

**Windows:**
```bash
rd /s /q "%APPDATA%\\ARIA"
```

**Linux:**
```bash
rm -rf ~/.local/share/ARIA
rm -rf ~/.local/share/run.daodao.chatmcp
```

## Development

### Install Flutter

To develop or run ChatMCP, you need to have [Flutter](https://flutter.dev/) installed.  
Follow the official [Flutter installation guide](https://docs.flutter.dev/get-started/install) for your platform.

- [Download Flutter](https://docs.flutter.dev/get-started/install)

After installing, verify with:
```bash
flutter --version
```

### Mandatory Code Formatting and Pre-commit Hook

To keep a consistent code style across contributors, this repository enforces Dart formatting on every commit.

- The repository ships a versioned Git hook at `.githooks/pre-commit`.
- On commit, it runs `dart format .`, re-adds changed files, and then performs a no-output check to ensure nothing remains unformatted.
- Commits that are not properly formatted will be rejected locally; in addition, CI will fail unformatted PRs.

Quick setup (once per clone):

```bash
make setup-git-hooks
```

Manual setup (alternative):

```bash
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
```

Requirements (at least one must be available on PATH):

- Dart SDK, or
- Flutter (bundles Dart)

Examples:

- macOS/Linux (Flutter):
  ```bash
  export PATH="$PATH:$HOME/flutter/bin"
  which flutter && flutter --version
  which dart && dart --version
  ```
- macOS/Linux (Dart SDK):
  ```bash
  export PATH="$PATH:$HOME/dart-sdk/bin"
  which dart && dart --version
  ```
- Windows (PowerShell): Add `C:\\src\\flutter\\bin` (or your Flutter path) to the User/System PATH. Validate via:
  ```powershell
  where flutter
  where dart
  ```

IDE note: After changing PATH, restart your IDE so VCS operations (commit) inherit the updated environment.

CI enforcement:

- A GitHub Actions workflow `check-format` runs `dart format --output=none --set-exit-if-changed .` on push/PR and will fail if any file is not formatted.

Policy:

- Do not bypass hooks (e.g., `--no-verify`). Such changes will fail in CI and must be reformatted anyway.

### Clone and Run Locally

```bash
# Clone the repository
git clone https://github.com/daodao97/chatmcp.git
cd chatmcp

# Install dependencies
flutter pub get

# Run on macOS
flutter run -d macos

# Run on Linux (requires Flutter desktop support enabled)
flutter run -d linux

# Build release for Linux
flutter build linux
```

### Web Version

#### Local Development
```bash
# Install dependencies
flutter pub get

# Run Web version locally
flutter run -d chrome
# Or specify port
flutter run -d chrome --web-port 8080
# Or run as web-serer for other browsers.
flutter run -d web-server
```

#### Build Web Version
```bash
# Build production version
flutter build web

# Build with base path (for deploying to subdirectory)
flutter build web --base-href /chatmcp/
```

#### Deploy to GitHub Pages
```bash
# 1. Build Web version
flutter build web --base-href /chatmcp/

# 2. Push build/web directory contents to gh-pages branch
# Or use GitHub Actions for automatic deployment
```

After building, files will be in the `build/web` directory and can be deployed to any static website hosting service.

## Features

- [x] Chat with MCP Server
- [X] MCP Server Market
- [ ] Auto install MCP Server
- [x] SSE MCP Transport Support
- [x] Auto Choose MCP Server
- [x] Chat History
- [x] OpenAI LLM Model
- [x] Claude LLM Model
- [x] OLLama LLM Model
- [x] DeepSeek LLM Model
- [ ] RAG
- [ ] Better UI Design
- [x] Dark/Light Theme

All features are welcome to submit, you can submit your ideas or bugs in [Issues](https://github.com/daodao97/chatmcp/issues)

## MCP Server Market

You can install MCP Server from MCP Server Market, MCP Server Market is a collection of MCP Server, you can use it to chat with different data.

* Also you can add new MCP Server to the Market : [MCP Server Market](https://github.com/chatmcpclient/mcp_server_market/blob/main/mcp_server_market.json)

Create a fork of [mcp_server_market](https://github.com/chatmcpclient/mcp_server_market) and add your MCP Server to the `mcp_server_market.json` end of the file.

```json
{
    "mcpServers": {
        "existing-mcp-servers": {},
        "your-mcp-server": {
              "command": "uvx",
              "args": [
                  "--from",
                  "git+https://github.com/username/your-mcp-server",
                  "your-mcp-server"
            ]
        }
    }
}
```
You can send a Pull Request to the [mcp_server_market](https://github.com/chatmcpclient/mcp_server_market) repository to add your MCP Server to the Market. After your PR is merged, your MCP Server will be available in the Market and other users can use it immediately.

Your feedback helps us improve chatmcp and helps other users make informed decisions.

## Thanks

- [MCP](https://modelcontextprotocol.io/introduction)
- [mcp-cli](https://github.com/chrishayuk/mcp-cli)

## License

This project is licensed under the [Apache License 2.0](./LICENSE).

## Star History

![](https://api.star-history.com/svg?repos=daodao97/chatmcp&type=Date)

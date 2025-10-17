# 安裝指南

完整的 VibeGhostty 配置安裝步驟。

---

## 📋 系統需求

- macOS 11.0+
- [Ghostty](https://ghostty.org/) 終端機
- [Homebrew](https://brew.sh/) 套件管理器

---

## 🚀 安裝步驟

### Step 1: 安裝 Ghostty

```bash
# 使用 Homebrew 安裝
brew install --cask ghostty

# 或從官網下載
# https://ghostty.org/
```

### Step 2: 安裝 JetBrains Mono Nerd Font

```bash
# 安裝字體（必須）
brew install --cask font-jetbrains-mono-nerd-font

# 驗證安裝
ls ~/Library/Fonts/ | grep -i jetbrains
```

成功安裝會看到類似輸出：
```
JetBrainsMonoNerdFont-Bold.ttf
JetBrainsMonoNerdFont-Regular.ttf
...（共 96 個字體檔案）
```

### Step 3: 備份現有配置（如果有）

```bash
# 檢查是否有現有配置
if [ -f ~/Library/Application\ Support/com.mitchellh.ghostty/config ]; then
    # 備份到家目錄
    cp ~/Library/Application\ Support/com.mitchellh.ghostty/config \
       ~/ghostty-config.backup
    echo "✅ 已備份現有配置到 ~/ghostty-config.backup"
else
    echo "📝 沒有現有配置，可以直接安裝"
fi
```

### Step 4: 複製 VibeGhostty 配置

```bash
# Clone 專案（如果從 GitHub）
git clone https://github.com/yourusername/VibeGhostty.git
cd VibeGhostty

# 複製配置文件
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 驗證配置
ls -lh ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

### Step 5: 啟動或重新載入 Ghostty

**方法 1：首次啟動**
```bash
open -a Ghostty
```

**方法 2：重新載入現有 Ghostty**

在 Ghostty 視窗中按 `Cmd+Shift+Comma`

**方法 3：完全重啟**
```bash
pkill -9 ghostty
open -a Ghostty
```

---

## ✅ 驗證安裝

### 檢查清單

開啟 Ghostty 後確認：

- [ ] 無錯誤訊息
- [ ] 字體顯示為 JetBrains Mono
- [ ] 背景為深藍灰色（Tokyo Night Storm）
- [ ] Cursor 為橙色
- [ ] Tab bar 在視窗頂部

### 測試快捷鍵

- [ ] `Cmd+T` - 新建 tab
- [ ] `Cmd+1` - 跳轉第一個 tab
- [ ] `Cmd+D` - 分割視窗
- [ ] `Cmd+Shift+Comma` - 重新載入配置

---

## 🐛 常見問題

### Q1: Ghostty 找不到配置文件

**解決方法**：手動創建目錄
```bash
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/
```

### Q2: 字體沒有正確顯示

**檢查步驟**：
1. 確認 Nerd Font 已安裝
2. 重新載入配置
3. 完全重啟 Ghostty

```bash
# 重新安裝字體
brew reinstall --cask font-jetbrains-mono-nerd-font

# 重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

### Q3: 快捷鍵不工作

**可能原因**：
- 與系統快捷鍵衝突
- 配置文件語法錯誤
- Ghostty 版本過舊

**解決方法**：
1. 檢查系統偏好設定 → 鍵盤 → 快速鍵
2. 驗證配置文件無錯誤
3. 更新 Ghostty 到最新版本

### Q4: 配置載入後出現錯誤訊息

**解決方法**：
```bash
# 查看配置文件
cat ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 使用備份的乾淨配置
cp ~/Documents/GitHub/VibeGhostty/config \
   ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 完全重啟
pkill -9 ghostty && open -a Ghostty
```

---

## 🔄 更新配置

當 VibeGhostty 有新版本時：

```bash
# 更新專案
cd ~/Documents/GitHub/VibeGhostty
git pull origin main

# 備份當前配置
cp ~/Library/Application\ Support/com.mitchellh.ghostty/config \
   ~/ghostty-config-old.backup

# 複製新配置
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 重新載入
# 在 Ghostty 按 Cmd+Shift+Comma
```

---

## 🗑️ 解除安裝

如果要移除 VibeGhostty 配置：

```bash
# 刪除配置文件
rm ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 恢復備份（如果有）
if [ -f ~/ghostty-config.backup ]; then
    cp ~/ghostty-config.backup \
       ~/Library/Application\ Support/com.mitchellh.ghostty/config
fi

# 重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

---

## 📞 獲取幫助

遇到問題？

1. 查看 [完整指南](GUIDE.md)
2. 查看 [Ghostty 官方文檔](https://ghostty.org/docs)
3. 提交 [GitHub Issue](https://github.com/yourusername/VibeGhostty/issues)

---

**安裝完成！享受高效的 AI 協作體驗！** 🎉

# 文檔驗證報告

此目錄包含 VibeGhostty 文檔的驗證報告。

## 驗證報告

### 1. 程式碼範例驗證報告
**文件**: [code-examples-validation-report.md](code-examples-validation-report.md)
**驗證日期**: 2025-10-19
**驗證範圍**: docs/user-guide/*.zh-TW.md (6 個文檔)

**總體評分**: A+ (98.7% 通過率)

**主要發現**:
- ✅ 所有 Bash 程式碼語法正確（176/176）
- ✅ 所有 Toml 配置語法正確（16/16）
- ✅ 所有路徑格式正確（127/127）
- ⚠️ 217 個視覺示意區塊缺少語言標記（設計選擇，合理）

**詳細內容**:
- 各文檔詳細分析
- Bash 語法驗證結果
- 路徑格式檢查
- Toml 配置驗證
- 指令可執行性測試
- 改善建議

---

## 驗證流程

### 驗證維度

1. **程式碼區塊語言標記**
   - 檢查所有 ``` 標記是否有語言標識
   - 統計 bash、toml、text 等標記使用

2. **Bash 語法**
   - 指令拼寫正確性
   - 選項格式正確性（-h, --help, -p 40）
   - 路徑引號處理（包含空格的路徑）
   - 管道和重定向正確性（|, >, >>）

3. **檔案路徑**
   - 配置文件路徑正確性
   - 腳本路徑存在性
   - 相對路徑合理性
   - macOS 空格路徑轉義

4. **可執行性**
   - 安裝指令語法
   - 配置複製指令
   - 驗證指令
   - 腳本執行權限

### 驗證工具

- **grep**: 模式匹配和統計
- **bash -n**: Bash 語法檢查
- **手動審查**: 完整閱讀所有程式碼區塊

---

## 品質標準

### 評分標準

| 等級 | 通過率 | 說明 |
|------|--------|------|
| A+ | 95-100% | 優秀，幾乎無問題 |
| A | 90-95% | 良好，少量問題 |
| B | 80-90% | 可接受，有改善空間 |
| C | 70-80% | 需要改進 |
| D | <70% | 嚴重問題，需立即處理 |

### 問題優先級

- 🔴 **高優先級**: 語法錯誤，必須修正
- 🟡 **中優先級**: 缺少語言標記，建議改善
- 🟢 **低優先級**: 改善建議，可選

---

## 使用方式

### 查看完整報告

```bash
# 閱讀完整驗證報告
cat docs/validation/code-examples-validation-report.md

# 或在瀏覽器中查看（推薦）
# 在 GitHub 上直接點擊文件
```

### 驗證流程重現

```bash
# 統計 bash 程式碼區塊
grep -c '```bash' docs/user-guide/*.zh-TW.md

# 統計 toml 程式碼區塊
grep -c '```toml' docs/user-guide/*.zh-TW.md

# 檢查缺少語言標記的區塊
grep -c '^```$' docs/user-guide/*.zh-TW.md

# 檢查路徑格式
grep -n 'Application Support' docs/user-guide/*.zh-TW.md | \
  grep -v 'Application\\ Support' | \
  grep -v '".*Application Support.*"'
```

---

## 維護

### 更新頻率

建議在以下情況更新驗證報告：

1. **文檔重大更新**: 新增或修改大量程式碼範例
2. **發現問題**: 用戶回報程式碼範例錯誤
3. **定期審查**: 每季度驗證一次

### 驗證腳本

可考慮創建自動化驗證腳本：

```bash
#!/usr/bin/env bash
# docs/validation/validate.sh

echo "開始驗證文檔程式碼範例..."

# 統計
echo "Bash 區塊: $(grep -c '```bash' docs/user-guide/*.zh-TW.md)"
echo "Toml 區塊: $(grep -c '```toml' docs/user-guide/*.zh-TW.md)"
echo "缺少標記: $(grep -c '^```$' docs/user-guide/*.zh-TW.md)"

# 驗證 Bash 語法
# ... 更多檢查

echo "驗證完成！"
```

---

**最後更新**: 2025-10-19
**維護者**: VibeGhostty Team

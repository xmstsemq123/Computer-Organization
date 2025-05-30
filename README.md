# Computer Organization Projects

本儲存庫紀錄本人於《計算機組織》課程中完成的各項 Verilog 實作作業，內容涵蓋 ALU、無號乘除法器、單週期處理器及五級管線處理器等模組的設計與模擬。

所有模組皆透過 **ModelSim** 進行模擬驗證，並使用 **OpenROAD** 開源數位後端流程工具，觀察合成後的晶片面積與 critical path slack。

---

## 📁 專案結構與內容

### 🔹 HW1 — 32-bit Complete ALU
- 實作功能完整的 32-bit ALU
- 支援加法、減法、AND、OR、XOR、位移、Set-on-less-than 等運算
- 通過 ModelSim 測試驗證正確性

---

### 🔹 PA1 — Unsigned Multiplier and Divider

以無號乘法與除法為主題，分為兩個子項目：

- **Part1**：32-bit Unsigned Complete Multiplier  
  - 採用移位加法法（Shift-and-Add）完成乘法器設計與模擬

- **Part2**：32-bit Unsigned Complete Divider  
  - 使用 Restoring Division 或 Non-Restoring Division 架構實現除法器

---

### 🔹 PA2 — Single Cycle Processor (MIPS)

建構以 MIPS 指令集為基礎的單週期處理器，分為三個階段：

- **Part1**：支援 R-format 指令（如 `add`, `sub`, `and`, `or`）
- **Part2**：擴充支援 I-format 指令（如 `lw`, `sw`, `addi`）
- **Part3**：新增分支與跳躍指令（如 `beq`, `j`）

每階段皆完成功能模擬，並以 OpenROAD 觀察綜合結果（面積與 slack）。

---

### 🔹 PA3 — 5-stage Pipelined Processor (MIPS)

設計並實作五級管線 MIPS 處理器（IF, ID, EX, MEM, WB），含 Hazard 處理：

- **Part1**：僅支援 R-format 指令的五級管線 CPU
- **Part2**：擴充至支援 I-format 指令
- **Part3**：加入 Forwarding 與 Hazard Detection 機制，有效避免資料冒險

---

## 🧪 使用工具

| 工具名稱 | 功能描述 |
|----------|----------|
| **ModelSim** | Verilog RTL 模擬與功能驗證 |
| **OpenROAD** | 數位後端綜合（合成、放置、繞線），用於觀察面積與 critical path slack |

---

## 📌 重點主題

- Verilog 語言設計與模組化開發
- ALU 與算術邏輯單元架構
- 無號乘除法演算法實作
- 單週期 CPU 設計流程
- MIPS 指令集架構理解與解碼
- 五級管線化與 hazard 解決機制
- OpenROAD 實際合成與時序分析應用

---

## 🧑‍💻 作者資訊

若有問題、建議或合作意願，歡迎透過 GitHub Issues 或 Pull Requests 聯繫我！

---

🔒 _本專案為課程用途，請尊重原創設計，勿直接抄襲。_

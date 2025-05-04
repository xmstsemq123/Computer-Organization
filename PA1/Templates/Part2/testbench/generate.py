import random

def generate_div_inputs(n=10):
    lines = []
    for _ in range(n):
        dividend = random.randint(1, 0xFFFFFFFF)
        divisor = random.randint(1, 0xFFFFFFFF)
        line = f"{dividend:08X}_{divisor:08X}"  # 64-bit 合併輸出
        lines.append(line)
    return lines

# 產生訊號
signals = generate_div_inputs(1000)

# 寫入 tb_CompDivider.in 檔案
with open("tb_CompDivider.in", "w") as f:
    for line in signals:
        f.write(line + "\n")

print("已寫入 tb_CompDivider.in！")
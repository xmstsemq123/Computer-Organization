def hex_to_int(hex_str):
    return int(hex_str, 16)

def check_divider_output(in_file="tb_CompDivider.in", out_file="tb_CompDivider.out"):
    with open(in_file, "r") as f_in:
        in_lines = [line.strip() for line in f_in.readlines() if line.strip()]
    
    with open(out_file, "r") as f_out:
        out_lines = [line.strip() for line in f_out.readlines() if line.strip()]
    
    if len(in_lines) != len(out_lines):
        print("❌ 行數不一致！")
        print(f"  IN檔有 {len(in_lines)} 行，OUT檔有 {len(out_lines)} 行")
        return

    all_passed = True
    for i, (in_line, out_line) in enumerate(zip(in_lines, out_lines), 1):
        dividend_hex, divisor_hex = in_line.split("_")
        quotient_hex, remainder_hex = out_line.split("_")  # 商_餘數

        dividend = hex_to_int(dividend_hex)
        divisor = hex_to_int(divisor_hex)
        expected_quotient = dividend // divisor
        expected_remainder = dividend % divisor

        result_quotient = hex_to_int(quotient_hex)
        result_remainder = hex_to_int(remainder_hex)

        if expected_quotient != result_quotient or expected_remainder != result_remainder:
            print(f"❌ 第 {i} 行錯誤")
            print(f"   被除數/除數: {dividend_hex} / {divisor_hex}")
            print(f"   模擬結果: 商={quotient_hex} 餘數={remainder_hex}")
            print(f"   正確答案: 商={hex(expected_quotient)} 餘數={hex(expected_remainder)}")
            all_passed = False

    if all_passed:
        print("✅ 所有結果都正確！")

# 執行檢查
check_divider_output()

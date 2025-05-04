outdata = []
indata = []
with open("tb_CompMultiplier.out") as file:
    for line in file:
        outdata.append(line.strip())

with open("tb_CompMultiplier.in") as file:
    for line in file:
        indata.append(line.strip())

errorData = {}
for i in range(len(indata)):
    multiplier = int(indata[i][0:8], 16)
    multiplicand = int(indata[i][9:17], 16)
    product = int(outdata[i], 16)
    if multiplier*multiplicand == product:
        equal = "=="
    else:
        errorData[f"{indata[i][0:8]}*{indata[i][9:17]}"] = {outdata[i]}
        equal = "!="
    print(f"{indata[i][0:8]}*{indata[i][9:17]} {equal} {outdata[i]}")

if len(errorData) != 0:
    for dataKey in errorData:
        print(f"{dataKey} != {errorData[dataKey]}")
    print("There's some error in verilog code!")
else:
    print("Congrats! All data Matched!")
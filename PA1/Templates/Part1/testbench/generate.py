# Re-run test data generation after environment reset
import random

def generate_test_data(num_samples=1000):
    data = []
    for _ in range(num_samples):
        multiplicand = random.getrandbits(32)
        multiplier = random.getrandbits(32)
        line = f"{multiplicand:08X}_{multiplier:08X}"
        data.append(line)
    return data

test_data = generate_test_data()

file_path = "tb_CompMultiplier.in"
with open(file_path, "w") as f:
    f.write("\n".join(test_data))

file_path
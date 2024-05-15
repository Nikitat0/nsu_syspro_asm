import argparse
import os
import random
import string

def random_lines():
    src = string.digits + string.ascii_letters + string.punctuation
    lines = []
    for _ in range(20):
        l = random.randint(0, 255)
        line = "".join(random.choices(src, k=l))
        lines.append(line)
    return lines


parser = argparse.ArgumentParser()
parser.add_argument("executable")
parser.add_argument("filename")
args = parser.parse_args()

executable = args.executable
inputf = args.filename
outputf = inputf + ".sorted"

for _ in range(100):
    lines = random_lines()
    with open(inputf, "w") as f:
        for line in lines:
            f.write(line + '\n')
    lines.sort()
    status = os.system(f"./{executable} {inputf}")
    assert status == 0
    with open(outputf, "r") as f:
        got = f.read().splitlines()
    assert len(got) == len(lines)
    for i in range(len(lines)):
        assert got[i] == lines[i]

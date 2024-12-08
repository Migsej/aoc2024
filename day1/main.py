with open("test.txt", "r") as f:
  lines = f.read().splitlines()

list1 = [0 for i in range(len(lines))]
list2 = [0 for i in range(len(lines))]
for i, line in enumerate(lines):
  list1[i], list2[i] = map(int, line.split())

list1.sort()
list2.sort()

result = 0
for a, b in zip(list1, list2):
  result += max(a, b) - min(a, b)
print(result)


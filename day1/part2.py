with open("test.txt", "r") as f:
  lines = f.read().splitlines()

list1 = [0 for i in range(len(lines))]
list2 = [0 for i in range(len(lines))]
for i, line in enumerate(lines):
  list1[i], list2[i] = map(int, line.split())


result = 0
for a in list1:
  result += a * list2.count(a)
print(result)


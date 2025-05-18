from itertools import chain, combinations

t = int(input())

for _ in range(t):
	n, m = map(int, input().split())
	
	length = 0
	x = 0
	words = []
	
	for i in range(n):
		words.append(input())

	for word in words:
		if len(word)+length <= m:
			length += len(word)
			x += 1
		else:
			break
	print(x)
		
t = int(input())
for _ in range(t):
    a1, a2, b1, b2 = map(int, input().split())
    w = 0

    s = (a1 > b1) + (a2 > b2)
    r = (a1 < b1) + (a2 < b2)
    w += s > r

    s = (a1 > b2) + (a2 > b1)
    r = (a1 < b2) + (a2 < b1)
    w += s > r

    s = (a2 > b1) + (a1 > b2)
    r = (a2 < b1) + (a1 < b2)
    w += s > r

    s = (a2 > b2) + (a1 > b1)
    r = (a2 < b2) + (a1 < b1)
    w += s > r

    print(w)

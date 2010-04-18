function adjMatrix = createDirectedGraphDistinct(N, R)

cells = accumarray(@(n) cell(n).face = 0, 1:N)
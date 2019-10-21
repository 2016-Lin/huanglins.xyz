---
title: "Leetcode算法 51.N皇后"
date: 2019-10-21T10:30:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

n 皇后问题研究的是如何将 n 个皇后放置在 n×n 的棋盘上，并且使皇后彼此之间不能相互攻击。

![图片](/images/blog/2019-10/51_8-queens.png)

上图为 8 皇后问题的一种解法。

给定一个整数 n，返回所有不同的 n 皇后问题的解决方案。

每一种解法包含一个明确的 n 皇后问题的棋子放置方案，该方案中 `'Q'` 和 `'.' `分别代表了皇后和空位。

**示例:**

``` golang
输入: 4
输出: [
 [".Q..",  // 解法 1
  "...Q",
  "Q...",
  "..Q."],

 ["..Q.",  // 解法 2
  "Q...",
  "...Q",
  ".Q.."]
]
解释: 4 皇后问题存在两个不同的解法。
```

#### 解题过程

首先，我们以4皇后来举例，下面是模拟图

![动图](/images/blog/2019-10/51_4.gif)

因为我们需要把所有的结果都要保存下来，因此使用递归回溯。

根据题意皇后不能在同一行，同一列，主副对角线上。

又因为，对角线和行和列有关系。
对于所有的主对角线有 `行号 + 列号 = 常数`，对于所有的次对角线有 `行号 - 列号 = 常数`.

![对角线](/images/blog/2019-10/51_1.png)

因此，我们需要多个Set来保存具体的个对角线，行，是否已经有值，保证每个皇后不能被攻击。

``` golang
type queen struct {
	// 最大行
	max    int
	// 保存列信息
	column []bool
	// 保存主对角线
	left   []bool
	// 保存副对角线
	right  []bool
}

var chess [][]string

func solveNQueens(n int) [][]string {
	defer func() {
		chess = nil
	}()

	q := queen{
		n,
		make([]bool, n),
		make([]bool, n*2),
		make([]bool, n*2),
	}
	q.DFS(0, []string{})
	return chess
}

func (q *queen) DFS(level int, result []string) {
	if level >= q.max {
		chess = append(chess, result)
		return
	}

	for x := 0; x < q.max; x++ {
		columnOK := q.column[x]
		// 主对角线
		leftOK := q.left[x+level]
		// 副对角线
		rightOK := q.right[x-level+q.max]

		// 能被攻击，不符合
		if leftOK || rightOK || columnOK {
			continue
		}
		// 设置列，对角线信息
		q.column[x] = true
		q.left[x+level] = true
		q.right[x-level+q.max] = true

		row := strings.Repeat(".", x) + "Q"
		
		if x < q.max-1 {
			row += strings.Repeat(".", q.max-x-1)
		}
		
		// 将本次找到的结果保存下来
		cache := make([]string, len(result))
		copy(cache, result)
		cache = append(cache, row)
		
		q.DFS(level+1, cache)
		
		// 回溯回来，恢复现场
		q.column[x] = false
		q.left[x+level] = false
		q.right[x-level+q.max] = false
	}
}

```
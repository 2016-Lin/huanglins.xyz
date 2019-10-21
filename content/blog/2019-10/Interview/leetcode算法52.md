---
title: "Leetcode算法 52.N皇后2"
date: 2019-10-21T11:30:50+08:00
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

给定一个整数 n，返回所有不同的 n 皇后问题的解决方案。

给定一个整数 n，返回 n 皇后不同的解决方案的数量。

**示例:**

``` golang 
输入: 4
输出: 2
解释: 4 皇后问题存在如下两个不同的解法。
[
 [".Q..",  // 解法 1
  "...Q",
  "Q...",
  "..Q."],

 ["..Q.",  // 解法 2
  "Q...",
  "...Q",
  ".Q.."]
]
```

#### 解题过程

具体可以参考上一篇N皇后1


``` golang
type queen struct {
	max    int
	column []bool
	left   []bool
	right  []bool
}

func totalNQueens(n int) int {

	q := queen{
		n,
		make([]bool, n),
		make([]bool, n*2),
		make([]bool, n*2),
	}
	nums := 0
	q.DFS(0, &nums)
	return nums
}

func (q *queen) DFS(level int, nums *int) {
	if level >= q.max {
		*nums++
		return
	}

	for x := 0; x < q.max; x++ {
		columnOK := q.column[x]
		// 主对角线
		leftOK := q.left[x+level]
		// 副对角线
		rightOK := q.right[x-level+q.max]

		// 被攻击
		if leftOK || rightOK || columnOK {
			continue
		}
		q.column[x] = true
		q.left[x+level] = true
		q.right[x-level+q.max] = true

		q.DFS(level+1, nums)

		q.column[x] = false
		q.left[x+level] = false
		q.right[x-level+q.max] = false
	}
}
```
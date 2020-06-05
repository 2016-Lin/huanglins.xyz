---
title: "Leetcode算法 64. 最小路径和"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---


#### 64.最小路径和

给定一个包含非负整数的 m x n 网格，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。

**说明:**每次只能向下或者向右移动一步。

**示例:**

``` golang
输入:
[
  [1,3,1],
  [1,5,1],
  [4,2,1]
]
输出: 7
解释: 因为路径 1→3→1→1→1 的总和最小。

```

#### 解题

``` golang
func minPathSum(grid [][]int) int {
	m := len(grid)
	
	if m == 0 {
		return 0
	}
	
	n := len(grid[0])
	if n == 0 {
		return 0
	}

	t1 := 0
	t2 := 0

	f := make([][]int, 2, 2)
	
	f[0] = make([]int, n, n)
	f[1] = make([]int, n, n)

	old := 0
	now := 1

	for i := 0; i < m; i++ {
		old = now
		now = 1 - now

		for j := 0; j < n; j++ {
		    // 如果是起点
			if i == 0 && j == 0 {
				f[now][j] = grid[i][j]
				continue
			}

			
			f[now][j] = grid[i][j]
			
			// 不是第一行
			if i > 0 {
				t1 = f[old][j]
			} else {
				t1 = math.MaxInt32
			}

			// 不是第一列
			if j > 0 {
				t2 = f[now][j-1]
			} else {
				t2 = math.MaxInt32
			}

			// 比较从上和从左的数的大小
			if t1 > t2 {
				f[now][j] += t2
			} else {
				f[now][j] += t1
			}
		}
	}
	return f[now][n-1]
}
```
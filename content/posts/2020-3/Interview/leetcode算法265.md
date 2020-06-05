---
title: "Leetcode算法 265. 粉刷房子Ⅱ"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 265. 粉刷房子

这里有n个房子在一列直线上，现在我们需要给房屋染色，共有k种颜色。每个房屋染不同的颜色费用也不同，你需要设计一种染色方案使得相邻的房屋颜色不同，并且费用最小。

费用通过一个nxk 的矩阵给出，比如cost[0][0]表示房屋0染颜色0的费用，cost[1][2]表示房屋1染颜色2的费用。

**样例1：**
``` txt
输入:
costs = [[14,2,11],[11,14,5],[14,3,10]]
输出: 10
说明:
三个屋子分别使用第1,2,1种颜色，总花费是10。
```

**样例2:**

``` txt
输入:
costs = [[5]]
输出: 5
说明：
只有一种颜色，一个房子，花费为5
```

**挑战**
用O(nk)的时间复杂度解决

#### 解题

``` golang
func minCostII(A [][]int) int {
	if len(A) == 0 {
		return 0
	}

	n, K := len(A), len(A[0])
	f := make([][]int, n+1)
	f[0] = make([]int, K)
	var (
		// 优化，因为在计算本次时，只有把前一次的最小值（颜色不相同）和次小值（颜色相同），
		min1, min2 int
		j1, j2     int
	)
	// 初始化
	for i := 0; i < K; i++ {
		f[0][i] = 0
	}

	for i := 1; i <= n; i++ {
		f[i] = make([]int, K)
		min1 = math.MaxInt32
		min2 = math.MaxInt32
		// 找到前一次的最小值和次小值
		for j := 0; j < K; j++ {
			if f[i-1][j] < min1 {
				min2 = min1
				j2 = j1
				min1 = f[i-1][j]
				j1 = j
			} else {
				if f[i-1][j] < min2 {
					min2 = f[i-1][j]
					j2 = j
				}
			}
		}

		for j := 0; j < K; j++ {
			// 坐标和前一个最小值不相同，及颜色不相同
			if j != j1 {
				f[i][j] = f[i-1][j1] + A[i-1][j]
			} else {
				f[i][j] = f[i-1][j2] + A[i-1][j]
			}
		}
	}
	res := math.MaxInt32
	for i := 0; i < K; i++ {
		if res > f[n][i] {
			res = f[n][i]
		}
	}
	return res
}

```
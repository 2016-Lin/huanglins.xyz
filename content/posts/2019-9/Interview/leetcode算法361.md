---
title: "Leetcode算法 361.轰炸敌人"
date: 2019-09-20T17:49:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给你一个二维的网格图，网格图中的每一个格子里要么是一堵墙 'W' ，要么是一个敌人 'E' ，要么是一个空位 '0' （数字 0 ），返回你用一个炸弹最多能杀死敌人的数量。

由于墙体足够坚硬，炸弹的威慑力没有办法穿越墙体，所以炸弹只能把所在位置同一行和同一列所有没被墙挡住的敌人给炸死。

**注意:**你只能把炸弹放在一个空的格子里

**示例:**
``` go

输入: [["0","E","0","0"],["E","0","W","E"],["0","E","0","0"]]
输出: 3 
解释: 对于如下网格图，

0 E 0 0 
E 0 W E 
0 E 0 0

在位置 (1,1) 放置炸弹可以杀死 3 个敌人。
```

#### 解题思路

通过题目描述，我们需要通过动态规划来解决这道题。这里就不解释上面是动态规划了，不懂的可以自行百度。

根据题目的条件，我们知道，要判断炸弹消灭敌人，要从四个方向来判断，通过动态规划的策略，我们分别在从四个方向进行计算。


``` go
func maxKilledEnemies(A [][]byte) int {
	m := len(A)
	if m == 0 {
		return 0
	}
	n := len(A[0])
	if n == 0 {
		return 0
	}

	f := make([][]int, m, m)
	res := make([][]int, m, m)
	for i := 0; i < m; i++ {
		f[i] = make([]int, n, n)
		res[i] = make([]int, n, n)
	}

	result := 0

	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			res[i][j] = 0
		}
	}

	// 上
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if A[i][j] == 'W' {
				f[i][j] = 0
			} else {
				f[i][j] = 0
				if A[i][j] == 'E' {
					f[i][j] = 1
				}
				if i-1 >= 0 {
					f[i][j] += f[i-1][j]
				}
			}
			res[i][j] += f[i][j]
		}
	}

	// 下
	for i := m - 1; i >= 0; i-- {
		for j := 0; j < n; j++ {
			if A[i][j] == 'W' {
				f[i][j] = 0
			} else {
				f[i][j] = 0
				if A[i][j] == 'E' {
					f[i][j] = 1
				}
				if i+1 < m {
					f[i][j] += f[i+1][j]
				}
			}
			res[i][j] += f[i][j]
		}
	}

	// 左
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if A[i][j] == 'W' {
				f[i][j] = 0
			} else {
				f[i][j] = 0
				if A[i][j] == 'E' {
					f[i][j] = 1
				}
				if j-1 >= 0 {
					f[i][j] += f[i][j-1]
				}
			}
			res[i][j] += f[i][j]
		}
	}

	// 右
	for i := 0; i < m; i++ {
		for j := n - 1; j >= 0; j-- {
			if A[i][j] == 'W' {
				f[i][j] = 0
			} else {
				f[i][j] = 0
				if A[i][j] == 'E' {
					f[i][j] = 1
				}
				if j+1 < n {
					f[i][j] += f[i][j+1]
				}
			}
			res[i][j] += f[i][j]
		}
	}

	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if A[i][j] == '0' {
				if res[i][j] > result {
					result = res[i][j]
				}
			}
		}
	}

	return result
}

```
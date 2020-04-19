---
title: "Leetcode算法 62. 不同路径"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 62. 不同路径

一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为“Start” ）。

机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为“Finish”）。

问总共有多少条不同的路径？

![图片](/images/blog/2020-3/robot_maze.png)

例如，上图是一个7 x 3 的网格。有多少可能的路径？

**示例1:**

``` golang

输入: m = 3, n = 2
输出: 3
解释:
从左上角开始，总共有 3 条路径可以到达右下角。
1. 向右 -> 向右 -> 向下
2. 向右 -> 向下 -> 向右
3. 向下 -> 向右 -> 向右

```

**示例2：**

``` golang
输入: m = 7, n = 3
输出: 28
```

**提示:**

``` golang
- 1 <= m, n <= 100
- 题目数据保证答案小于等于 2 * 10 ^ 9
```

#### 解题思路

``` golang
func uniquePaths(m, n int, s string) int {
	f := make([][]int, m, m)
	
	for i := 0; i < m; i++ {
		array := make([]int, n, n)
		f[i] = array
		
		for j := 0; j < n; j++ {
		    // 如果是第一行或者是第一列
			if i == 0 || j == 0 {
				f[i][j] = 1
			} else {
				f[i][j] = f[i-1][j] + f[i][j-1]
			}
		}
	}
	return f[m-1][n-1]
}

```



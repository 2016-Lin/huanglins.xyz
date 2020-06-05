---
title: "Leetcode算法 322. 零钱兑换"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 322. 零钱兑换

给定不同面额的硬币 coins 和一个总金额 amount。编写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合能组成总金额，返回 -1。


**示例1:**
输入: coins = [1, 2, 5], amount = 11
输出: 3 
解释: 11 = 5 + 5 + 1

**示例2:**

输入: coins = [2], amount = 3
输出: -1

**说明:**

你可以认为每种硬币的数量是无限的。

#### 解题

``` golang
func coinChange(coins []int, amount int) int {
	n := len(coins)
	f := make([]int, amount+1)
	f[0] = 0

	for i := 1; i <= amount; i++ {
		f[i] = math.MaxInt32
		for j := 0; j < n; j++ {
			if i >= coins[j] && f[i-coins[j]] != math.MaxInt32 && f[i-coins[j]]+1 < f[i] {
				f[i] = f[i-coins[j]] + 1
			}
		}
	}
	if f[amount] == math.MaxInt32 {
		return -1
	} else {
		return f[amount]
	}
}
```

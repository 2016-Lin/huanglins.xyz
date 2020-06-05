---
title: "Leetcode算法 300. 最长上升子序列"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 300. 最长上升子序列

给定一个无序的整数数组，找到其中最长上升子序列的长度。

**示例1:**

``` txt
输入: [10,9,2,5,3,7,101,18]
输出: 4 
解释: 最长的上升子序列是 [2,3,7,101]，它的长度是 4。
```

**说明:**

- 可能会有多种最长上升子序列的组合，你只需要输出对应的长度即可。
- 你算法的时间复杂度应该为 O(n2) 。

**进阶:** 你能将算法的时间复杂度降低到 O(n log n) 吗?

#### 解题

``` golang
func lengthOfLIS(nums []int) int {
	if len(nums) == 0 {
		return 0
	}
	dp := make([]int, len(nums), len(nums))

	dp[0] = 1
	maxans := 1
	for i := 1; i < len(dp); i++ {
		maxval := 0
		for j := 0; j < i; j++ {
			if nums[i] > nums[j] {
				maxval = int(math.Max(float64(maxval), float64(dp[j])))
			}
		}
		dp[i] = maxval + 1
		maxans = int(math.Max(float64(maxans), float64(dp[i])))
	}
	return maxans
}
```
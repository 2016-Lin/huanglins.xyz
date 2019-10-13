---
title: "Leetcode算法 16.最接近的三数之和"
date: 2019-10-13T17:49:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定一个包括 n 个整数的数组 `nums` 和 一个目标值 `target`。找出 `nums` 中的三个整数，使得它们的和与 `target` 最接近。返回这三个数的和。假定每组输入只存在唯一答案。

``` golang
例如，给定数组 nums = [-1，2，1，-4], 和 target = 1.

与 target 最接近的三个数的和为 2. (-1 + 2 + 1 = 2).
```

#### 解题过程


``` golang
func threeSumClosest(nums []int, target int) int {
	// 首先对数组进行排序
	sort.Ints(nums)
	// 初始sum值
	ans := nums[0] + nums[1] + nums[2]

	for i := 0; i < len(nums); i++ {
		// 使用两个指针进行运算
		start := i + 1
		end := len(nums) - 1
		for start < end {
			sum := nums[start] + nums[end] + nums[i]
			if math.Abs(float64(target-sum)) < math.Abs(float64(target-ans)) {
				ans = sum
			}
			// 如果sum大于target，说明数组和过大，需要较小的数，因此往前
			if sum > target {
				end--
			// 如果sum小于target，说明数组和过小，需要较大的数，因此往后
			} else if sum < target {
				start++
			// 如果大小等于target，说明找到了最小差
			} else {
				return ans
			}
		}
	}
	return ans
}
```
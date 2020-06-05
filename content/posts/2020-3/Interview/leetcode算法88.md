---
title: "Leetcode算法 88. 合并两个有序数组"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 88. 合并两个有序数组

给你两个有序整数数组 nums1 和 nums2，请你将 nums2 合并到 nums1 中，使 num1 成为一个有序数组。

**说明:**
- 初始化 nums1 和 nums2 的元素数量分别为 m 和 n 。
- 你可以假设 nums1 有足够的空间（空间大小大于或等于 m + n）来保存 nums2 中的元素。

**示例：**

``` golang
输入:
nums1 = [1,2,3,0,0,0], m = 3
nums2 = [2,5,6],       n = 3

输出: [1,2,2,3,5,6]

```

#### 解题

1. 因为两个数组是排序好了
2. nums1的长度为m+n

可以从后往前，通过比较最后一位的大小，最大的放在最后，以此类推.

``` golang

func merge(nums1 []int, m int, nums2 []int, n int) {
	index := n + m - 1
	m = m - 1
	n = n - 1

	for m >= 0 && n >= 0 {
		if nums1[m] < nums2[n] {
			nums1[index] = nums2[n]
			index--
			n--
		} else {
			nums1[index] = nums1[m]
			index--
			m--
		}
	}
	// 如果n!=-1，表示剩下的是以排好序的小值

	for i := 0; i < n+1; i++ {
		nums1[i] = nums2[i]
	}
}
```
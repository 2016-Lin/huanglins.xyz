---
title: "Leetcode算法 4.寻找两个有序数组的中位数"
date: 2019-09-14T17:49:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---


### 寻找两个有序数组的中位数

给定两个大小为 m 和 n 的有序数组 `nums1` 和 `nums2`。

请你找出这两个有序数组的中位数，并且要求算法的时间复杂度为 `O(log(m + n))`。

你可以假设 `nums1` 和 `nums2` 不会同时为空。

**示例1:**
``` go
nums1 = [1, 3]
nums2 = [2]

则中位数是 2.0
```
**示例2:**
``` go
nums1 = [1, 3]
nums2 = [2]

则中位数是 2.0
```

该算法的难度是时间复杂度必须为`O(log(m + n))`

这里使用的递归,两个递归函数的时间复杂度为`O(logm)`和`O(logn)`，整个时间复杂度为`O(logm * logn)= O(log(m + n))`

``` go
func findMedianSortedArrays(nums1 []int, nums2 []int) float64 {
    m := len(nums1)
	n := len(nums2)

	l := (m + n + 1) / 2
	r := (m + n + 2) / 2
	return (getKth(nums1,0,nums2,0,l) + getKth(nums1,0,nums2,0,r)) /2.0
}

const INT_MAX = int(^uint(0) >> 1)

func getKth(nums1 []int, start1 int, nums2 []int, start2 int, k int) float64 {
	if start1 >= len(nums1) {
		return float64(nums2[start2+k-1])
	}

	if start2 >= len(nums2) {
		return float64(nums1[start1+k-1])
	}

	if k == 1 {
		return math.Min(float64(nums1[start1]), float64(nums2[start2]))
	}

	var nums1Mid int
	
	if start1+k/2-1 < len(nums1) {
		nums1Mid = nums1[start1+k/2-1]
	} else {
		nums1Mid = INT_MAX
	}
	var nums2Mid int
	if start2+k/2-1 < len(nums2) {
		nums2Mid = nums2[start2+k/2-1]
	} else {
		nums2Mid = INT_MAX
	}

	if nums1Mid < nums2Mid {
		return getKth(nums1, start1+k/2, nums2, start2, k-k/2)
	} else {
		return getKth(nums1, start1, nums2, start2+k/2, k-k/2)
	}
}
```


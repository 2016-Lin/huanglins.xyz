---
title: "Leetcode算法 169. 多数元素"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 169. 多数元素

给定一个大小为 n 的数组，找到其中的多数元素。多数元素是指在数组中出现次数大于 ⌊ n/2 ⌋ 的元素。

你可以假设数组是非空的，并且给定的数组总是存在多数元素。

**示例1:**
``` txt
输入: [3,2,3]
输出: 3
```

**示例2：**

``` txt
输入: [2,2,1,1,1,2,2]
输出: 2
```

#### 解题

``` golang
func majorityElement(nums []int) int {
	var count, candidate int
	for _, num := range nums {
	// 当count等于0时，相当于剩了一个字符
		if count == 0 {
			candidate = num
		}

		if num == candidate {
			count += 1
		} else {
			count += -1
		}
	}
	return candidate
}
```
---
title: "Leetcode算法 1.两数之和"
date: 2019-09-13T22:02:36+08:00
draft: false
toc: true
categories: ["技术"]
series: ["leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---	

### 两数之和

给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。

你可以假设每种输入只会对应一个答案。但是，你不能重复利用这个数组中同样的元素

**实例：**

``` go
给定 nums = [2, 7, 11, 15], target = 9

因为 nums[0] + nums[1] = 2 + 7 = 9
所以返回 [0, 1]
```

#### 第一种暴力法

两次`for`循环查找，时间复杂度为O(n^2)

``` go
func twoSum(nums []int, target int) []int {
    a := make([]int, 2, 2)
	for i := 0; i < len(nums); i++ {
		for j := i + 1; j < len(nums); j++ {
			if nums[i]+nums[j] == target {
				a[0], a[1] = i, j
			}
		}
	}
	return a
}
```
![结果](/images/blog/2019/算法1_1.png)
#### 第二种，利用`map`的hash来求

这种方法，利用map的hash查找，来实现，时间复杂度O(n），相对的在内存消耗上就要多些。

``` go
func twoSum(nums []int, target int) []int {
    numMap := make(map[int]int)
	for i := 0; i < len(nums); i++ {
		other := target - nums[i]
		if v, ok := numMap[other]; ok {
			return []int{v, i}
		}
		numMap[nums[i]] = i
	}
	return []int{-1, -1}
}
```
![结果](/images/blog/2019/算法1_2.png)

---
title: "Leetcode算法 31.下一个排列"
date: 2019-11-21T13:10:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

实现获取下一个排列的函数，算法需要将给定数字序列重新排列成字典序中下一个更大的排列。

如果不存在下一个更大的排列，则将数字重新排列成最小的排列（即升序排列）。

必须`原地`修改，只允许使用额外常数空间。

以下是一些例子，输入位于左侧列，其相应输出位于右侧列。

`1,2,3` → `1,3,2`
`3,2,1` → `1,2,3`
`1,1,5` → `1,5,1`

#### 解题过程

参考官方的解析

1.如果给定序列是一个降序，那么只需要反转就可以了。

![图片1](/images/blog/2019-11/31_1.png)

2.其他情况下，我们首先从尾部向前推进，找到a[i-1] < a[i]的数，说明a[i]之后的数是降序的，
我们只需在后面排好序的数中找到它的合适位置，即a[j] > a[i-1],a[i-1] > a[j+1]的位置，把它和j位置上的数进行调换。

![图片2](/images/blog/2019-11/31.gif)

``` golang
func nextPermutation(nums []int) {
	i := len(nums) - 2
	for i >= 0 && nums[i+1] <= nums[i] {
		i--
	}
	if i >= 0 {
		j := len(nums) - 1
		for j >= 0 && nums[j] <= nums[i] {
			j--
		}
		swap(nums, i, j)
	}
	reverse(nums, i+1)
}

func reverse(nums []int, i int) {
	for j := len(nums) - 1; i < j; i, j = i+1, j-1 {
		swap(nums, i, j)
	}
}

func swap(nums []int, i, j int) {
	tmp := nums[i]
	nums[i] = nums[j]
	nums[j] = tmp
}

```

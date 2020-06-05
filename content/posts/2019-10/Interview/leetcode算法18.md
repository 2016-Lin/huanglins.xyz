---
title: "Leetcode算法 18.四数之和"
date: 2019-10-24T11:30:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定一个包含 n 个整数的数组 `nums` 和一个目标值 `target`，判断 `nums` 中是否存在四个元素 a，b，c 和 d ，使得 a + b + c + d 的值与 `target` 相等？找出所有满足条件且不重复的四元组。

**注意:**

答案中不可以包含重复的四元组

**示例:**

``` golang 
给定数组 nums = [1, 0, -1, 0, -2, 2]，和 target = 0。

满足要求的四元组集合为：
[
  [-1,  0, 0, 1],
  [-2, -1, 1, 2],
  [-2,  0, 0, 2]
]

```


#### 解题过程

一般，我们解决多数和时都采用多指针，这题是4数和，所以我们可以使用双指针来做。

- 1.我们要对数组进行排序。
- 2.我们要过滤掉重复的数组，因此，这里我采用的是set集合来做的。

![图片](/images/blog/2019-10/sf_18_1.png)


``` golang
func fourSum(nums []int, target int) [][]int {
	res := make([][]int, 0)
	set := make(map[string]bool)
	l := len(nums)
	sort.Ints(nums)

	for i := 0; i < l-2; i++ {

		for j := l - 1; j > i+2; j-- {

			for pre, front := i+1, j-1; pre < front; {

				sum := nums[i] + nums[pre] + nums[front] + nums[j]
				if sum == target {
					str := strconv.Itoa(nums[i]) + strconv.Itoa(nums[pre]) + strconv.Itoa(nums[front]) + strconv.Itoa(nums[j])
					if !set[str] {
						set[str] = true
						res = append(res, []int{nums[i], nums[pre], nums[front], nums[j]})
					}
					front--
					pre++
				} else if sum > target {
					front--
				} else if sum < target {
					pre++
				}
			}
		}
	}
	return res
}

```
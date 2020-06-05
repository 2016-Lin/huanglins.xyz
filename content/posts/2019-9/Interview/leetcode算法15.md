---
title: "Leetcode算法 15.三数之和"
date: 2019-09-26T17:49:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---


#### 简介

给定一个包含 n 个整数的数组 `nums`，判断 `nums` 中是否存在三个元素 a，b，c ，使得 a + b + c = 0 ？找出所有满足条件且不重复的三元组。

**注意:** 答案中不可以包含重复的三元组。

``` go
例如, 给定数组 nums = [-1, 0, 1, 2, -1, -4]，

满足要求的三元组集合为：
[
  [-1, 0, 1],
  [-1, -1, 2]
]
```

#### 解题思路

- 首先对数组进行排序，排序后固定一个数 nums[i]，再使用左右指针指向 nums[i]后面的两端，数字分别为 nums[L] 和 nums[R]，计算三个数的和 sum 判断是否满足为 0，满足则添加进结果集
- 如果 nums[i]大于 0，则三数之和必然无法等于 0，结束循环
- 如果 nums[i] == nums[i−1]，则说明该数字重复，会导致结果重复，所以应该跳过
- 当 sum == 0 时，nums[L] == nums[L+1] 则会导致结果重复，应该跳过，L + +
- 当 sum == 0 时，nums[R] == nums[R-1]则会导致结果重复，应该跳过，R - -
- 时间复杂度：O(n^2)，n为数组长度


![图片](/images/blog/sf/15_Slide1.png)
![图片](/images/blog/sf/15_Slide2.png)
![图片](/images/blog/sf/15_Slide3.png)
![图片](/images/blog/sf/15_Slide4.png)
![图片](/images/blog/sf/15_Slide5.png)
![图片](/images/blog/sf/15_Slide6.png)
![图片](/images/blog/sf/15_Slide7.png)
![图片](/images/blog/sf/15_Slide8.png)
![图片](/images/blog/sf/15_Slide9.png)
![图片](/images/blog/sf/15_Slide10.png)
![图片](/images/blog/sf/15_Slide11.png)
![图片](/images/blog/sf/15_Slide12.png)


``` go
func threeSum(nums []int) [][]int {
	n := len(nums)
    ans := make([][]int, 0)
	if n < 3 {
		return [][]int{}
	}
	sort.Ints(nums)

	for i := 0; i < n; i++ {
		if nums[i] > 0 {
			break
		}
		if i > 0 && nums[i] == nums[i-1] {
			continue
		}

		L := i + 1
		R := n - 1

		for L < R {
			sum := nums[i] + nums[L] + nums[R]
			if sum == 0 {
				a := make([]int, 3)
				a[0] = nums[i]
				a[1] = nums[L]
				a[2] = nums[R]
				ans = append(ans, a)
				for L < R && nums[L] == nums[L+1] {
					L++
				}

				for L < R && nums[R] == nums[R-1] {
					R--
				}
				L++
				R--
			} else if sum < 0 {
				L++
			} else if sum > 0 {
				R--
			}
		}
	}
	return ans
}
```

[参考leetcode题解](https://leetcode-cn.com/problems/3sum/solution/hua-jie-suan-fa-15-san-shu-zhi-he-by-guanpengchn/)


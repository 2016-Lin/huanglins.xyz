---
title: "Leetcode算法 338. 比特位计数"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 338. 比特位计数

给定一个非负整数 num。对于 0 ≤ i ≤ num 范围中的每个数字 i ，计算其二进制数中的 1 的数目并将它们作为数组返回。

**示例1：**

输入: 2
输出: [0,1,1]

**示例2：**

输入: 5
输出: [0,1,1,2,1,2]

**进阶:**

- 给出时间复杂度为O(n*sizeof(integer))的解答非常容易。但你可以在线性时间O(n)内用一趟扫描做到吗？
- 要求算法的空间复杂度为O(n)。
- 你能进一步完善解法吗？要求在C++或任何其他语言中不使用任何内置函数（如 C++ 中的 __builtin_popcount）来执行此操作。

#### 解题

因为 101010和10101的1的个数相同因此可以用前面使用过的数。加过速度。

``` golang
func countBits(num int) []int {
	f := make([]int, num+1)
	f[0] = 0
	for i := 1; i <= num; i++ {
		f[i] = f[i>>1] + (i % 2)
	}
	return f
}

```
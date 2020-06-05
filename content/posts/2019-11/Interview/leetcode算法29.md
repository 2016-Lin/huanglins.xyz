---
title: "Leetcode算法 29.两数相除"
date: 2019-11-12T22:00:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定两个整数，被除数 `dividend` 和除数 `divisor`。将两数相除，要求不使用乘法、除法和 mod 运算符。

返回被除数 `dividend` 除以除数 `divisor` 得到的商。

**示例1:**

``` golang
输入: dividend = 10, divisor = 3
输出: 3
```

**示例2:**

``` golang
输入: dividend = 7, divisor = -3
输出: -2
```

**说明:**

- 被除数和除数均为 32 位有符号整数。
- 除数不为 0。
- 假设我们的环境只能存储 32 位有符号整数，其数值范围是 [−2^31,  2^31 − 1]。
- 本题中，如果除法结果溢出，则返回 2^31 − 1。

#### 结果过程

参考leetcode评论区[29.两数相除](https://leetcode-cn.com/problems/divide-two-integers/solution/29-liang-shu-xiang-chu-by-en-zhao/)

该方法是将数，变为负数来求。


``` golang
func divide(dividend, divisor int) int {
	a := dividend > 0
	b := divisor > 0
	// 判定商的符号
	var sign bool
	if a != b {
		sign = true
	}

	// 将被除数和除数转化负数进行运算
	if dividend > 0 {
		dividend = -dividend
	}
	if divisor > 0 {
		divisor = -divisor
	}
	// 进行循环求商
	res := 0
	for dividend <= divisor {
		temp_res := -1
		temp := divisor
		for dividend <= (temp << 1) {
			// 如果移位chu'xian负数越界
			if temp < math.MinInt32>>1 {
				break
			}
			temp = temp << 1
			temp_res = temp_res << 1
		}
		dividend -= temp
		res += temp_res
	}
	// 当商是正数的时候 进行取反操作
	if sign == false {
		// 防止正数越界 -2147483648 --> 2147483647(2147483648会越界
		if res <= math.MinInt32 {
			res = math.MaxInt32
		} else {
			res = -res
		}
	}
	return res
}
```
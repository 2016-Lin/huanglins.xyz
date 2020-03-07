---
title: "Leetcode算法 509. 斐波那契数"
date: 2020-03-7T11:10:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 509. 斐波那契数

斐波那契数，通常用 F(n) 表示，形成的序列称为斐波那契数列。该数列由 0 和 1 开始，后面的每一项数字都是前面两项数字的和。也就是：

``` txt 
F(0) = 0,   F(1) = 1
F(N) = F(N - 1) + F(N - 2), 其中 N > 1.
```

给定 N，计算 F(N)。

**示例1**

``` golang

输入：2
输出：1
解释：F(2) = F(1) + F(0) = 1 + 0 = 1.


```

**示例2**

``` golang

输入：3
输出：2
解释：F(3) = F(2) + F(1) = 1 + 1 = 2.


```

**提示**

0 ≤ N ≤ 30


#### 解题过程

这里就不写过程了，经典题目，直接上代码

``` golang

func fib(N int) int {
	f := make([]int, 2, 2)
	f[0] = 0
	f[1] = 1
	if N < 2 {
		return f[N]
	}
	for i := 2; i <= N; i++ {
		f = append(f, f[i-1]+f[i-2])
	}
	return f[N]
}

```


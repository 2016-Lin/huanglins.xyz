---
title: "Leetcode算法 7.整数反转"
date: 2019-09-17T17:49:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给出一个 32 位的有符号整数，你需要将这个整数中每位上的数字进行反转。

**示例1:*

``` go
输入: 123
输出: 321
```

**示例2:**

``` go
输入: -123
输出: -321
```

**示例3:**
``` go
输入: 120
输出: 21
```

**注意**

假设我们的环境只能存储得下 32 位的有符号整数，则其数值范围为 `[−2^31,  2^31 − 1]`。请根据这个假设，如果反转后整数溢出那么就返回 `0`。

#### 思路

当我们遇到关于数字的计算时 ，首先想到的是，堆栈或数组来存储。
如果没有数组和堆栈了。因此，我们要换一种方式。
我们假设`x=12345679`，如果要将该数字进行反转，通过取余和除法可以将每一位，保存下来，但是这样也要消耗一定的内存和时间。
如果我们在取位的同时进行运算了？
``` go
x := 123456789

我们首先取到的是9，我们将9作为新数字的首位通过下面运算，到最后，则9必定是最高位
则结果是987654321

//pop operation:
pop = x % 10;
x /= 10;

//push operation:
temp = rev * 10 + pop;
rev = temp;

MaxInt32 = 2147483647
MinInt32 = -2147483648

```

但是这方法有一个问题，就是如何判断是否溢出，通过上面的数学式子

我们可以假设 `temp = rev * 10 + pop > MaxInt32`,因为`rev * 10`末尾为`0`，因此有如下两种结果

- 第一种:`rev * 10 > MaxInt32`,则`temp > MaxInt32`
- 第二种:`rev * 10 + pop > MaxInt32`,假设`  rev * 10 = MaxInt32,rev * 10 = MinInt32`,可以推导出`pop > 7,pop < -8`时，temp 溢出


``` go
func reverse(x int) int {
	rev := 0
	for x != 0 {
		pop := x % 10
		x /= 10
		if rev > math.MaxInt32/10 || (rev == math.MinInt32/10 && pop > 7) {
			return 0
		}
		if rev < math.MinInt32/10 || (rev == math.MinInt32/10 && pop < -8) {
			return 0
		}
		rev = rev*10 + pop
	}
	return rev
}
```


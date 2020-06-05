---
title: "Leetcode算法 1052.爱生气的老板"
date: 2019-09-17T17:49:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---
#### 简介
今天，书店老板有一家店打算试营业 `customers.length` 分钟。每分钟都有一些顾客（`customers[i]`）会进入书店，所有这些顾客都会在那一分钟结束后离开。

在某些时候，书店老板会生气。 如果书店老板在第 `i` 分钟生气，那么 `grumpy[i] = 1`，否则 `grumpy[i] = 0`。 当书店老板生气时，那一分钟的顾客就会不满意，不生气则他们是满意的。

书店老板知道一个秘密技巧，能抑制自己的情绪，可以让自己连续 `X` 分钟不生气，但却只能使用一次。

请你返回这一天营业下来，最多有多少客户能够感到满意的数量。

**示例:**
``` go

输入：customers = [1,0,1,2,1,1,7,5], grumpy = [0,1,0,1,0,1,0,1], X = 3
输出：16
解释：
书店老板在最后 3 分钟保持冷静。
感到满意的最大客户数量 = 1 + 1 + 1 + 1 + 7 + 5 = 16.
```

**提示:**

- `1 <= X <= customers.length == grumpy.length <= 20000`
- `0 <= customers[i] <= 1000`
- `0 <= grumpy[i] <= 1`

#### 解题
通过读题，我们了解到，发动技能时，所有状态都会编程不生气状态，因此，我们可以先将原来的人数计算出来。

我们在将X区间类的生气时候的人数进行相加，得到的就是发动技能时候的人数了。

``` go
func maxSatisfied(customers []int, grumpy []int, X int) int {
	sum := 0

	// 计算一般情况
	for i, v := range grumpy {
		if v == 0 {
			sum += customers[i]
		}
	}

	max := 0
	tmp := 0
	// 先假设发动技能时候的区间
	for i := 0; i < X; i++ {
		if grumpy[i] == 1 {
			tmp += customers[i]
		}
	}
	max = tmp

	// 通过i的移动来计算不同区间的人数
	for i := 0; i < len(grumpy)-X; i++ {
		if grumpy[i] == 1 {
			tmp -= customers[i]
		}
		if grumpy[i+X] == 1 {
			tmp += customers[i+X]
		}
		// 找到最大的人数
		if tmp > max {
			max = tmp
		}
	}
	return max+sum
}
```
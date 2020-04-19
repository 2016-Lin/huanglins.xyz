---
title: "Leetcode算法 121. 买卖股票的最佳时机"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 121.买卖股票的最佳时机

给定一个数组，它的第 i 个元素是一支给定股票第 i 天的价格。

如果你最多只允许完成一笔交易（即买入和卖出一支股票），设计一个算法来计算你所能获取的最大利润。

注意你不能在买入股票前卖出股票。

**示例1:**

``` golang
输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。

```

**示例2：**

``` golang
输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

#### 解题

``` golang
func maxProfit(prices []int) int {
	if len(prices) == 0 {
		return 0
	}
	n := len(prices)
	res := 0
	min := prices[0]

	for i := 1; i < n; i++ {
		// 判断最小值
		if prices[i-1] < min {
			min = prices[i-1]
		}
		// 如果收益大于以前的，保存
		if res < (prices[i] - min) {
			res = prices[i] - min
		}
	}
	return res
}
```
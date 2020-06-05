---
title: "Leetcode算法 91. 解码方法"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 91. 解码方法

一条包含字母 A-Z 的消息通过以下方式进行了编码：

'A' -> 1
'B' -> 2
...
'Z' -> 26

给定一个只包含数字的非空字符串，请计算解码方法的总数。

**示例1：**

``` golang
输入: "12"
输出: 2
解释: 它可以解码为 "AB"（1 2）或者 "L"（12）。
```

**示例2：**

``` golang
输入: "226"
输出: 3
解释: 它可以解码为 "BZ" (2 26), "VF" (22 6), 或者 "BBF" (2 2 6) 。
```

#### 解题

每次都判断最后两个数字能否有两种解码状态。



``` golang
func numDecodings(s string) int {
	n := len(s)
	if n == 0 {
		return 0
	}
	f := make([]int, n+1)
	f[0] = 1

	for i := 1; i <= n; i++ {
	
		f[i] = 0
		// 获取数字
		t := s[i-1] - '0'
		// 
		if t >= 1 && t <= 9 {
		// 数字本身，因此总数不变
			f[i] += f[i-1]
		}

		if i >= 2 {
			t = (s[i-2]-'0')*10 + (s[i-1] - '0')
			if t >= 10 && t <= 26 {
			// 后面两个数字可以组合，因此需要加上在该解码下的次数
				f[i] += f[i-2]
			}
		}
	}
	return f[n]
}
```
---
title: "Leetcode算法 20.有效的括号"
date: 2019-10-25T15:00:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定一个只包括 `'('`，`')'`，`'{'`，`'}'`，`'['`，`']'` 的字符串，判断字符串是否有效。

有效字符串需满足：

1. 左括号必须用相同类型的右括号闭合。
2. 左括号必须以正确的顺序闭合。

注意空字符串可被认为是有效字符串。

**示例1:**

``` golang 
输入："()"
输出:true
```

**示例2:**

``` golang
输入: "()[]{}"
输出: true
```

**示例3:**

``` golang
输入: "(]"
输出: false
```

**示例4:**

``` golang
输入: "([)]"
输出: false
```

**示例5:**

``` golang
输入: "{[]}"
输出: true
```

#### 解题过程

``` golang
func isValid(s string) bool {
	// 如果是奇数，一定不匹配
	if len(s)%2 != 0 {
		return false
	}
	m := map[byte]byte{'}': '{', ']': '[', ')': '('}
	var stack []byte
	for _, v := range s {
		if len(stack) > 0 {
			if m[byte(v)] == stack[len(stack)-1] {
				stack = stack[:len(stack)-1]
				continue
			}
		}
		stack = append(stack, byte(v))
	}
	return len(stack) == 0
}
```


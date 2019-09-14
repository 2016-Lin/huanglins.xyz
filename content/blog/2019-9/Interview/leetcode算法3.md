---
title: "Leetcode算法 3.无重复字符的最长子串"
date: 2019-09-14T12:49:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

### 无重复字符的最长子串

给定一个字符串，请你找出其中不含有重复字符的 最长子串 的长度。
**示例1:**
``` go
输入: "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
```

**示例2:**
``` go
输入: "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
```

**示例3:**
``` go
输入: "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
```

这里说的是字符，字符有256个，因此我们可以建立一个256长度的数组，初始值为-1，

``` go
 func lengthOfLongestSubstring(s string) int {
   dict := [256]int{-1}
	for i, _ := range dict {
		dict[i] = -1
	}
	res := 0
	index := -1
	for i, c := range s {
	// 如果字符已经出现过了
		if dict[c] != -1 {
			if index < dict[c] {
				index = dict[c]
			}
		}
		// 如果没有出现，则将改字符的位置保存
		dict[c] = i
		// 保存不重复字符长度
		if (i - index) > res {
			res = i - index
		}
	}
	return res
}
```
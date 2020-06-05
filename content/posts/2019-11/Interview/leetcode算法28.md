---
title: "Leetcode算法 28.实现 strStr()"
date: 2019-11-12T21:30:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

实现 strStr() 函数。

给定一个 haystack 字符串和一个 needle 字符串，在 haystack 字符串中找出 needle 字符串出现的第一个位置 (从0开始)。如果不存在，则返回  -1。

**示例1:**

``` golang
输入: haystack = "hello", needle = "ll"
输出: 2
```

**示例2:**

``` golang
输入: haystack = "aaaaa", needle = "bba"
输出: -1
```

**说明:**

当 `needle` 是空字符串时，我们应当返回什么值呢？这是一个在面试中很好的问题。

对于本题而言，当`needle` 是空字符串时我们应当返回 0 。这与C语言的 `strstr()` 以及 Java的 `indexOf()` 定义相符。

#### 解题过程

1.暴力求解不写了

2.KMP算法 推荐看[KMP算法](https://subetter.com/algorithm/kmp-algorithm.html)

我自己也没这么明白，先记录下。

``` golang
func strStr(haystack string, needle string) int {
	if needle == "" {
		return 0
	}
	next := make([]int, len(needle))
	next[0] = -1
	i, j := 0, -1
	for i < len(needle)-1 {
		if j == -1 || needle[i] == needle[j] {
			i++
			j++
			next[i] = j
		} else {
			j = next[j]
		}
	}

	m := len(haystack)
	n := len(needle)
	i, j = 0, 0
	for i < m && j < n {
		if j == -1 || haystack[i] == needle[j] {
			i++
			j++
		} else {
			j = next[j]
		}
	}
	if j == n {
		return i - j
	}
	return -1
}
```


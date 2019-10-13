---
title: "Leetcode算法 14.最长公共前缀"
date: 2019-10-13T17:49:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

编写一个函数来查找字符串数组中的最长公共前缀。

如果不存在公共前缀，返回空字符串 `""`。

**示例1:**
``` golang
输入: ["flower","flow","flight"]
输出: "fl"
```

**示例2:**
``` golang
输入: ["dog","racecar","car"]
输出: ""
解释: 输入不存在公共前缀。
```

**说明:**
所有输入只包含小写字母 `a-z` 。

#### 解题过程

首先我们可以两两比较，保留最长的就是前缀。

``` golang
func longestCommonPrefix(strs []string) string {
	if len(strs) == 0 {
		return ""
	}
	ans := strs[0]
	
	for i := 1; i < len(strs); i++ {
		j := 0
		for ; j < len(ans) && j < len(strs[i]); j++ {
			if ans[j] != strs[i][j] {
				break
			}
		}
		
		if ans == "" {
			return ""
		}
		ans = ans[0:j]
	}
	return ans
}
```
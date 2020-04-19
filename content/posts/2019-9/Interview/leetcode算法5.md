---
title: "Leetcode算法 5.最长回文子串"
date: 2019-09-14T17:49:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

### 最长回文子串

给定一个字符串 `s`，找到 `s `中最长的回文子串。你可以假设 `s` 的最大长度为 `1000`。

**示例1:**
``` go
输入: "babad"
输出: "bab"
注意: "aba" 也是一个有效答案。
```

**示例2:**
``` go
输入: "cbbd"
输出: "bb"
```

**中心扩展算法**
空间复杂度`O(1)`
时间复杂度`O(n^2)`

首先，我们观察这个几个字符`a`,`aa`,`bab`,`baab`,他们是有一个中心点`a`或`aa`，当我们从中心点出发，往两边扩展可以查询是否满足回文。
因此,首先我们要估计中心点的个数，便于我们遍历。通过上面的例子，我们明确了中心只有两种，一个字符或两个字符。
我们我们针对回文来说，当我有n个字符时，这`n`个字符都可以是中心点,因此一个字符的中心点个数为`n`
同理，当中心点为两个字符时，我们应该有`n - 1`个中心(避免部分同学不理解，这里解释为什么是n-1，当我们中心是2个字符时，我们每次计算时都会减去一个字符)



``` go
func longestPalindrome(s string) string {
    if s == "" || len(s) < 1 {
		return ""
	}

	start := 0
	end := 0

	for i := 0; i < len(s); i++ {
		// 这里是比较i,i，也就是一个中心点的情况
		len1 := expandAroundCenter(s, i, i)
		// 这里比较的是 i,i+1，也就是两个中心点的情况
		len2 := expandAroundCenter(s, i, i+1)
		length := math.Max(float64(len1), float64(len2))
		if int(length) > (end - start) {
            // 当length为奇数是时，表示中心点个数为一个字符，当lengt为偶数时，中心点个数为两个因此要做
            // 以下操作
            // 奇数计算的start和end相同
            // 偶数计算的，start+1 = end
			start = i - int((length-1)/2)
			end = i + int(length/2)
		}
	}

	return s[start : end+1]
}

func expandAroundCenter(s string, left, right int) int {
	L := left
	R := right

	for L >= 0 && R < len(s) && s[L] == s[R] {
		L--
		R++
	}
	return R - L - 1
}
```
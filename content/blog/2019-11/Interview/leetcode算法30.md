---
title: "Leetcode算法 30.串联所有单词的子串"
date: 2019-11-19T20:30:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定一个字符串 `s` 和一些长度相同的单词 `words`。找出 `s` 中恰好可以由 `words` 中所有单词串联形成的子串的起始位置。


注意子串要与 `words` 中的单词完全匹配，中间不能有其他字符，但不需要考虑 `words` 中单词串联的顺序。

**示例1:**

``` golang
输入：
  s = "barfoothefoobarman",
  words = ["foo","bar"]
输出：[0,9]
解释：
从索引 0 和 9 开始的子串分别是 "barfoo" 和 "foobar" 。
输出的顺序不重要, [9,0] 也是有效答案。
```

**示例2:**

``` golang
输入：
  s = "wordgoodgoodgoodbestword",
  words = ["word","good","best","word"]
输出：[]
```

#### 解题过程

主要思路是，先把words的字符串统计出来，然后通过遍历s，通过wordsLen区间来查找匹配的字符串。

``` golang
func findSubstring(s string, words []string) []int {
	wordsLen := len(words)
	sLen := len(s)
	ret := make([]int, 0)
	if wordsLen == 0 {
		return ret
	}

	wordsMap := make(map[string]int)
	for i := 0; i < wordsLen; i++ {
		wordsMap[words[i]]++
	}

	wordLen := len(words[0])
	for i := 0; i < wordLen; i++ {
		winMap := make(map[string]int)

		cnt := 0
		left, right := i, i
		for left <= right && right <= sLen-wordLen {

			var subStr string
			if right+wordLen == sLen {
				subStr = s[right:]
			} else {
				subStr = s[right : right+wordLen]
			}

			if _, ok := wordsMap[subStr]; !ok {
				left, right = right+wordLen, right+wordLen
				cnt = 0
				winMap = make(map[string]int)
				continue
			}

			if _, ok := winMap[subStr]; !ok {
				winMap[subStr] = 1
			} else {
				winMap[subStr]++
			}
			right += wordLen
			cnt++

			for winMap[subStr] > wordsMap[subStr] {
				winMap[s[left:left+wordLen]]--
				cnt--
				left += wordLen
			}

			if cnt == wordsLen {
				ret = append(ret, left)
			}
		}
	}

	return ret
}
```
---
title: "Leetcode算法 22.括号生成"
date: 2019-10-31T22:00:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---


#### 简介

给出 n 代表生成括号的对数，请你写出一个函数，使其能够生成所有可能的并且有效的括号组合。

例如，给出 n = 3，生成结果为：

``` golang
[
  "((()))",
  "(()())",
  "(())()",
  "()(())",
  "()()()"
]
```

#### 解题过程

如果我们递归所有的结果，然后判断是否满足和是否重复，这样时间复杂度和空间复杂度都很高。因此，我们采用其他方式。

**方法一:回溯法**

回溯是要在当前满足的情况下，才往下递归，因此，我们可以通过跟踪到目前为止放置的左括号和右括号的数目来做到这一点。

如果我们还剩一个位置，我们可以开始放一个左括号。 如果它不超过左括号的数量，我们可以放一个右括号。

``` golang

func generateParenthesis(n int) []string {
	res := make([]string, 0)
	gen(0, 0, n, &res, "")
	return res
}

func gen(left, right, n int, res *[]string, str string) {
	if left == right && left == n {
		*res = append(*res, str)
	}
	if left < n {
		gen(left+1, right, n, res, str+"(")
	}
	if right < left && right < n {
		gen(left, right+1, n, res, str+")")
	}
}

```

**方法二：动态规划**

该方法是leetcode评论区发现的。

**反思:**
首先，面向小白：什么是动态规划？在此题中，动态规划的思想类似于数学归纳法，当知道所有 `i<n` 的情况时，我们可以通过某种算法算出 `i=n `的情况。

本题最核心的思想是，考虑 `i=n `时相比 `n-1` 组括号增加的那一组括号的位置。

**思路:**

当我们清楚所有 `i<n` 时括号的可能生成排列后，对与 `i=n` 的情况，我们考虑整个括号排列中最左边的括号。
它一定是一个左括号，那么它可以和它对应的右括号组成一组完整的括号 `"( )"`，我们认为这一组是相比 n-1 增加进来的括号。

那么，剩下 `n-1` 组括号有可能在哪呢？

**【这里是重点，请着重理解】**

剩下的括号要么在这一组新增的括号内部，要么在这一组新增括号的外部（右侧）。

既然知道了 `i<n` 的情况，那我们就可以对所有情况进行遍历：

"(" + 【i=p时所有括号的排列组合】 + ")" + 【i=q时所有括号的排列组合】

其中 `p + q = n-1`，且 `p q` 均为非负整数。

事实上，当上述 `p` 从 `0` 取到 `n-1`，`q` 从 `n-1` 取到 `0` 后，所有情况就遍历完了。

注：上述遍历是没有重复情况出现的，即当 `(p1,q1)≠(p2,q2)`时，按上述方式取的括号组合一定不同。


``` golang
func generateParenthesis(n int) []string {
	result := make([][]string, 0)
	if n == 0 {
		return result[0]
	}
	list0 := make([]string, 0)
	list0 = append(list0, "")
	result = append(result, list0)

	list1 := make([]string, 0)
	list1 = append(list1, "()")
	result = append(result, list1)

	for i := 2; i <= n; i++ {
		tmp := make([]string, 0)
		for j := 0; j < i; j++ {

			str1 := result[j]
			str2 := result[i-1-j]

			for _, v1 := range str1 {
				for _, v2 := range str2 {
					e1 := "(" + v1 + ")" + v2
					tmp = append(tmp, e1)
				}
			}
		}
		result = append(result, tmp)
	}
	return result[n]

}
```

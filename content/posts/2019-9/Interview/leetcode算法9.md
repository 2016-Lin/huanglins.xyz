---
title: "Leetcode算法 9.回文数"
date: 2019-09-20T17:49:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

判断一个整数是否是回文数。回文数是指正序（从左向右）和倒序（从右向左）读都是一样的整数。

**示例1:**

``` go
输入: 121
输出: true
```

**示例2:**
``` go
输入: -121
输出: false
解释: 从左向右读, 为 -121 。 从右向左读, 为 121- 。因此它不是一个回文数。
```
**示例3:**

``` go
输入: 10
输出: false
解释: 从右向左读, 为 01 。因此它不是一个回文数。
```

**进阶:**
你能不将整数转为字符串来解决这个问题吗？


#### 解题思路

我们可以将x折半，然后比较这个两个数的大小。
例如
``` go
123454321 折半后为 12345和1234，因为x为奇数，所有将前面的数除于10后，两个数相等，因此是回文
12344321 同样，偶数也可通过这样来判断。只不过没有除于10

```

``` go
func isPalindrome(x int) bool {
	// 当x为负数或者，个位数为0的话，那么这个数一定不是回文数
	if x < 0 || (x != 0 && x%10 == 0) {
		return false
	}

	num := 0

	// x <= num
	for x > num {
		num = num*10 + x%10
		x /= 10
	}
	return x == num || x == num/10
}

```

第二种，将x转变成字符串

``` go

func isPalindrome(x int) bool {
	// 当x为负数或者，个位数为0的话，那么这个数一定不是回文数
	if x < 0 || (x != 0 && x%10 == 0) {
		return false
	}

	str := strconv.Itoa(x)
	fmt.Println(str)
	str2 := Reverse(str)
	return  str2 == str
}
// 字符串反转
func reverse(s string) string {
	s1 := []rune(s)
	for i := 0; i < len(s1)/2; i++ {
		tmp := s1[i]
		s1[i] = s1[len(s1)-1-i]
		s1[len(s1)-1-i] = tmp
	}
	return string(s1)
}
```
---
title: "Leetcode算法 6.Z 字形变换"
date: 2019-09-16T17:49:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介：
将一个给定字符串根据给定的行数，以从上往下、从左到右进行 Z 字形排列。
比如输入字符串为 `"LEETCODEISHIRING"` 行数为 3 时，排列如下：
``` go
L   C   I   R
E T O E S I I G
E   D   H   N
```
之后，你的输出需要从左往右逐行读取，产生出一个新的字符串，比如：`"LCIRETOESIIGEDHN"`。
请你实现这个将字符串进行指定行数变换的函数：
``` go
string convert(string s, int numRows);
```
**示例1:**
``` go
输入: s = "LEETCODEISHIRING", numRows = 3
输出: "LCIRETOESIIGEDHN"
```

**示例2:**
``` go
输入: s = "LEETCODEISHIRING", numRows = 4
输出: "LDREOEIIECIHNTSG"
解释:

L     D     R
E   O E   I I
E C   I H   N
T     S     G
```




#### 第一种：按行排序
**思路:**

这种方法是，首先我们初始化numRows行的一个切片，用来存放每一行的数据

我们通过迭代字符串来找到该字符所在的行.通过下面的示意图，我们可以清楚的了解算法的过程。

![示意图](/images/blog/2019/算法6_1.png)

``` go
func convert(s string, numRows int) string {
    if numRows == 1 {
		return s
	}
	// 最大行
	max := int(math.Max(float64(numRows), float64(len(s))))
	rows := make([]string, max, max)

	// 行
	curRow := 0
	// 用来控制方向
	goingDown := false

	for _,v := range s {
		rows[curRow] = rows[curRow] + string(v)
		// 当行到达行尾或行首时，跳转方向
		if curRow == 0 || curRow == numRows-1 {
			goingDown = !goingDown
		}

		if goingDown {
			curRow += 1
		} else {
			curRow += -1
		}
	}
	str := ""
	for _,v := range rows {
		str += v
	}
	return str
}
```
#### 第二种：按行访问
**思路:**

`s = "LEETCODEISHIRING", numRows = 4`

我们可以发现，除开第一行和最后一行，中间的行数为`numRows -2 = 2`,间隔为`2*numRows -2 =6`


``` go

LEET  CO   DEIS   HI     RING
0-3  4-5   6-9   10-11  12-15

L     D     R
E   O E   I I
E C   I H   N
T     S     G

0     6     12 
1   5 7  11 13 
2 4   8 10  14 
3     9     15 
```

``` go
func convert(s string,numRows int) string {

	if numRows == 1 || numRows>=len(s){
		return s
	}

	res := make([]byte,len(s))
	step := 2*numRows-2
	index := 0

	for i:=0;i<numRows;i++{

		for j:=0;j+i<len(s);j+=step{
			res[index] = s[j+i]
			index++
			if i!=0 && i != numRows-1 && j+step-i<len(s){
				res[index] = s[j+step-i]
				index++
			}
		}
	}
	return string(res)
}
```
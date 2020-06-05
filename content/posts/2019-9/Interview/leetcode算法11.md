---
title: "Leetcode算法 11.盛最多水的容器"
date: 2019-09-26T17:49:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定 n 个非负整数 a1，a2，...，an，每个数代表坐标中的一个点 (i,·a_i ) 。在坐标内画 n 条垂直线，垂直线 i 的两个端点分别为 (i, a_i) 和 (i, 0)。找出其中的两条线，使得它们与 x 轴共同构成的容器可

**注意:** 你不能倾斜容器，且 n 的值至少为 2。

![图片](/images/blog/sf/question_11.jpg)

图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。

**示例:**

``` go
输入: [1,8,6,2,5,4,8,3,7]
输出: 49
```

#### 解题思路

##### 双指针法：

这种方法背后的思路在于，两线段之间形成的区域总是会受到其中较短那条长度的限制。此外，两线段距离越远，得到的面积就越大。

通过下面的例子来说明
```
1 8 6 2 5 4 8 3 7
```
![图片](/images/blog/sf/11_Slide1.png)
![图片](/images/blog/sf/11_Slide2.png)
![图片](/images/blog/sf/11_Slide3.png)
![图片](/images/blog/sf/11_Slide4.png)
![图片](/images/blog/sf/11_Slide5.png)
![图片](/images/blog/sf/11_Slide6.png)
![图片](/images/blog/sf/11_Slide7.png)
![图片](/images/blog/sf/11_Slide8.png)

&nbsp;&nbsp;&nbsp;&nbsp;最初我们考虑由最外围两条线段构成的区域。现在，为了使面积最大化，我们需要考虑更长的两条线段之间的区域。如果我们试图将指向较长线段的指针向内侧移动，矩形区域的面积将受限于较短的线段而不会获得任何增加。但是，在同样的条件下，移动指向较短线段的指针尽管造成了矩形宽度的减小，但却可能会有助于面积的增大。因为移动较短线段的指针会得到一条相对较长的线段，这可以克服由宽度减小而引起的面积减小。


``` go
func maxArea(height []int) int {
	n := len(height)
	capacity := 0

	i := 0
	j := n - 1

	w := 0
	h := 0

	for i < j {
		h = j - i
		if height[i] > height[j] {
			w = height[j]
			j--
		} else {
			w = height[i]
			i++
		}
		c := h * w
		if c > capacity {
			capacity = c
		}
	}
	return capacity
}
```

[参考leetcode题解](https://leetcode-cn.com/problems/container-with-most-water/solution/sheng-zui-duo-shui-de-rong-qi-by-leetcode/)
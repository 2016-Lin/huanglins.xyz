---
title: "Leetcode算法 19.删除链表的倒数第N个节点"
date: 2019-10-25T10:30:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定一个链表，删除链表的倒数第 n 个节点，并且返回链表的头结点。

**示例:**

``` golang
给定一个链表: 1->2->3->4->5, 和 n = 2.

当删除了倒数第二个节点后，链表变为 1->2->3->5.
```

**说明:**

给定的 n 保证是有效的。

**进阶：**

你能尝试使用一趟扫描实现吗？

#### 解题过程

通常，我们的想法是遍历一遍链表，记录长度，通过n和长度的关系，找到倒数位置为n的数，删除。

但是，如果我们要使用一趟扫描呢。

一般，遍历一个区间时，我们通常会采用双指针来做，这道题也是一样，因为是求倒数位数为n的数。通常有个间距。


``` golang
func removeNthFromEnd(head *ListNode, n int) *ListNode {
	new := &ListNode{}
	new.Next = head

	pre := new
	front := new

	// 设置一个区间，pre和f的间距为n
	for i := 1; i <= n; i++ {
		pre = pre.Next
	}

	// 通过移动双指针，判断最后一个指针后面是否还有数
	for pre.Next != nil {
		pre = pre.Next
		front = front.Next
	}
	// 找到倒数的数，进行删除
	front.Next = front.Next.Next
	// 返回头节点
	return new.Next
}
```
---
title: "Leetcode算法 24.两两交换链表中的节点"
date: 2019-11-02T20:00:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定一个链表，两两交换其中相邻的节点，并返回交换后的链表。

**你不能只是单纯的改变节点内部的值**，而是需要实际的进行节点交换。

**示例:**
``` golang
给定 1->2->3->4, 你应该返回 2->1->4->3.
```

#### 解题过程

``` golang
func swapPairs(head *ListNode) *ListNode {

	if head == nil {
		return head
	}
	// 头节点
	front := &ListNode{}
	front.Next = head

	// 坐标点
	tmp := front
	// 前节点
	f := head
	// 后节点
	t := head.Next

	for f != nil && t != nil {
		tmp.Next = t
		f.Next = t.Next
		t.Next = f
		tmp = f

		if tmp.Next == nil {
			return front.Next
		} else {
			f = tmp.Next
			t = tmp.Next.Next
		}
	}
	return front.Next
}

```
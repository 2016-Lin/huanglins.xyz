---
title: "Leetcode算法 25.K 个一组翻转链表"
date: 2019-11-03T18:00:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给你一个链表，每 k 个节点一组进行翻转，请你返回翻转后的链表。

k 是一个正整数，它的值小于或等于链表的长度。

如果节点总数不是 k 的整数倍，那么请将最后剩余的节点保持原有顺序。

**示例:**

给定这个链表：`1->2->3->4->5`

当 k = 2 时，应当返回: `2->1->4->3->5`

当 k = 3 时，应当返回: `3->2->1->4->5`

**说明:**

- 你的算法只能使用常数的额外空间。

- **你不能只是单纯的改变节点内部的值**，而是需要实际的进行节点交换。

#### 解题过程

首先，我们分割出k的长度的链表，然后反转字符串。

``` golang

type ListNode struct {
	Val  int
	Next *ListNode
}

func reverseKGroup(head *ListNode, k int) *ListNode {
	if head == nil {
		return head
	}

	if k <= 1 {
		return head
	}

	front := &ListNode{}
	front.Next = head

	pre := front
	end := front

	for end.Next != nil {
		for i := 0; i < k && end != nil; i++ {
			end = end.Next
		}
		if end == nil {
			break
		}

		start := pre.Next
		next := end.Next
		end.Next = nil

		pre.Next = reverse(start)
		start.Next = next

		pre = start
		end = pre
	}
	return front.Next
}

// 反转字符串
func reverse(head *ListNode) *ListNode {
	var curr, pre *ListNode
	pre = nil
	curr = head

	for curr != nil {
		next := curr.Next
		curr.Next = pre
		pre = curr
		curr = next
	}
	return pre
}
```


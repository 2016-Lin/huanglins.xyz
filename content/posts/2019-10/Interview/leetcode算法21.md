---
title: "Leetcode算法 21.合并两个有序链表"
date: 2019-10-28T12:30:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

将两个有序链表合并为一个新的有序链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。

**示例:**

``` golang

输入：1->2->4, 1->3->4
输出：1->1->2->3->4->4
```


#### 解题过程


``` golang 
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
    tmp := &ListNode{}
	f := tmp

	for l1 != nil && l2 != nil {
		if l1.Val > l2.Val {
			tmp.Next = l2
			l2 = l2.Next
		} else {
			tmp.Next = l1
			l1 = l1.Next
		}
		tmp = tmp.Next
	}

	if l1 != nil {
		tmp.Next = l1
	}

	if l2 != nil {
		tmp.Next = l2
	}
	return f.Next
}

```
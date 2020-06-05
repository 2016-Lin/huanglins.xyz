---
title: "Leetcode算法 23.合并K个排序链表"
date: 2019-11-02T10:00:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

合并 k 个排序链表，返回合并后的排序链表。请分析和描述算法的复杂度。

**示例:**
``` golang
输入:
[
  1->4->5,
  1->3->4,
  2->6
]
输出: 1->1->2->3->4->4->5->6
```

#### 解题过程

**方法一：暴力求解**

``` golang

type ListNode struct {
	Val  int
	Next *ListNode
}

func mergeKLists(lists []*ListNode) *ListNode {
	front := &ListNode{Val: math.MinInt64}
	tail := front

	for index := range lists {

		for list := lists[index]; list != nil; list = list.Next {

			node := list
			node.Next = nil

			if tail.Val <= node.Val {
				tail.Next = node
				tail = node
			} else {
				for l, f := front.Next, front.Next; l != nil; l = l.Next {
					if l.Val >= node.Val {
						if l == f {
							front.Next = node
							node.Next = l
						} else {
							f.Next = node
							node.Next = l
						}
						break
					} else {
						f = l
					}
				}
			}
		}
	}
	return front.Next
}
```

**方法二：归并**

``` golang
type ListNode struct {
	Val  int
	Next *ListNode
}

func mergeKLists(lists []*ListNode) *ListNode {
	if len(lists) == 0 {
		return nil
	}
	if len(lists) == 1 {
		return lists[0]
	}
	if len(lists) == 2 {
		return mergeTwoLists(lists[0], lists[1])
	}
	k := len(lists) / 2

	return mergeKLists([]*ListNode{mergeKLists(lists[:k]), mergeKLists(lists[k:])})
}

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
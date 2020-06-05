---
title: "Leetcode算法 2.两数相加"
date: 2019-09-14T10:49:50+08:00
draft: false
toc: true
categories: ["Leetcode算法"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

### 两数相加

给出两个 非空 的链表用来表示两个非负的整数。其中，它们各自的位数是按照 逆序 的方式存储的，并且它们的每个节点只能存储 一位 数字。

如果，我们将这两个数相加起来，则会返回一个新的链表来表示它们的和。

您可以假设除了数字 0 之外，这两个数都不会以 0 开头。

**示例：**
``` go
输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
输出：7 -> 0 -> 8
原因：342 + 465 = 807
```

首先两个数通过链表来存储，每个数的位数不确定，并且需要注意进位。

``` go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
 if l1 == nil || l2 == nil {
		return &ListNode{}
	}

	front := l1
	pre := front
	after := l2
    // 进位
	z := 0

	// 把相同位的的值进行相加
	for {
		sum := front.Val + after.Val + z
		z = sum / 10
		s := sum % 10
		front.Val = s
		// 保留前一个结点
		pre = front
		front = front.Next
		after = after.Next
		if front == nil || after == nil {
			break
		}
	}

	// 如果第一个位数是长的
	if front != nil {
		if z != 0 {
			for front != nil {
				sum := front.Val + z
				z = sum / 10
				s := sum % 10
				front.Val = s
				pre = front

				front = front.Next
				if z == 0 {
					break
				}
			}
		}
	}

	// 如果第二个位数是长的
	if after != nil {
		for after != nil {
			sum := after.Val + z
			z = sum / 10
			s := sum % 10

			pre.Next = &ListNode{}
			pre = pre.Next
			pre.Val = s

			after = after.Next
		}
	}

	// 最后判断是否还有进位
	if z != 0 {
		pre.Next = &ListNode{}
		pre = pre.Next
		pre.Val = z
	}
	return l1
}
```
![结果](/images/blog/2019/算法2_1.png)


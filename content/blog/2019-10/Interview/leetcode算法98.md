---
title: "Leetcode算法 98.验证二叉搜索树"
date: 2019-10-16T11:30:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法"]
toc: true
---

#### 简介

给定一个二叉树，判断其是否是一个有效的二叉搜索树。

假设一个二叉搜索树具有如下特征：

- 节点的左子树只包含**小于**当前节点的数
- 节点的右子树只包含**大于**当前节点的数。
- 所有左子树和右子树自身必须也是二叉搜索树。

**示例1:**

``` golang
输入:
    2
   / \
  1   3
输出: true
```

**示例2:**

``` golang
输入:
    5
   / \
  1   4
     / \
    3   6
输出: false
解释: 输入为: [5,1,4,null,null,3,6]。
     根节点的值为 5 ，但是其右子节点值为 4 。
```


#### 解题过程

首先，了解到二叉收索树，我们需要遍历整个树，检查 `node.right.val > node.val` 和
`node.left.val < node.val` 对每个结点是否成立。

![二叉树](/images/blog/2019-10/sf_98_1.png)

但是这种方法并不总是正确。不仅右子结点要大于该节点，整个右子树的元素都应该大于该节点。例如:
![二叉树](/images/blog/2019-10/sf_98_2.png)

因此，我们可以使用递归来实现，首先将结点的值与上界和下界（如果有）比较。然后，对左子树和右子树递归进行该过程。

![图片](/images/blog/2019-10/sf_98_3.png)
![图片](/images/blog/2019-10/sf_98_4.png)
![图片](/images/blog/2019-10/sf_98_5.png)
![图片](/images/blog/2019-10/sf_98_6.png)

``` golang 
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func isValidBST(root *TreeNode) bool {
	return helper(root, nil, nil)
}

func helper(node *TreeNode, lower, upper interface{}) bool {
	if node == nil {
		return true
	}
	
	val := node.Val

	if lower != nil && val <= lower.(int){
		return false
	}

	if upper != nil && val >= upper.(int) {
		return false
	}

	if !helper(node.Right,val,upper) {
		return false
	}

	if !helper(node.Left,lower,val) {
		return false
	}
	
	return true
}

```

**复杂度分析**

- 时间复杂度 : O(N)。每个结点访问一次。
- 空间复杂度 : O(N)。我们跟进了整棵树。

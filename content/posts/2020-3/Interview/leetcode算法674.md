---
title: "Leetcode算法 674. 最长连续递增序列"
date: 2020-03-13T11:10:50+08:00
draft: false
toc: true
categories: ["技术"]
series: ["Leetcode算法"]
tags: ["go","面试","算法","动态规划"]
toc: true
---

#### 674. 最长连续递增序列

给定一个未经排序的整数数组，找到最长且连续的的递增序列。

**示例1：**

输入: [1,3,5,4,7]
输出: 3
解释: 最长连续递增序列是 [1,3,5], 长度为3。
尽管 [1,3,5,7] 也是升序的子序列, 但它不是连续的，因为5和7在原数组里被4隔开。


**示例2：**

输入: [2,2,2,2,2]
输出: 1
解释: 最长连续递增序列是 [2], 长度为1。

**注意：**数组长度不会超过10000。


#### 解题

``` golang

func findLengthOfLCIS(nums []int) int {
    result := 0
    n := len(nums)
    if n == 0 {
        return 0
    }
    
    f := make([]int,2)
    
    var now,old int
    
    for i := 0; i < n;i++{
        old = now
        now = 1 - now
        f[now] = 1
        if i > 0 && nums[i -1] < nums[i]{
            f[now] = f[old] + 1
        }
        if f[now] > result {
            result = f[now]
        }
    }
    return result
}
```


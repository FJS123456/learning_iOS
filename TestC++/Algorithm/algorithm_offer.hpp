//
//  algorithm_offer.hpp
//  TestC++
//
//  Created by 符吉胜 on 2020/4/4.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#ifndef algorithm_offer_hpp
#define algorithm_offer_hpp

#include <stdio.h>
#include "SingleList.hpp"
#include "BinaryTree.hpp"
#include <stack>

using namespace std;

//两个栈实现一个队列
template <typename T> class CQueue {
public:
    CQueue(void);
    ~CQueue(void);
    void appendTail(const T &node);
    T deleteHead();
    
private:
    std::stack<T> stack1;
    std::stack<T> stack2;
};

//在二维数组中查找某个数
bool find_aNumberFromMatrix(int *matrix, int rows, int colums, int number);

//替换空格
void replaceBlank(char originStr[], int length);

//链表反向输出
void printListReversingly(ListNode *pHead);

//根据前中序列构造二叉树
BinaryTreeNode *construct(int *preOrder, int *inOrder, int length);

//旋转数组中的最小数字
int findMixFromRotateArray(int *numbers, int length);

//斐波那契数列非递归解法
long long fibonacci(unsigned n);

//二进制的个数
int numberOf1(int n);

//打印1到最大的n位数
void print1ToMaxOfNDigits(int n);

//在O(1)时间内从单链表中删除一个节点
void deleteNodeFromSingleList(ListNode **pListHead, ListNode *pToBeDeleted);

//求最大子序列的和
int maxSubSumOfSequece(const vector<int> &a);

//链表中倒数第K个节点
ListNode *findKthToTail(ListNode *pListHead, unsigned int k);

//反转链表,并返回反转后的头节点
ListNode *reverseList(ListNode *pHead);

#endif /* algorithm_offer_hpp */

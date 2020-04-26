//
//  algorithm_offer.cpp
//  TestC++
//
//  Created by 符吉胜 on 2020/4/4.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#include "algorithm_offer.hpp"
#include <vector>

bool find_aNumberFromMatrix(int *matrix, int rows, int colums, int number) {
    bool found = false;
    
    if (matrix != NULL && rows > 0 && colums > 0) {
        int row = 0;
        int colum = colums - 1;
        while (row < rows && colum >= 0) {
            int currentNumber = matrix[row * colums + colum];
            if (currentNumber == number) {
                found = true;
                break;
            } else if (currentNumber > number) {
                --colum;
            } else {
                ++row;
            }
        }
    }
    
    return found;
}

void replaceBlank(char originStr[], int length) {
    if (originStr == NULL || length <= 0) {
        return;
    }
    
    char waitToReplaceChar = ' ';

    int originalLength = 0;
    int numberOfBlank = 0;
    int i = 0;
    while (originStr[i] != '\0') {
        ++originalLength;
        if (originStr[i] == waitToReplaceChar) {
            ++numberOfBlank;
        }
        ++i;
    }
    
    int newLength = originalLength + 2 * numberOfBlank;
    if (newLength > length) {
        return;
    }
    
    int indexOfOriginal = originalLength;
    int indexOfNew = newLength;
    while (indexOfOriginal >= 0 && indexOfNew > indexOfOriginal) {
        if (originStr[indexOfOriginal] == waitToReplaceChar) {
            originStr[indexOfNew--] = '0';
            originStr[indexOfNew--] = '2';
            originStr[indexOfNew--] = '%';
        } else {
            originStr[indexOfNew--] = originStr[indexOfOriginal];
        }
        
        --indexOfOriginal;
    }
}

void printListReversingly(ListNode *pHead) {
    std::stack<ListNode *> nodes;
    
    ListNode *pNode = pHead;
    while (pNode != NULL) {
        nodes.push(pNode);
        pNode = pNode->m_pNext;
    }
    
    while (!nodes.empty()) {
        pNode = nodes.top();
        printf("%d\t",pNode->m_nValue);
        nodes.pop();
    }
}

BinaryTreeNode *constructCore(int *startPreOrder, int *endPreOrder, int *startInOrder, int *endInOrder) {
    //前序遍历序列的第一个数字是根节点的值
    int rootValue = startPreOrder[0];
    BinaryTreeNode *root = new BinaryTreeNode();
    root->m_nValue = rootValue;
    root->m_pLeft = root->m_pRight = NULL;
    
    if (startPreOrder == endPreOrder) {
        if (startInOrder == endInOrder && *startPreOrder == *startInOrder) {
            return root;
        } else {
            printf("Invalid input\n");
        }
    }
    
    //在中序遍历中找到根节点的值
    int *rootInOrder = startInOrder;
    while (rootInOrder <= endInOrder && *rootInOrder != rootValue) {
        ++rootInOrder;
    }
    if (rootInOrder == endInOrder && *rootInOrder != rootValue) {
        printf("Invalid input\n");
    }
    
    size_t leftLength = rootInOrder - startInOrder;
    int *leftPreOrderEnd = startPreOrder + leftLength;
    
    if (leftLength > 0) {
        //构建左子树
        root->m_pLeft = constructCore(startPreOrder + 1, leftPreOrderEnd, startInOrder, rootInOrder - 1);
    }
    
    if (leftLength < endPreOrder - startPreOrder) {
        //构建右子树
        root->m_pRight = constructCore(leftPreOrderEnd + 1, endPreOrder, rootInOrder + 1, endInOrder);
    }
    

    return root;
}

BinaryTreeNode *construct(int *preOrder, int *inOrder, int length) {
    if (preOrder == NULL || inOrder == NULL || length <= 0) {
        return NULL;
    }
    
    return constructCore(preOrder, preOrder + length - 1, inOrder, inOrder + length - 1);
}

//两个栈实现一个队列
template<typename T> void CQueue<T>::appendTail(const T &element) {
    stack1.push(element);
}

template<typename T> T CQueue<T>::deleteHead() {
    if (stack2.size() <= 0) {
        while (stack1.size() > 0) {
            T &data = stack1.top();
            stack1.pop();
            stack2.push(data);
        }
    }
    
    if (stack2.size() == 0) {
//        printf("queue is empty");
        throw "queue is empty";
    }
    
    T head = stack2.top();
    stack2.pop();
    
    return head;
}

int minInOrder(int *numbers, int index1, int index2) {
    int result = numbers[index1];
    for (int i = index1 + 1; i < index2; ++i) {
        if (result > numbers[i]) {
            result = numbers[i];
        }
    }
    return result;
}

int findMixFromRotateArray(int *numbers, int length) {
    if (numbers == NULL  || length <= 0) {
        throw "invalid input";
    }
    
    int index1 = 0;
    int index2 = length - 1;
    //如果最小值正好在数组的首位
    int indexMid = index1;
    while (numbers[index1] >= numbers[index2]) {
        if (index2 - index1 == 1) {
            indexMid = index2;
            break;
        }
        
        indexMid = (index1 + index2) / 2;
        
        if (numbers[index1] == numbers[index2] && numbers[indexMid] == numbers[index2]) {
            return minInOrder(numbers, index1, index2);
        }
        
        if (numbers[indexMid] >= numbers[index1]) {
            index1 = indexMid;
        } else if (numbers[indexMid] <= numbers[index2]) {
            index2 = indexMid;
        }
    }
    
    return numbers[indexMid];
}

long long fibonacci(unsigned n) {
    int result[2] = {0, 1};
    if (n < 2) {
        return result[n];
    }
    
    long long first = 0;
    long long second = 1;
    
    for (int i = 2; i <= n; ++i) {
        long long temp = first + second;
        first = second;
        second = temp;
    }
    
    return second;
}

int numberOf1(int n) {
    int count = 0;
    
    while (n) {
        ++count;
        n = (n - 1) & n;
    }
    
    return count;
}

void printNumber(char *number) {
    bool isBeginning0 = true;
    size_t nLength = strlen(number);
    
    for (size_t i = 0; i < nLength; ++i) {
        if (isBeginning0 && number[i] != '0') {
            isBeginning0 = false;
        }
        
        if (!isBeginning0) {
            printf("%c", number[i]);
        }
    }
    
    printf("\t");
    
}

void print1ToMaxOfNDigitsRecursively(char *number, int length, int index) {
    if (index == length - 1) {
        printNumber(number);
        return;
    }
    
    for (int i = 0; i < 10; ++i) {
        number[index + 1] = i + '0';
        print1ToMaxOfNDigitsRecursively(number, length, index + 1);
    }
    printf("\n");
    
    delete [] number;
}

void print1ToMaxOfNDigits(int n) {
    if (n <= 0) return;
    
    char *number = new char[n + 1];
    number[n] = '\0';
    for (int i = 0; i < 10; ++i) {
        number[0] = i + '0';
        print1ToMaxOfNDigitsRecursively(number, n, 0);
    }
}

void deleteNodeFromSingleList(ListNode **pListHead, ListNode *pToBeDeleted) {
    if (pListHead == NULL || pToBeDeleted == NULL) {
        return;
    }
    
    //要删除的节点不是尾节点
    if (pToBeDeleted->m_pNext != NULL) {
        ListNode *pNextNode = pToBeDeleted->m_pNext;
        pToBeDeleted->m_nValue = pNextNode->m_nValue;
        pToBeDeleted->m_pNext = pNextNode->m_pNext;
        
        delete pNextNode;
        pNextNode = NULL;
    }
    //链表只有一个节点
    else if (*pListHead == pToBeDeleted) {
        delete pToBeDeleted;
        pToBeDeleted = NULL;
        *pListHead = NULL;
    }
    //被删除的节点是尾结点
    else {
        ListNode *pNode = *pListHead;
        while (pNode->m_pNext != pToBeDeleted) {
            pNode = pNode->m_pNext;
        }
        pNode->m_pNext = NULL;
        delete pToBeDeleted;
        pToBeDeleted = NULL;
    }
}

int maxSubSumOfSequece(const vector<int> &a) {
    if (a.size() <= 0) {
        throw "vector is empty!!!";
        return -1;
    }
    
    int maxSum = 0, thisSum = 0;
    for (int j = 0; j < a.size(); ++j) {
        thisSum += a[j];
        if (thisSum > maxSum) {
            maxSum = thisSum;
        } else if (thisSum < 0) {
            thisSum = 0;
        }
    }
    
    return maxSum;
}

ListNode *findKthToTail(ListNode *pListHead, unsigned int k) {
    if (pListHead == NULL || k == 0) {
        return NULL;
    }
    
    ListNode *pAHead = pListHead;
    ListNode *pBehind = NULL;
    for (unsigned int i = 0; i < k - 1; ++i) {
        if (pAHead->m_pNext != NULL) {
            pAHead = pAHead->m_pNext;
        } else {
            return NULL;
        }
    }
    
    pBehind = pListHead;
    while (pAHead->m_pNext != NULL) {
        pAHead = pAHead->m_pNext;
        pBehind = pBehind->m_pNext;
    }
    
    return pBehind;
}

ListNode *reverseList(ListNode *pHead) {
    
    ListNode *pReverseHead = NULL;
    ListNode *pNode = pHead;
    ListNode *pPrev = NULL;
    while (pNode != NULL) {
        ListNode *pNext = pNode->m_pNext;
        if (pNext == NULL) {
            pReverseHead = pNode;
        }
        
        pNode->m_pNext = pPrev;
        pPrev = pNode;
        pNode = pNext;
    }
    
    return pReverseHead;
}


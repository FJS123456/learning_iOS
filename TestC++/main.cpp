//
//  main.cpp
//  TestC++
//
//  Created by 符吉胜 on 2020/4/4.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#include <iostream>
#include "SingleList.hpp"
#include "algorithm_offer.hpp"
#include "Sort_Find_Algorithm.hpp"
#include <vector>
#include "DataStruct.hpp"

using namespace std;

ListNode* buildSingleList() {
    ListNode node3 = {3, NULL};
    ListNode node2 = {2, &node3};
    ListNode node1 = {1, &node2};
    ListNode head = {0, &node1};
    ListNode *p_head = &head;
    
    return p_head;
}

void dumpIntArray(int *datas, int length) {
    for (int i = 0; i < length; ++i) {
        printf("%d\t",datas[i]);
    }
    printf("\n");
}

void test_001() {
    int rows = 3;
    int colums = 2;
    int matrix[] = {2, 4, 4, 7, 6, 8};
    bool isFinded = find_aNumberFromMatrix(matrix, rows, colums, 0);
    printf("isfinded %d\n",isFinded);
}

void test_blankReplace() {
    char originStr[100] = "we are happy";
    replaceBlank(originStr, sizeof(originStr)/sizeof(char));
    printf("new str: %s\n", originStr);
}

void test_List_001() {
    ListNode node3 = {3, NULL};
    ListNode node2 = {2, &node3};
    ListNode node1 = {1, &node2};
    ListNode head = {0, &node1};
    
    printListReversingly(&head);
}

void test_array_001() {
//    int list[] = {3, 4, 5, 1, 2};
    int list[] = {1, 0, 1, 1, 1};
    int result = findMixFromRotateArray(list, sizeof(list)/sizeof(int));
    printf("result = %d \n", result);
}

void test_bulid_binaryTree() {
    int preOrde[] = {1, 2, 4, 7, 3, 5, 6, 8};
    int inOrder[] = {4, 7, 2, 1, 5, 3, 8, 6};
    
    BinaryTreeNode *root = construct(preOrde, inOrder, sizeof(preOrde) / sizeof(int));
    dumpPostOrder(root);
//    dumpInOrder(root);
//    dumpPreOrder(root);
    printf("\n");
}

void test_sort() {
    int a[] = {3, 1, 7, 2, 6, 1, 0, 9, 2, 6, 8};
//    int a[] = {3, 1};
    int length = sizeof(a)/sizeof(int);
//    quick_sort(a, length);
    direct_sort(a, length);
    dumpIntArray(a, length);
}

void testMaxSubSum() {
    vector<int> a {-2, 11, -4, 13, -5, -2};
    int result = maxSubSumOfSequece(a);
    printf("result = %d\n",result);
}

void testFindKth() {
    ListNode node3 = {3, NULL};
    ListNode node2 = {2, &node3};
    ListNode node1 = {1, &node2};
    ListNode head = {0, &node1};
    ListNode *p_head = &head;
    ListNode *kthNode = findKthToTail(p_head, 2);
    printf("value----%d\n",kthNode->m_nValue);
}

int main(int argc, const char * argv[]) {
//    test_blankReplace();
//    test_List_001();
//    test_bulid_binaryTree();
//    test_array_001();
    
//    print1ToMaxOfNDigits(2);
//    test_sort();
    
//    testMaxSubSum();
    testFindKth();
    
    return 0;
}

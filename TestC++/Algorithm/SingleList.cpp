//
//  SingleList.cpp
//  TestCAndC++
//
//  Created by 符吉胜 on 2020/4/3.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#include "SingleList.hpp"

void addToTail(ListNode **pHead, int value) {
    ListNode *pNew = new ListNode();
    pNew->m_nValue = value;
    pNew->m_pNext = NULL;
    
    if (*pHead == NULL) {
        *pHead = pNew;
    } else {
        ListNode *pNode = *pHead;
        while (pNode->m_pNext != NULL) {
            pNode = pNode->m_pNext;
        }
        pNode->m_pNext = pNew;
    }
}

void removeNode(ListNode **pHead, int value) {
    if (pHead == NULL || *pHead == NULL) {
        return;
    }
    
    ListNode *pToBeDeleted = NULL;
    if ((*pHead) -> m_nValue == value) {
        pToBeDeleted = *pHead;
        *pHead = (*pHead)->m_pNext;
    } else {
        ListNode *pNode = *pHead;
        while (pNode->m_pNext != NULL && pNode->m_pNext->m_nValue != value) {
            pNode = pNode->m_pNext;
        }
        
        if (pNode->m_pNext != NULL && pNode->m_pNext->m_nValue == value) {
            pToBeDeleted = pNode->m_pNext;
            pNode->m_pNext = pNode->m_pNext->m_pNext;
        }
        
        if (pToBeDeleted != NULL) {
            delete pToBeDeleted;
            pToBeDeleted = NULL;
        }
    }
    
}

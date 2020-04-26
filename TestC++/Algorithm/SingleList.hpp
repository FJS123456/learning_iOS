//
//  SingleList.hpp
//  TestCAndC++
//
//  Created by 符吉胜 on 2020/4/3.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#ifndef SingleList_hpp
#define SingleList_hpp

#include <stdio.h>
#include <string>
#include <iostream>

struct ListNode{
    int m_nValue;
    ListNode *m_pNext;
};

void addToTail(ListNode **pHead, int value);
void removeNode(ListNode **pHead, int value);


#endif /* SingleList_hpp */

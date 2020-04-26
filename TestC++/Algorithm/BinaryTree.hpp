//
//  BinaryTree.hpp
//  TestC++
//
//  Created by 符吉胜 on 2020/4/5.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#ifndef BinaryTree_hpp
#define BinaryTree_hpp

#include <stdio.h>

struct BinaryTreeNode {
    int                 m_nValue;
    BinaryTreeNode      *m_pLeft;
    BinaryTreeNode      *m_pRight;
};

void dumpPreOrder(BinaryTreeNode const *root);
void dumpInOrder(BinaryTreeNode const *root);
void dumpPostOrder(BinaryTreeNode const *root);
void dumpLayerOrder(BinaryTreeNode const *root);


#endif /* BinaryTree_hpp */

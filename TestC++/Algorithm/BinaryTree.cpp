//
//  BinaryTree.cpp
//  TestC++
//
//  Created by 符吉胜 on 2020/4/5.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#include "BinaryTree.hpp"

void dumpPreOrder(BinaryTreeNode const *root) {
    if (root == NULL) return;
    
    printf("%d\t", root->m_nValue);
    
    dumpPreOrder(root->m_pLeft);
    dumpPreOrder(root->m_pRight);
}

void dumpInOrder(BinaryTreeNode const *root) {
    if (root == NULL) return;
    
    dumpInOrder(root->m_pLeft);
    printf("%d\t", root->m_nValue);
    dumpInOrder(root->m_pRight);
}

void dumpPostOrder(BinaryTreeNode const *root) {
    
    if (root == NULL) return;
    
    dumpPostOrder(root->m_pLeft);
    dumpPostOrder(root->m_pRight);
    printf("%d\t", root->m_nValue);
}

void dumpLayerOrder(BinaryTreeNode const *root) {
    
}

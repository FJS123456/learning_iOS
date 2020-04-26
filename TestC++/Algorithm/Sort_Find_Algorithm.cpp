//
//  Sort_Find_Algorithm.cpp
//  TestC++
//
//  Created by 符吉胜 on 2020/4/6.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#include "Sort_Find_Algorithm.hpp"
#include <iostream>

using namespace std;

void quick_sort_recursion(int *datas, int startIndex, int endIndex) {
    if (startIndex < endIndex) {
        //选取中间值做为分划的关键值 (尽可能规避最坏时间复杂度的产生）
        int midIndex = (startIndex + endIndex) / 2;
        
        if (datas[midIndex] > datas[endIndex]) {
            swap(datas[midIndex], datas[endIndex]);
        }
        
        if (datas[startIndex] > datas[endIndex]) {
            swap(startIndex, endIndex);
        }
        
        if (datas[midIndex] > datas[startIndex]) {
            swap(datas[midIndex], datas[startIndex]);
        }
        
        int keyWord = datas[startIndex];
        int leftIndex = startIndex;
        int rightIndex = endIndex + 1;
        while (leftIndex < rightIndex) {
            ++leftIndex;
            while (datas[leftIndex] < keyWord) {
                ++leftIndex;
            }
            --rightIndex;
            while (datas[rightIndex] > keyWord) {
                --rightIndex;
            }
            if (leftIndex < rightIndex) {
                //交互
                swap(datas[leftIndex], datas[rightIndex]);
            }
        }
        
        swap(datas[startIndex], datas[rightIndex]);
        quick_sort_recursion(datas, startIndex, rightIndex - 1);
        quick_sort_recursion(datas, rightIndex + 1, endIndex);
    }
}

void quick_sort(int *datas, int length) {
    if (datas == NULL || length <= 1) {
        return;
    }
    
    quick_sort_recursion(datas, 0, length - 1);
}

void direct_sort(int *datas, int length) {
    if (datas == NULL || length <= 1) {
        return;
    }
    
    for (int i = length - 1; i > 0; --i) {
        int t = 0;
        for (int j = 1; j <= i; ++j) {
            if (datas[j] > datas[t]) {
                t = j;
            }
        }
        swap(datas[t], datas[i]);
    }
}

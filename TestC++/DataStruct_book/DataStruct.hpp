//
//  DataStruct.hpp
//  TestC++
//
//  Created by 符吉胜 on 2020/4/8.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#ifndef DataStruct_hpp
#define DataStruct_hpp

#include <stdio.h>
#include <vector>
#include <string>

using namespace std;

template <typename Container>
void removeEveryOtherItem(Container & lst) {
    typename Container::iterator itr = lst.begin();
    while (itr != lst.end()) {
        itr = lst.erase(itr);
        if (itr != lst.end()) {
            ++itr;
        }
    }
}


#endif /* DataStruct_hpp */

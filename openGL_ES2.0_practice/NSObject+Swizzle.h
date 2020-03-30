//
//  NSObject+Swizzle.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/3/26.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector
                withNewSelector:(SEL)newSelector;

+ (void)swizzleClassSelector:(SEL)originalSelector
             withNewSelector:(SEL)newSelector;

+ (void)swizzleInstanceSelector:(SEL)originalSelector
                withNewSelector:(SEL)newSelector
                    newImpBlock:(id)block;

+ (void)swizzleClassSelector:(SEL)originalSelector
             withNewSelector:(SEL)newSelector
                 newImpBlock:(id)block;

@end

NS_ASSUME_NONNULL_END

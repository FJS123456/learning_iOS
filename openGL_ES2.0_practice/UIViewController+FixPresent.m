//
//  UIViewController+FixPresent.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/3/26.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import "UIViewController+FixPresent.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@interface UIViewController ()

@property (nonatomic, assign) BOOL hasSetPresentStyle;

@end

@implementation UIViewController (FixPresent)

+ (void)initialize
{
    if (@available(iOS 13.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleInstanceSelector:@selector(setModalPresentationStyle:) withNewSelector:@selector(MDFix_setModalPresentationStyle:)];
            [self swizzleInstanceSelector:@selector(modalPresentationStyle) withNewSelector:@selector(MDFix_modalPresentationStyle)];
        });
    }
}

- (BOOL)hasSetPresentStyle {
    NSNumber *hasSetPresentStyle = objc_getAssociatedObject(self, _cmd);
    return [hasSetPresentStyle boolValue];
}
- (void)setHasSetPresentStyle:(BOOL)hasSetPresentStyle {
    objc_setAssociatedObject(self, @selector(hasSetPresentStyle), @(hasSetPresentStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)MDFix_setModalPresentationStyle:(UIModalPresentationStyle)modalPresentationStyle {
    self.hasSetPresentStyle = YES;
    [self MDFix_setModalPresentationStyle:modalPresentationStyle];
}

- (UIModalPresentationStyle)MDFix_modalPresentationStyle {
    if (@available(iOS 13.0, *)) {
        UIModalPresentationStyle style = [self MDFix_modalPresentationStyle];
        //如果读取到的style是UIModalPresentationPageSheet，且没有手动设置过style。
        if (style == UIModalPresentationPageSheet && !self.hasSetPresentStyle) {
              //过滤系统的controller，即过滤 'UI' 开头的和 '_' 开头的。
            NSString *className = NSStringFromClass([self class]);
            if ([self isKindOfClass:[UINavigationController class]]) {
                className = NSStringFromClass([((UINavigationController *)self).topViewController class]);
            }
            if (![className hasPrefix:@"UI"] && ![className hasPrefix:@"_"]) {
                return UIModalPresentationFullScreen;
            }
        }
    }
    return [self MDFix_modalPresentationStyle];
}

@end

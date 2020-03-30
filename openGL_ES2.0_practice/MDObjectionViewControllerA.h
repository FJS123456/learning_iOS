//
//  MDObjectionViewControllerA.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2019/10/9.
//  Copyright © 2019 符吉胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerAProtocol <NSObject>

@property (nonatomic) UIColor *backgroudColor;

@end

@interface MDObjectionViewControllerA : UIViewController<ViewControllerAProtocol>

@end

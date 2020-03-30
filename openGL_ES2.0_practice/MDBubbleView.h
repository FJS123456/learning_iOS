//
//  MDBubbleView.h
//  MomoChat
//
//  Created by xindong on 2018/7/6.
//  Copyright © 2018年 wemomo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MDBubbleGradientDirection) {
    MDBubbleGradientDirectionHorizontal = 0,
    MDBubbleGradientDirectionVertical   = 1,
};

@class MDBubbleView;
@protocol MDBubbleViewDelegate <NSObject>

@optional
- (void)bubbleViewClickCallBack:(MDBubbleView *)bubbleView;

@end

@interface MDBubbleView : UIView

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, weak) id<MDBubbleViewDelegate> delegate;
@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong) UIFont *font; // default is system font 17 plain.
@property (nonatomic, strong) UIColor *textColor; // default is black color.
@property (nonatomic, assign) BOOL showObliqueLine; // default is NO.

/// @Note This value will be no effect if gradientColors is nonnull.
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) CGFloat bubbleArrowX;
@property (nonatomic, assign) CGFloat bubbleArrowHeight; // default is 4 pt.

/// Support local image and net image, e.g. sky.png、http(s)://www.wemomo.com/others/sky.png.
@property (nonatomic, strong, nullable) NSString *imageName;

/// If YES, the text will be above the image, default is NO.
@property (nonatomic, assign) BOOL textAboveImage;

/// 0 ... 0.5 * MDBubbleView's height, default is 0.0. values outside are pinned.
@property (nonatomic, assign) CGFloat cornerRadius;

/// The array of UIColor objects defining the color of each gradient stop. @Note One element is no effect, at present support two elements at most.
@property (nonatomic, strong, nullable) NSArray<UIColor *> *gradientColors;
@property (nonatomic, assign) MDBubbleGradientDirection gradientDirection;

/// This method applies to single line text.
- (void)adjustWidthToFitText;

@end

NS_ASSUME_NONNULL_END

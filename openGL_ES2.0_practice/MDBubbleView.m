//
//  MDBubbleView.m
//  MomoChat
//
//  Created by xindong on 2018/7/6.
//  Copyright © 2018年 wemomo.com. All rights reserved.
//

#import "MDBubbleView.h"
#import "MDBaseDefine.h"

#define BUBBLE_VIEW_FRAME  CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - self.bubbleArrowHeight)
#define OBLIQUE_LINE_FRAME CGRectMake(8, 7, self.bubbleView.width - 16, 2)

static CGFloat const kDefaultArrowHeight = 4.0;

@interface MDBubbleView ()

@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) CAShapeLayer *bubbleLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *obliqueLine;

@end

@implementation MDBubbleView {
    CGFloat _roundness;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect _frame = frame;
    _frame.size.height += kDefaultArrowHeight; // the sum of ArrowHeight and BubbleView's height is equal to the self's height.
    frame = _frame;
    
    if (self = [super initWithFrame:frame]) {
        _roundness = 0.5;
        _bubbleArrowX = CGRectGetWidth(frame) / 2.0;
        _bubbleArrowHeight = kDefaultArrowHeight;
        [self addTapGesture];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    _bubbleView = [[UIView alloc] initWithFrame:BUBBLE_VIEW_FRAME];
    [self addSubview:_bubbleView];
    
    _bubbleLayer = [CAShapeLayer layer];
    _bubbleLayer.fillColor = self.backgroundColor.CGColor;
    [self.layer addSublayer:_bubbleLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bubbleLayer.path = [self drawBubblePath].CGPath;
}

#pragma mark - UITapGesture

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)clickTapGesture:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(bubbleViewClickCallBack:)]) {
        [self.delegate bubbleViewClickCallBack:self];
    }
}

#pragma mark - Draw

- (UIBezierPath *)drawBubblePath {
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bubbleView.bounds cornerRadius:self.cornerRadius]; /*使用该方法不同机型上frame被更改时会出现尖角分离, 原因未知.*/
    
    CGFloat width = CGRectGetWidth(self.bubbleView.bounds);
    CGFloat height = CGRectGetHeight(self.bubbleView.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineJoinStyle = kCGLineJoinRound;
    
    // top left
    [path moveToPoint:CGPointMake(self.cornerRadius, 0)];
    
    // top right
    [path addLineToPoint:CGPointMake(width - self.cornerRadius, 0)];
    
    // top right arc
    [path addArcWithCenter:CGPointMake(width - self.cornerRadius, self.cornerRadius) radius:self.cornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    
    // right straight line
    [path addLineToPoint:CGPointMake(width, height - self.cornerRadius)];
    
    // bottom right arc
    [path addArcWithCenter:CGPointMake(width - self.cornerRadius, height - self.cornerRadius) radius:self.cornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    // bottom right
    [path addLineToPoint:CGPointMake(width - self.cornerRadius, height)];
    
    // arrow
    [self drawArrowPath:path];
    
    // bottom left
    [path addLineToPoint:CGPointMake(self.cornerRadius, height)];
    
    // bottom left arc
    [path addArcWithCenter:CGPointMake(self.cornerRadius, height - self.cornerRadius) radius:self.cornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    // left straight line
    [path addLineToPoint:CGPointMake(0, self.cornerRadius)];
    
    // top left arc
    [path addArcWithCenter:CGPointMake(self.cornerRadius, self.cornerRadius) radius:self.cornerRadius startAngle:M_PI endAngle:(3 * M_PI_2) clockwise:YES];
    
    [path closePath];
    return path;
}

- (void)drawArrowPath:(UIBezierPath *)path {
    if (self.bubbleArrowX < self.bubbleArrowHeight) {
        NSAssert(false, @"The `bubbleArrowX` should be greater or equal than the `bubbleArrowHeight`, please check values and reset them.");
        return;
    }
    if (self.bubbleArrowX + self.bubbleArrowHeight > CGRectGetWidth(self.bounds)) {
        NSAssert(false, @"either `bubbleArrowX` or `bubbleArrowHeight` is invalid, the sum of them shouldn't be greater than the MDBubbleView's width.");
        return;
    }
    CGFloat height = CGRectGetHeight(self.bubbleView.bounds);
    
    CGPoint start = (CGPoint){self.bubbleArrowX + self.bubbleArrowHeight, height};
    CGPoint mid = (CGPoint){self.bubbleArrowX, height + self.bubbleArrowHeight};
    CGPoint end = (CGPoint){self.bubbleArrowX - self.bubbleArrowHeight, height};
    
    CGPoint control1 = (CGPoint){mid.x + 2 * _roundness, mid.y - _roundness};
    CGPoint control2 = (CGPoint){mid.x - 2 * _roundness, mid.y - _roundness};
    
    [path addLineToPoint:start];
    [path addLineToPoint:control1];
    [path addQuadCurveToPoint:control2 controlPoint:mid];
    [path addLineToPoint:end];
}

#pragma mark - Public

- (void)adjustWidthToFitText {
    if (!_label || !_label.text) return;
    CGSize size = [self.label.text sizeWithAttributes:@{NSFontAttributeName:self.label.font}];
    CGRect frame = self.frame;
    if (ABS(frame.size.width - ceil(size.width) - 8) < 0.1) {
        NSLog(@"MDBubbleView needn't adjust width to fit text.");
        return;
    }
    frame.size.width = ceil(size.width) + 8;
    [self layoutAllViewsWithFrame:frame];
}

#pragma mark - Private

- (void)loadImageWithView:(UIImageView *)imageView name:(NSString *)name {
    if (!name) return;
    if ([name hasPrefix:@"http://"] || [name hasPrefix:@"https://"]) {
//        [imageView setImageWithURL:[NSURL URLWithString:name]];
    } else {
        imageView.image = [UIImage imageNamed:name];
    }
}

- (nullable NSArray *)transformGradientColorsFromUIColors:(NSArray<UIColor *> *)colors {
    if (colors.count == 0) return nil;
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *_color in colors) {
        [array addObject:(__bridge id)_color.CGColor];
    }
    return [array copy];
}

- (void)updateBubbleLayerColor {
    if (self.gradientColors.count == 0) return;
    switch (self.gradientDirection) {
        case MDBubbleGradientDirectionVertical:
            self.bubbleLayer.fillColor = self.gradientColors.lastObject.CGColor;
            break;
            
        case MDBubbleGradientDirectionHorizontal:
            self.bubbleLayer.fillColor = self.gradientColors.firstObject.CGColor;
            break;
            
        default:
            break;
    }
}

- (void)validateBubbleArrowHeight:(CGFloat)arrowHeight {
    if (arrowHeight < kDefaultArrowHeight) {
        arrowHeight = kDefaultArrowHeight;
    }
    CGFloat maxValue = CGRectGetWidth(self.bounds) / 2.0 - self.cornerRadius;
    if (arrowHeight > maxValue) {
        arrowHeight = maxValue;
    }
    _bubbleArrowHeight = arrowHeight;
}

- (void)validateBubbleArrowX:(CGFloat)arrowX {
    if (arrowX < self.bubbleArrowHeight + self.cornerRadius) {
        arrowX = self.bubbleArrowHeight + self.cornerRadius;
    }
    CGFloat maxValue = CGRectGetWidth(self.bounds) - self.bubbleArrowHeight - self.cornerRadius;
    if (arrowX > maxValue) {
        arrowX = maxValue;
    }
    _bubbleArrowX = arrowX;
}

- (void)layoutAllViewsWithFrame:(CGRect)frame {
    if (ABS(self.bubbleArrowX - CGRectGetWidth(self.frame) / 2.0) < 0.001) {
        self.bubbleArrowX = CGRectGetWidth(frame) / 2.0;
    } else {
        [self validateBubbleArrowX:self.bubbleArrowX];
    }
    
    self.frame = frame;
    self.bubbleView.frame = BUBBLE_VIEW_FRAME;
    self.bubbleLayer.path = [self drawBubblePath].CGPath;
    
    if (_gradientLayer) {
        _gradientLayer.frame = self.bubbleView.bounds;
    }
    if (_label) {
        _label.frame = self.bubbleView.bounds;
    }
    if (_imageView) {
        _imageView.frame = self.bubbleView.bounds;
    }
    if (_obliqueLine) {
        _obliqueLine.frame = OBLIQUE_LINE_FRAME;
    }
}

#pragma mark - Property

- (void)setText:(NSString *)text {
    if ([_text isEqualToString:text]) return;
    _text = text;
    
    if (text) {
        self.label.text = text;
        [self.label layoutIfNeeded]; // to force update text immediately.
    } else {
        if (!_label) return;
        [self.label removeFromSuperview];
        self.label = nil;
    }
}

- (void)setFont:(UIFont *)font {
    if (_font == font) return;
    _label.font = _font = font;
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return;
    _label.textColor = _textColor = textColor;
}

- (void)setShowObliqueLine:(BOOL)showObliqueLine {
    if (_showObliqueLine == showObliqueLine) return;
    _showObliqueLine = showObliqueLine;
    
    if (showObliqueLine && !_obliqueLine) {
        [_label addSubview:self.obliqueLine];
    } else {
        if (!_obliqueLine) return;
        [_obliqueLine removeFromSuperview];
        _obliqueLine = nil;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_backgroundColor == backgroundColor) return;
    _backgroundColor = backgroundColor; // override, yet don't call super method.
    
    if (!self.gradientColors.count) {
        self.bubbleLayer.fillColor = backgroundColor.CGColor;
    } else {
        NSLog(@"%@ shouldn't update background color.", NSStringFromClass(self.class));
    }
}

- (void)setBubbleArrowHeight:(CGFloat)bubbleArrowHeight {
    if (_bubbleArrowHeight == bubbleArrowHeight) return;
    [self validateBubbleArrowHeight:bubbleArrowHeight];
    [self validateBubbleArrowX:_bubbleArrowX];
    self.bubbleLayer.path = [self drawBubblePath].CGPath;
}

- (void)setBubbleArrowX:(CGFloat)bubbleArrowX {
    if (_bubbleArrowX == bubbleArrowX) return;
    [self validateBubbleArrowX:bubbleArrowX];
    self.bubbleLayer.path = [self drawBubblePath].CGPath;
}

- (void)setImageName:(NSString *)imageName {
    if ([_imageName isEqualToString:imageName]) return;
    _imageName = imageName;
    
    if (imageName) {
        [self loadImageWithView:self.imageView name:imageName];
    } else {
        if (!_imageView) return;
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }
}

- (void)setTextAboveImage:(BOOL)textAboveImage {
    if (_textAboveImage == textAboveImage) return;
    _textAboveImage = textAboveImage;
    
    if (!_label || !_imageView) return;
    if (textAboveImage) {
        [self insertSubview:self.label aboveSubview:self.imageView];
    } else {
        [self insertSubview:self.imageView aboveSubview:self.label];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) return;
    CGFloat max = CGRectGetHeight(self.bubbleView.bounds) / 2.0;
    cornerRadius = cornerRadius < 0.0 ? 0.0 : cornerRadius > max ? max : cornerRadius;
    _cornerRadius = cornerRadius;
    
    [self validateBubbleArrowHeight:_bubbleArrowHeight];
    [self validateBubbleArrowX:_bubbleArrowX]; // should validate ArrowHeight and then validate ArrowX, since ArrowX depends on ArrowHeight.
    self.bubbleLayer.path = [self drawBubblePath].CGPath;
}

- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors {
    if (_gradientColors == gradientColors) return;
    _gradientColors = gradientColors;
    
    if (gradientColors.count) {
        self.gradientLayer.colors = [self transformGradientColorsFromUIColors:gradientColors];
        [self updateBubbleLayerColor];
    } else {
        if (!_gradientLayer) return;
        [self.gradientLayer removeFromSuperlayer];
        [self setGradientLayer:nil];
    }
}

- (void)setGradientDirection:(MDBubbleGradientDirection)gradientDirection {
    if (_gradientDirection == gradientDirection) return;
    _gradientDirection = gradientDirection;
    if (!_gradientLayer) return;
    
    switch (gradientDirection) {
        case MDBubbleGradientDirectionHorizontal:
            self.gradientLayer.startPoint = (CGPoint){0.0, 0.5};
            self.gradientLayer.endPoint = (CGPoint){1.0, 0.5};
            break;
            
        case MDBubbleGradientDirectionVertical:
            self.gradientLayer.startPoint = (CGPoint){0.5, 0.0};
            self.gradientLayer.endPoint = (CGPoint){0.5, 1.0};
            break;
            
        default:
            break;
    }
    [self updateBubbleLayerColor];
}

#pragma mark - Lazy Loading

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bubbleView.bounds;
        _gradientLayer.locations = @[@(0.1), @(1.0)];
        _gradientLayer.colors = [self transformGradientColorsFromUIColors:self.gradientColors];
        _gradientLayer.cornerRadius = self.cornerRadius;
        [self.bubbleLayer addSublayer:_gradientLayer];
        if (self.gradientDirection == MDBubbleGradientDirectionHorizontal) {
            _gradientLayer.startPoint = (CGPoint){0.0, 0.5};
            _gradientLayer.endPoint = (CGPoint){1.0, 0.5};
        }
    }
    return _gradientLayer;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:self.bubbleView.bounds];
        _label.font = self.font ?: [UIFont systemFontOfSize:17];
        _label.textColor = self.textColor ?: [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
        if (_imageView && !self.textAboveImage) {
            [self insertSubview:_label belowSubview:_imageView];
        }
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bubbleView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self loadImageWithView:_imageView name:self.imageName];
        [self addSubview:_imageView];
        if (_label && self.textAboveImage) {
            [self insertSubview:_imageView belowSubview:_label];
        }
    }
    return _imageView;
}

- (UIView *)obliqueLine {
    if (!_obliqueLine) {
        CGFloat radian = 10 * M_PI / 180;
        _obliqueLine = [[UIView alloc] initWithFrame:OBLIQUE_LINE_FRAME];
        _obliqueLine.backgroundColor = RGBACOLOR(255, 0, 0, 0.8);
        _obliqueLine.transform = CGAffineTransformMakeRotation(radian);
    }
    return _obliqueLine;
}

@end

//
//  MDLayerPracticeController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/14.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "MDLayerPracticeController.h"
#import "MDLayerTransformView.h"
#import "MDBubbleView.h"
#import "MDBaseDefine.h"
#import "DrawingView.h"

@interface MDLayerPracticeController ()

@property (nonatomic, strong) CALayer *layerOne;

@end

@implementation MDLayerPracticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
//    [self testLayerAnchorPoint];
//    [self testLayoutAction_1];
//    [self testLayoutAction_2];
//    [self testKeyframeAnimation_1];
//    [self testCAMediaTiming_1];
//    [self drawTimingFunctionPatch_1];
    
//    [self test_bubbleView];
    
    [self test_drawingView];
}

- (void)test_drawingView {
    DrawingView *view = [[DrawingView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

- (void)test_bubbleView {
    CGPoint arrowPoint = CGPointMake(48, 0);
    CGFloat arrowH = 8;
    CGFloat shapeLayerH = 50;
    UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 300, arrowH + shapeLayerH)];
    [self.view addSubview:bubbleView];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, arrowH, bubbleView.width, shapeLayerH) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8.0, 8.0)];
    [path moveToPoint:CGPointMake(arrowPoint.x - arrowH, arrowH)];
    [path addLineToPoint:arrowPoint];
    [path addLineToPoint:CGPointMake(arrowPoint.x + arrowH, arrowH)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    
    [bubbleView.layer addSublayer:shapeLayer];
    
}

- (void)test_transform_1 {
    //视图变换
    MDLayerTransformView *view1 = [[MDLayerTransformView alloc] init];
    [self.view addSubview:view1];
}

- (void)testLayerAnchorPoint {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(20, 80, 40, 50)];
    view1.backgroundColor = [UIColor redColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:view1.frame];
    view2.backgroundColor = [UIColor blueColor];
    view2.layer.anchorPoint = CGPointZero;
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    [self printAllPositionInfoWithView:view1];
    [self printAllPositionInfoWithView:view2];
}

/**
 图层首先检测它是否有委托，并且是否实现CALayerDelegate协议指定的-actionForLayer:forKey方法。如果有，直接调用并返回结果。
 如果没有委托，或者委托没有实现-actionForLayer:forKey方法，图层接着检查包含属性名称对应行为映射的actions字典。
 如果actions字典没有包含对应的属性，那么图层接着在它的style字典接着搜索属性名。
 最后，如果在style里面也找不到对应的行为，那么图层将会直接调用定义了每个属性的标准行为的-defaultActionForKey:方法。
 */
- (void)testLayoutAction_1 {
    //test layer action when outside of animation block
    NSLog(@"Outside: %@", [self.view actionForLayer:self.view.layer forKey:@"backgroundColor"]);
    //begin animation block
    [UIView beginAnimations:nil context:nil];
    //test layer action when inside of animation block
    NSLog(@"Inside: %@", [self.view actionForLayer:self.view.layer forKey:@"backgroundColor"]);
    //end animation block
    [UIView commitAnimations];
}

- (void)testLayoutAction_2 {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 200, 200);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    layer.actions = @{@"backgroundColor": transition};
    
    _layerOne = layer;
    [self.view.layer addSublayer:_layerOne];
}

- (void)testKeyframeAnimation_1 {
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0;
    pathLayer.path = bezierPath.CGPath;
    [self.view.layer addSublayer:pathLayer];
    //add the smapleLayer
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 60, 15);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:shipLayer];
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    [shipLayer addAnimation:animation forKey:nil];
}

- (void)testCAMediaTiming_1 {
    CALayer *doorLayer = [CALayer layer];
    doorLayer.frame = CGRectMake(20, 100, 128, 256);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:doorLayer];
    //applay perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0f;
    self.view.layer.sublayerTransform = perspective;
    //apply swinging animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 2.0;
//    animation.repeatDuration = INFINITY;
    //动画回放
//    animation.autoreverses = YES;
    
    //防止动画结束后急速返回初始态 （removedOnCompletion设置为NO，图层不用的时候移除动画）
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [doorLayer addAnimation:animation forKey:@"doorAniamtion"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //randomize the layer background color
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.layerOne.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}

//绘制缓冲曲线
- (void)drawTimingFunctionPatch_1 {
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //get control points
    CGPoint controlPoint1, controlPoint2;
    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
    //create curve
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addCurveToPoint:CGPointMake(1, 1) controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    [path applyTransform:CGAffineTransformMakeScale(200, 200)];
    //create share layer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 4.0;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
    self.view.layer.geometryFlipped = YES;
}

#pragma mark - 辅助方法
- (void)printAllPositionInfoWithView:(UIView *)view {
    NSLog(@"frame -- %@",NSStringFromCGRect(view.frame));
    NSLog(@"bounds -- %@",NSStringFromCGRect(view.bounds));
    NSLog(@"position -- %@",NSStringFromCGPoint(view.center));
    NSLog(@"anchorPoint -- %@",NSStringFromCGPoint(view.layer.anchorPoint));
    NSLog(@"***********************");
}

@end

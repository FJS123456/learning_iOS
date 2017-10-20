//
//  MDGLPaintController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/16.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGLPaintController.h"
#import "MDPaintingView.h"
#import "SoundEffect.h"

#define kBrightness             1.0
#define kSaturation             0.45

#define kPaletteHeight			30
#define kPaletteSize			5
#define kMinEraseInterval		0.5

// Padding for margins
#define kLeftMargin				10.0
#define kTopMargin				10.0
#define kRightMargin			10.0

@interface MDGLPaintController ()
{
    SoundEffect			*erasingSound;
    SoundEffect			*selectSound;
    CFTimeInterval		lastTime;
}

@property (nonatomic,strong) UIButton *eraseView;
@property (nonatomic,strong) MDPaintingView *paintingView;

@end

@implementation MDGLPaintController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI
{
    _paintingView = [[MDPaintingView alloc] initWithFrame:self.view.bounds];
    _paintingView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_paintingView];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             [[UIImage imageNamed:@"Red"]       imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                                             [[UIImage imageNamed:@"Yellow"]    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                                             [[UIImage imageNamed:@"Green"]     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                                             [[UIImage imageNamed:@"Blue"]      imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                                             [[UIImage imageNamed:@"Purple"]    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                                             nil]];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(rect.origin.x + kLeftMargin, rect.size.height - kPaletteHeight - kTopMargin, rect.size.width - (kLeftMargin + kRightMargin), kPaletteHeight);
    segmentedControl.frame = frame;
    
    [segmentedControl addTarget:self action:@selector(changeBrushColor:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = [UIColor darkGrayColor];
    // Set the third color (index values start at 0)
    segmentedControl.selectedSegmentIndex = 2;
    
    [self.paintingView addSubview:segmentedControl];
    [self.paintingView addSubview:self.eraseView];
    
    // Define a starting color
    CGColorRef color = [UIColor colorWithHue:(CGFloat)2.0 / (CGFloat)kPaletteSize
                                  saturation:kSaturation
                                  brightness:kBrightness
                                       alpha:1.0].CGColor;
    const CGFloat *components = CGColorGetComponents(color);
    
    // Defer to the OpenGL view to set the brush color
    [self.paintingView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
    
    // Load the sounds
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    erasingSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Erase" ofType:@"caf"]];
//    selectSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Select" ofType:@"caf"]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UIButton *)eraseView
{
    if (!_eraseView) {
        _eraseView = [[UIButton alloc] initWithFrame:CGRectMake(150, 80, 50, 30)];
        _eraseView.backgroundColor = [UIColor whiteColor];
        [_eraseView setTitle:@"erase" forState:UIControlStateNormal];
        [_eraseView setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [_eraseView addTarget:self action:@selector(erase) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eraseView;
}

#pragma mark - event handle
- (void)erase
{
    if(CFAbsoluteTimeGetCurrent() > lastTime + kMinEraseInterval) {
//        [erasingSound play];
        [self.paintingView erase];
        lastTime = CFAbsoluteTimeGetCurrent();
    }
}

// Change the brush color
- (void)changeBrushColor:(id)sender
{
    // Play sound
//    [selectSound play];
    
    // Define a new brush color
    CGColorRef color = [UIColor colorWithHue:(CGFloat)[sender selectedSegmentIndex] / (CGFloat)kPaletteSize
                                  saturation:kSaturation
                                  brightness:kBrightness
                                       alpha:1.0].CGColor;
    const CGFloat *components = CGColorGetComponents(color);
    
    // Defer to the OpenGL view to set the brush color
    [self.paintingView setBrushColorWithRed:components[0] green:components[1] blue:components[2]];
}

// We do not support auto-rotation in this sample
- (BOOL)shouldAutorotate
{
    return NO;
}

@end

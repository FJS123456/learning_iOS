//
//  AGLKViewController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/26.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "AGLKViewController.h"

static const NSInteger kAGLKDefaultFramesPerSecond = 30;

@interface AGLKViewController ()

@property (nonatomic,strong) CADisplayLink *displayLink;

@end

@implementation AGLKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AGLKView *view = [[AGLKView alloc] initWithFrame:self.view.bounds];
    self.view = view;
    
    view.opaque = YES;
    view.delegate = self;
}

// This method is the designated initializer.
// The receiver's Core Animation displayLink instance is created
// and configured to prompt redraw of the receiver's view
// at the default number of frames per second rate.
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (nil != (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        
        self.preferredFramesPerSecond = kAGLKDefaultFramesPerSecond;
        
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        self.paused = NO;
    }
    
    return self;
}

// This method is called automatically to initialize each Cocoa
// Touch object as the object is unarchived from an
// Interface Builder .xib or .storyboard file.
// The receiver's Core Animation displayLink instance is created
// and configured to prompt redraw of the receiver's view
// at the default number of frames per second rate.
- (id)initWithCoder:(NSCoder*)coder
{
    if (nil != (self = [super initWithCoder:coder]))
    {
        _displayLink =
        [CADisplayLink displayLinkWithTarget:self
                                    selector:@selector(drawView:)];
        
        self.preferredFramesPerSecond =
        kAGLKDefaultFramesPerSecond;
        
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSDefaultRunLoopMode];
        
        self.paused = NO;
    }
    
    return self;
}

// This method is called when the receiver's view appears and
// unpauses the receiver.
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.paused = NO;
}


// This method is called when the receiver's view disappears and
// pauses the receiver.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.paused = YES;
}

// This method is called automatically and allows all standard
// device orientations.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation !=
                UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}


- (void)drawView:(CADisplayLink *)diplayLink
{
    [(AGLKView *)self.view display];
}

// Returns the receiver's framesPerSecond property value.
- (NSInteger)framesPerSecond
{
    return 60 / _displayLink.frameInterval;
}

// This method returns YES if the receiver is paused and NO
// otherwise. The receiver does not automatically prompt redraw
// of the receiver's view when paused.
- (BOOL)isPaused
{
    return self.displayLink.paused;
}

/////////////////////////////////////////////////////////////////
// This method sets whether the receiver is paused. The receiver
// automatically prompts redraw of the receiver's view
// unless paused.
- (void)setPaused:(BOOL)aValue
{
    self.displayLink.paused = aValue;
}

- (void)setPreferredFramesPerSecond:(NSInteger)preferredFramesPerSecond
{
    _preferredFramesPerSecond = preferredFramesPerSecond;
    _displayLink.frameInterval = MAX(1,60/preferredFramesPerSecond);
}

#pragma mark - AGLKViewDelegate
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;
{
    
}

@end

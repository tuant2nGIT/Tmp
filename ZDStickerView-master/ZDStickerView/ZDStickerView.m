//
// ZDStickerView.m
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ZDStickerView.h"

#import "LoremIpsum.h"

#define kGlobalInset 15.0
#define kControlSize 30.0

@interface ZDStickerView () <UIGestureRecognizerDelegate>
{
    float delta;
    
    float prevWidth, prevHeight;
    CGPoint touchStart;
    CGFloat deltaAngle;
    
    CGFloat minSize;
}

@property (strong, nonatomic) UILabel *contentView;

@property (strong, nonatomic) UIImageView *changeWidthControl;
@property (strong, nonatomic) UIImageView *changeHeightControl;
@property (strong, nonatomic) UIImageView *rotateControl;

@property (strong, nonatomic) UIButton *deleteControl;
@property (strong, nonatomic) UIButton *editControl;

@end

@implementation ZDStickerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setupDefaultAttributes
{
    [self initValue];
    [self setupUI];
}

- (void)initValue
{
    minSize = 3.0*kControlSize;
}

- (void)setupUI
{
    self.contentView = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, kGlobalInset, kGlobalInset)];
    self.contentView.backgroundColor = [UIColor purpleColor];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self makeVideoAntialiasing:self.contentView];
    
    self.contentView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:panRecognizer];
    [self addSubview:self.contentView];
    
    //
    self.deleteControl = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteControl.frame = CGRectMake(0.0, 0.0, kControlSize, kControlSize);
    self.deleteControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.deleteControl.backgroundColor = [UIColor yellowColor];
    [self makeVideoAntialiasing:self.deleteControl];
    [self addSubview:self.deleteControl];
    
    self.editControl = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editControl.frame = CGRectMake(self.frame.size.width - kControlSize, 0, kControlSize, kControlSize);
    self.editControl.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    self.editControl.backgroundColor = [UIColor blueColor];
    [self makeVideoAntialiasing:self.editControl];
    [self addSubview:self.editControl];
    
    //
    self.changeWidthControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - kControlSize, (self.frame.size.height - kControlSize)/2.0, kControlSize, kControlSize)];
    self.changeWidthControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.changeWidthControl.backgroundColor = [UIColor greenColor];
    [self makeVideoAntialiasing:self.changeWidthControl];
    
    self.changeWidthControl.userInteractionEnabled = YES;
    UIPanGestureRecognizer *resizeWidthGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleChangeWidth:)];
    resizeWidthGesture.delegate = self;
    [self.changeWidthControl addGestureRecognizer:resizeWidthGesture];
    [self addSubview:self.changeWidthControl];
    
    //
    self.changeHeightControl = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - kControlSize)/2.0, self.frame.size.height - kControlSize, kControlSize, kControlSize)];
    self.changeHeightControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    self.changeHeightControl.backgroundColor = [UIColor greenColor];
    [self makeVideoAntialiasing:self.changeHeightControl];
    
    self.changeHeightControl.userInteractionEnabled = YES;
    UIPanGestureRecognizer *resizeHeightGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleChangeHeight:)];
    resizeHeightGesture.delegate = self;
    [self.changeHeightControl addGestureRecognizer:resizeHeightGesture];
    [self addSubview:self.changeHeightControl];
    
    //
    self.rotateControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - kControlSize, self.frame.size.height - kControlSize, kControlSize,kControlSize)];
    self.rotateControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    self.rotateControl.backgroundColor = [UIColor greenColor];
    [self makeVideoAntialiasing:self.rotateControl];
    
    self.rotateControl.userInteractionEnabled = YES;
    UIPanGestureRecognizer *rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    rotateGesture.delegate = self;
    [self.rotateControl addGestureRecognizer:rotateGesture];
    [self addSubview:self.rotateControl];
    
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x);
    
    [self bringSubviewToFront:self.changeWidthControl];
    [self bringSubviewToFront:self.changeHeightControl];
    [self bringSubviewToFront:self.rotateControl];
    
    [self bringSubviewToFront:self.deleteControl];
    [self bringSubviewToFront:self.editControl];
    
    self.contentView.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
    [self.contentView setMinimumScaleFactor:5.0/self.contentView.font.pointSize];
    self.contentView.textAlignment = NSTextAlignmentCenter;
    self.contentView.minimumScaleFactor = 0.5f;
    self.contentView.numberOfLines = 0;
    self.contentView.adjustsFontSizeToFitWidth = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeText) userInfo:nil repeats:YES];
}

- (void)changeText
{
    self.contentView.text = [LoremIpsum sentencesWithNumber:5];
}


#pragma mark - UIGestureRecognizerHandle

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {

    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        CGPoint translatedCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
        
        if (translatedCenter.y - delta <= 0) {
            translatedCenter.y = delta;
        }
        
        if (translatedCenter.y + delta >= self.superview.bounds.size.height) {
            translatedCenter.y = self.superview.bounds.size.height - delta;
        }
        
        if (translatedCenter.x - delta <= 0) {
            translatedCenter.x = delta;
        }
        
        if (translatedCenter.x + delta >= self.superview.bounds.size.width) {
            translatedCenter.x = self.superview.bounds.size.width - delta;
        }
        
        [self setCenter:translatedCenter];
        [gestureRecognizer setTranslation:CGPointZero inView:self];
    }
    else {
        
    }
}

- (void)handleChangeWidth:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer locationInView:self];
        float newWidth = self.bounds.size.width + (point.x - prevWidth);
        
        if (newWidth < minSize) newWidth = minSize;
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                 newWidth, self.bounds.size.height);
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        
    }
    
    prevWidth = [recognizer locationInView:self].x;
}

- (void)handleChangeHeight:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer locationInView:self];
        float newHeight = self.bounds.size.height + (point.y - prevHeight);
        
        if (newHeight < minSize) newHeight = minSize;
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y,
                                 self.bounds.size.width, newHeight);
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        
    }
    
    prevHeight = [recognizer locationInView:self].y;
}

- (void)handleRotate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        float angle = atan2([recognizer locationInView:self.superview].y - self.center.y,
                            [recognizer locationInView:self.superview].x - self.center.x);
        
        float angleDiff = deltaAngle - angle;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);

    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return TRUE;
}

#pragma mark - Override

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];

}

#pragma mark - Utils

- (void)makeVideoAntialiasing:(UIView *)view
{
    CALayer *layer = view.layer;
    
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor clearColor].CGColor;
    layer.shadowOpacity = 0.01;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.shouldRasterize = YES;
    
    layer.edgeAntialiasingMask = YES;
    layer.edgeAntialiasingMask = kCALayerLeftEdge|kCALayerRightEdge|kCALayerBottomEdge|kCALayerTopEdge;
}

@end

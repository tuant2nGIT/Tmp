//
//  LuuButImageView.m
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButImageView.h"

#import "LuuButUtils.h"

@interface LuuButImageView()

@property (strong, nonatomic) UIImageView *imgvContent;

@end

@implementation LuuButImageView

- (void)initialize
{
    [super initialize];
    
    self.imgvContent = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    self.imgvContent.userInteractionEnabled = NO;
    self.imgvContent.backgroundColor = [UIColor clearColor];
    self.imgvContent.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [LuuButUtils makeViewAntialiasing:self.imgvContent];
    [self.contentView addSubview:self.imgvContent];
}

#pragma mark - Method

- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    [self.imgvContent setImage:[UIImage imageWithData:imageData]];
}

- (void)setSizeRatio:(float)ration
{
    delta = 2.0*viewGlobalInset;
    sizeRatio = ration;
    
    float min = 3.0*viewControlSize - 2.0*viewGlobalInset;
    if (sizeRatio > 1) {
        minHeight = min;
        minWidth = [LuuButUtils round:min*sizeRatio toPlace:0];
    }
    else {
        minWidth = min;
        minHeight = [LuuButUtils round:min/sizeRatio toPlace:0];
    }
    
    minWidth += 2.0*viewGlobalInset;
    minHeight += 2.0*viewGlobalInset;
}

- (void)setBounds:(CGRect)bounds
{
    if (bounds.size.width > maxWidth ||
        bounds.size.height > maxHeight)
    {
        bounds.size.width = maxWidth;
        bounds.size.height = maxHeight;
    }
    [super setBounds:bounds];
}

#pragma mark - UIGestureRecognizerHandle

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
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
}

- (void)handleChangeWidth:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [gestureRecognizer locationInView:self];
        float newWidth = self.contentView.bounds.size.width + (point.x - prevWidth);
        float newHeight = newWidth/sizeRatio;
        
        newWidth += 2*viewGlobalInset;
        newHeight += 2*viewGlobalInset;
        
        if (newWidth < minWidth ||
            newHeight < minHeight)
        {
            newWidth = minWidth;
            newHeight = minHeight;
        }
        
        [self setBounds:(CGRect){CGPointZero,CGSizeMake(newWidth, newHeight)}];
    }
    
    prevWidth = [gestureRecognizer locationInView:self].x;
}

- (void)handleChangeHeight:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [gestureRecognizer locationInView:self];
        float newHeight = self.contentView.bounds.size.height + (point.y - prevHeight);
        float newWidth = newHeight*sizeRatio;
        
        newWidth += 2*viewGlobalInset;
        newHeight += 2*viewGlobalInset;
        
        if (newWidth < minWidth ||
            newHeight < minHeight)
        {
            newWidth = minWidth;
            newHeight = minHeight;
        }
        
        [self setBounds:(CGRect){CGPointZero,CGSizeMake(newWidth, newHeight)}];
    }
    
    prevHeight = [gestureRecognizer locationInView:self].y;
}

@end

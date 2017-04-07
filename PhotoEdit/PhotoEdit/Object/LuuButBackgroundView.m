//
//  LuuButBackgroundView.m
//  PhotoEdit
//
//  Created by TuanTN8 on 3/29/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButBackgroundView.h"

@interface LuuButBackgroundView()
{
    CGSize beforeSize;
}

@property (nonatomic, strong) UIImageView *imgvBackground;

@end

@implementation LuuButBackgroundView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    self.imgvBackground = [[UIImageView alloc] init];
    self.imgvBackground.backgroundColor = [UIColor clearColor];
    
    [self.imgvBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.imgvBackground];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[IMV]|" options:0 metrics:nil views:@{@"IMV":self.imgvBackground}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[IMV]|" options:0 metrics:nil views:@{@"IMV":self.imgvBackground}]];
}

- (void)layoutSubviews
{
    if (beforeSize.width != self.bounds.size.width &&
        beforeSize.height != self.bounds.size.height)
    {
        beforeSize = self.bounds.size;
        
        if ([self.delegate respondsToSelector:@selector(backgroundDidChangeBounds:)]) {
            [self.delegate backgroundDidChangeBounds:beforeSize];
        }
    }
    [super layoutSubviews];
}

- (void)setImage:(UIImage *)image
{
    self.imgvBackground.image = image;
}

@end

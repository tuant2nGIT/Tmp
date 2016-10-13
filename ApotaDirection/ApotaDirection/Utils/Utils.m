//
//  Utils.m
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark - UIColor

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    return [self colorWithRGBHex:hex andAlpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex andAlpha:(float)alpha
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

+ (void)configNavigationBar
{
    UIFont *navigationFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
    UIColor *navigationColor = [self colorWithRGBHex:0x017ee6];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:navigationFont,
                                                           NSForegroundColorAttributeName:navigationColor}];
    
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setOpaque:NO];
    }
}

+ (UIBarButtonItem *)customBackNavigationWithTarget:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.0, 0.0, 30.0, 40.0)];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setImage:[UIImage imageNamed:@"btnBack.png"] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    button.multipleTouchEnabled = NO;
    button.exclusiveTouch = YES;
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (void)setIsShowNetworkIndicator:(BOOL)isShow
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = isShow;
}

+ (id)loadView:(Class)viewClass fromXib:(NSString *)xibName
{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    id retView = nil;
    for (id object in bundle) {
        if ([object isKindOfClass:viewClass]) {
            retView = object;
            break;
        }
    }
    return retView;
}

@end

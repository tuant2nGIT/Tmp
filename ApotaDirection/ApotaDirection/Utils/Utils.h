//
//  Utils.h
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const GOOGLE_MAP_API_KEY = @"AIzaSyAXj_ykruCRzgLGvrX8V81g7xo9JvlvqyY";
static NSString *const GOOGLE_DIRECTIONS_API_KEY = @"AIzaSyDTOKIuJloXG3-Gm5tfeIohbfLkucoirGA";
static NSString *const HISTORY_SEARCH = @"HISTORY_SEARCH";

@interface Utils : NSObject

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithRGBHex:(UInt32)hex andAlpha:(float)alpha;

+ (void)configNavigationBar;
+ (UIBarButtonItem *)customBackNavigationWithTarget:(id)target selector:(SEL)selector;

+ (void)setIsShowNetworkIndicator:(BOOL)isShow;

+ (id)loadView:(Class)viewClass fromXib:(NSString *)xibName;

@end

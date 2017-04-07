//
//  LuuButUtils.h
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const float viewGlobalInset;
extern const float viewControlSize;

@interface LuuButUtils : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (float)roundNumber:(float)value;
+ (float)round:(float)value toPlace:(int)place;

+ (CGSize)getPreviewSizeWithVideoSize:(CGSize)videoSize boundsSize:(CGSize)boundsSize;

+ (void)makeViewAntialiasing:(UIView *)view;
+ (void)makeLayerAntialiasing:(CALayer *)layer;

+ (int)findFontSizeToFitSize:(CGSize)fitSize widthText:(NSString *)text fontName:(NSString *)fontName minFontSize:(int)min;

+ (NSString *)templateDownloadFilePath:(NSString *)templateName;
+ (NSString *)templateContentFolderPath:(NSString *)templateName;

@end

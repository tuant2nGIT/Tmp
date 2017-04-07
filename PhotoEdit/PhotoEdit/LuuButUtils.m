//
//  LuuButUtils.m
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButUtils.h"

const float viewGlobalInset = 10.0;
const float viewControlSize = 20.0;

@implementation LuuButUtils

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (float)roundNumber:(float)value
{
    return [self round:value toPlace:3];
}

+ (float)round:(float)value toPlace:(int)place
{
    double divisor = pow(10.0, (double)place);
    double retValue = round(value * divisor) / divisor;
    
    NSString *number = [NSString stringWithFormat:@"%%.%df",place];
    return [[NSString stringWithFormat:number,retValue] floatValue];
}

+ (CGSize)getPreviewSizeWithVideoSize:(CGSize)videoSize boundsSize:(CGSize)boundsSize
{
    CGPoint scaleRatio = CGPointZero;
    scaleRatio.x = videoSize.width/boundsSize.width;
    scaleRatio.y = videoSize.height/boundsSize.height;
    float scaleFactor = MAX(scaleRatio.x, scaleRatio.y);
    
    return CGSizeMake(ceilf(scaleRatio.x*boundsSize.width/scaleFactor),
                      ceilf(scaleRatio.y*boundsSize.height/scaleFactor));
}

+ (void)makeViewAntialiasing:(UIView *)view
{
    [self makeLayerAntialiasing:view.layer];
}

+ (void)makeLayerAntialiasing:(CALayer *)layer
{
    layer.borderWidth = 1.0;
    layer.borderColor = [UIColor clearColor].CGColor;
    layer.shadowOpacity = 0.01;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    layer.shouldRasterize = YES;
    
    layer.edgeAntialiasingMask = YES;
    layer.edgeAntialiasingMask = kCALayerLeftEdge|kCALayerRightEdge|kCALayerBottomEdge|kCALayerTopEdge;
}

+ (int)findFontSizeToFitSize:(CGSize)fitSize widthText:(NSString *)text fontName:(NSString *)fontName minFontSize:(int)min
{
    int fontSize = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    for (int size = min; size < INT_MAX; size++)
    {
        UIFont *font = [UIFont fontWithName:fontName size:size];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{NSFontAttributeName:font,
                                                                                      NSParagraphStyleAttributeName:paragraphStyle}];
        
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        CGRect rectSize = [attrString boundingRectWithSize:CGSizeMake(fitSize.width, CGFLOAT_MAX)
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   context:context];
        if (ceil(rectSize.size.height) > fitSize.height) {
            fontSize = (size - 1)*context.actualScaleFactor;
            break;
        }
    }
    return fontSize;
}

+ (NSString *)templateDownloadFilePath:(NSString *)templateName
{
    NSString *templateDownloadFilePath = [[self templateFolderPath] stringByAppendingPathComponent:templateName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:templateDownloadFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:templateDownloadFilePath error:nil];
    }
    return [[self templateFolderPath] stringByAppendingString:templateName];
}

+ (NSString *)templateContentFolderPath:(NSString *)templateName
{
    NSString *templateContentFolderPath = [[self templateFolderPath] stringByAppendingPathComponent:templateName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:templateContentFolderPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:templateContentFolderPath error:nil];
    }
    return templateContentFolderPath;
}

+ (NSString *)templateFolderPath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *templateFolderPath = [cachePath stringByAppendingPathComponent:@"LuuButTemplate"];
    
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:templateFolderPath isDirectory:&isDirectory]) {
        if (isDirectory) {
            return templateFolderPath;
        }
        else {
            [[NSFileManager defaultManager] removeItemAtPath:templateFolderPath error:nil];
        }
    }
    
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:templateFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        return nil;
    }
    return templateFolderPath;
}

@end

//
//  FontColorPickerView.h
//  KaraSlide
//
//  Created by TuanTN8 on 9/16/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontColorPickerView : UIView

- (void)showWithCurrentFontName:(NSString *)fontName demoText:(NSString *)demoText block:(void (^)(NSString *fontName))handler;
- (void)showWithCurrentColor:(UIColor *)color block:(void (^)(UIColor *color))handler;

- (void)hide:(void (^)())completion;

@end

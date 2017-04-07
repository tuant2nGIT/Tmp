//
//  CustomActionSheet.h
//  SlideMaker2.0
//
//  Created by TuanTN8 on 2/11/17.
//  Copyright © 2017 TuanTN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomActionSheet;

typedef void (^ActionSheetDidSelectSheetBlock)(NSInteger index);

@interface CustomActionSheet : UIView

- (id)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle actionTitles:(NSArray *)actionTitles selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock;

- (void)show;
- (void)dismiss;

- (NSInteger)firstButtonIndex;
- (NSInteger)destructiveButtonIndex;
- (NSInteger)cancelButtonIndex;

@end

//
//  CustomActionSheetCell.h
//  SRActionSheetDemo
//
//  Created by TuanTN8 on 2/11/17.
//  Copyright © 2017 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActionSheetCell : UITableViewCell

- (void)configWithItem:(NSString *)item;
- (void)setShowLine:(BOOL)isShow;

+ (CGFloat)height;

@end

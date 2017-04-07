//
//  CustomActionSheetCell.m
//  SRActionSheetDemo
//
//  Created by TuanTN8 on 2/11/17.
//  Copyright © 2017 SR. All rights reserved.
//

#import "CustomActionSheetCell.h"

@interface CustomActionSheetCell()

@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UIView *line, *background;

@end

@implementation CustomActionSheetCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.line.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    
    self.title.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    self.title.textColor = [UIColor darkTextColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.background.backgroundColor = highlighted?[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]:[UIColor whiteColor];
}

- (void)configWithItem:(NSString *)item
{
    self.title.text = item;
}

- (void)setShowLine:(BOOL)isShow
{
    self.line.hidden = !isShow;
}

+ (CGFloat)height
{
    return 40.0;
}

#pragma mark - Utils

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

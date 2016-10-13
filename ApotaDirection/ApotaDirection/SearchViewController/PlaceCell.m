//
//  PlaceCell.m
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "PlaceCell.h"

#import "LocationObject.h"

@interface PlaceCell()

@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, weak) IBOutlet UIImageView *imgvPlaceIcon;
@property (nonatomic, weak) IBOutlet UILabel *lblPlaceName, *lblPlaceDescription;

@end

@implementation PlaceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self emptyView];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.bgView.backgroundColor = highlighted?[UIColor colorWithWhite:0.0 alpha:0.1]:[UIColor whiteColor];
}

- (void)emptyView
{
    self.lblPlaceName.attributedText = nil;
    self.lblPlaceName.text = nil;
    
    self.lblPlaceDescription.attributedText = nil;
    self.lblPlaceDescription.text = nil;
}

+ (CGFloat)height
{
    return 50.0;
}

#pragma mark - GMSAutocompletePrediction

- (void)configWithInfo:(GMSAutocompletePrediction *)info
{
    self.imgvPlaceIcon.image = [UIImage imageNamed:@"ic_place_gray.png"];
    [self configPlaceName:info];
    [self configPlaceDescription:info];
}

- (void)configPlaceName:(GMSAutocompletePrediction *)info
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    
    NSMutableAttributedString *bolded = [info.attributedPrimaryText mutableCopy];
    [bolded enumerateAttribute:kGMSAutocompleteMatchAttribute inRange:NSMakeRange(0, bolded.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
         UIFont *font = (value == nil) ? regularFont : boldFont;
         [bolded addAttribute:NSFontAttributeName value:font range:range];
     }];
    
    self.lblPlaceName.attributedText = bolded;
}

- (void)configPlaceDescription:(GMSAutocompletePrediction *)info
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    UIFont *boldFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:11.0];
    
    NSMutableAttributedString *bolded = [info.attributedSecondaryText mutableCopy];
    [bolded enumerateAttribute:kGMSAutocompleteMatchAttribute inRange:NSMakeRange(0, bolded.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
         UIFont *font = (value == nil) ? regularFont : boldFont;
         [bolded addAttribute:NSFontAttributeName value:font range:range];
     }];
    
    self.lblPlaceDescription.attributedText = bolded;
}

#pragma mark - GMSPlace

- (void)configWithLocation:(LocationObject *)location
{
    self.imgvPlaceIcon.image = [UIImage imageNamed:@"ic_history_gray.png"];
    
    self.lblPlaceName.text = location.name;
    self.lblPlaceName.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    
    self.lblPlaceDescription.text = location.address;
    self.lblPlaceDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
}

@end

//
//  PlaceCell.h
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GooglePlaces;
@class LocationObject;

@interface PlaceCell : UITableViewCell

+ (CGFloat)height;

- (void)configWithInfo:(GMSAutocompletePrediction *)info;
- (void)configWithLocation:(LocationObject *)location;
- (void)emptyView;

@end

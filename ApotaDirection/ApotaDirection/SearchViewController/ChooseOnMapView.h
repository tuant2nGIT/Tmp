//
//  ChooseOnMapCell.h
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseOnMapViewDelegate <NSObject>

- (void)didSelectChoosePlaceOnMap;

@end

@interface ChooseOnMapView : UIView

@property (nonatomic, weak) id<ChooseOnMapViewDelegate> delegate;

@end

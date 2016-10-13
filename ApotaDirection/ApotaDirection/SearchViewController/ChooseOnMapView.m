//
//  ChooseOnMapCell.m
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "ChooseOnMapView.h"

@implementation ChooseOnMapView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)touchChooseOnMap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectChoosePlaceOnMap)]) {
        [self.delegate didSelectChoosePlaceOnMap];
    }
}

@end

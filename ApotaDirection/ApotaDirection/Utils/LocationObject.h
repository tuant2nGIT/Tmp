//
//  LocationObject.h
//  ApotaDirection
//
//  Created by TuanTN on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GooglePlaces;

@interface LocationObject : NSObject

@property (nonatomic, strong) NSString *placeID, *name, *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(GMSPlace *)location;
- (id)initWithInfo:(NSDictionary *)locationInfo;

@end

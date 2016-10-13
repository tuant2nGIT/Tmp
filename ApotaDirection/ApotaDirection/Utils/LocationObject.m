//
//  LocationObject.m
//  ApotaDirection
//
//  Created by TuanTN on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "LocationObject.h"

@implementation LocationObject

- (id)initWithLocation:(GMSPlace *)location
{
    self = [super init];
    if (self)
    {
        _placeID = location.placeID;
        _name = location.name;
        _address = location.formattedAddress;
        _coordinate = location.coordinate;
    }
    return self;
}

- (id)initWithInfo:(NSDictionary *)locationInfo
{
    self = [super init];
    if (self)
    {
        _placeID = locationInfo[@"placeID"];
        _name = locationInfo[@"name"];
        _address = locationInfo[@"address"];
        _coordinate = CLLocationCoordinate2DMake([locationInfo[@"lat"] floatValue], [locationInfo[@"long"] floatValue]);
    }
    return self;
}


@end

//
//  SearchViewController.h
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMaps;
@import GooglePlaces;

@class LocationObject;

@protocol SearchViewControllerDelegate <NSObject>

- (void)didSelectLocation:(LocationObject *)location isStartLocation:(BOOL)isStartLocation;

@end

@interface SearchViewController : UIViewController

@property (nonatomic, weak) id<SearchViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isSearchForStartLocation;

@end

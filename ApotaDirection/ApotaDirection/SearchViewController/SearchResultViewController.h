//
//  SearchResultViewController.h
//  ApotaDirection
//
//  Created by TuanTN8 on 10/13/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GooglePlaces;

@protocol SearchResultViewControllerDelegate <NSObject>

- (void)didSelectPlace:(GMSAutocompletePrediction *)info;
- (void)didSelectOpenMap;

@end

@interface SearchResultViewController : UITableViewController

@property (nonatomic, weak) id<SearchResultViewControllerDelegate> delegate;

- (void)setResult:(NSArray *)result;

@end

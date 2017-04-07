//
//  LuuButImageView.h
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LuuButView.h"

@interface LuuButImageView : LuuButView

@property (nonatomic, strong) NSString *imagePath;

- (void)setSizeRatio:(float)ration;

@end

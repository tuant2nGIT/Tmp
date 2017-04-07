//
//  LuuButBackgroundView.h
//  PhotoEdit
//
//  Created by TuanTN8 on 3/29/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LuuButBackgroundViewDelegate <NSObject>

- (void)backgroundDidChangeBounds:(CGSize)newBounds;

@end

@interface LuuButBackgroundView : UIView

@property (nonatomic, weak) id<LuuButBackgroundViewDelegate> delegate;

- (void)setImage:(UIImage *)image;

@end

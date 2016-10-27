//
// ZDStickerView.h
//
// Created by Seonghyun Kim on 5/29/13.
// Copyright (c) 2013 scipi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZDStickerViewDelegate;


@interface ZDStickerView : UIView

@property (weak, nonatomic) id <ZDStickerViewDelegate> stickerViewDelegate;

@end


@protocol ZDStickerViewDelegate <NSObject>
@required
@optional
- (void)stickerViewDidBeginEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidEndEditing:(ZDStickerView *)sticker;
- (void)stickerViewDidCancelEditing:(ZDStickerView *)sticker;

- (void)stickerViewDidClose:(ZDStickerView *)sticker;
- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker;
@end

//
//  ViewController.m
//  ZDStickerViewApp
//
//  Created by zedoul on 5/29/13.
//  Copyright (c) 2013 scipi. All rights reserved.
//

#import "ViewController.h"
#import "ZDStickerView.h"

@interface ViewController () <ZDStickerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect gripFrame2 = CGRectMake(50, 200, 180, 180);
    UITextView *textView = [[UITextView alloc] initWithFrame:gripFrame2];
    textView.text = @"ZDStickerView is Objective-C module for iOS and offer complete configurability, including movement, resizing, rotation and more, with one finger.";
    textView.userInteractionEnabled = NO;
    textView.backgroundColor = [UIColor blueColor];
    
    ZDStickerView *userResizableView2 = [[ZDStickerView alloc] initWithFrame:gripFrame2];
    userResizableView2.tag = 1;
    userResizableView2.stickerViewDelegate = self;
    [self.view addSubview:userResizableView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate functions

- (void)stickerViewDidLongPressed:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidClose:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);

}

@end

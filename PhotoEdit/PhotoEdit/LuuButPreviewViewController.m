//
//  LuuButPreviewViewController.m
//  PhotoEdit
//
//  Created by TuanTN8 on 4/7/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButPreviewViewController.h"

@interface LuuButPreviewViewController ()

@property (nonatomic, weak) IBOutlet UIButton *btnBack, *btnSave, *btnShare;
@property (nonatomic, weak) IBOutlet UIImageView *imgvLuuBut;

@end

@implementation LuuButPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Action

- (IBAction)touchBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchSave:(id)sender
{
    
}

- (IBAction)touchShare:(id)sender
{
    
}

#pragma mark - SetupUI

- (void)setupUI
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.imgvLuuBut.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

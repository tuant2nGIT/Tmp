//
//  FontColorPickerView.m
//  KaraSlide
//
//  Created by TuanTN8 on 9/16/16.
//  Copyright © 2016 Storm. All rights reserved.
//

#import "FontColorPickerView.h"

typedef enum {
    kPickerTypeNone = 0,
    kPickerTypeFont = 1,
    kPickerTypeColor = 2,
} kPickerType;

@interface FontColorPickerView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewPosition;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) UIButton *btnCancel, *btnDone;
@property (strong, nonatomic) UILabel *lblTitle;

@property (assign, nonatomic) kPickerType pickerType;
@property (strong, nonatomic) NSString *demoText;
@property (strong, nonatomic) NSArray *fontList;
@property (strong, nonatomic) NSArray *colorList;

@property (nonatomic, strong) void (^selectFont)(NSString *fontName);
@property (nonatomic, strong) void (^selectColor)(UIColor *color);

@end

@implementation FontColorPickerView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self = [[[NSBundle mainBundle]loadNibNamed:@"FontColorPickerView" owner:nil options:nil] firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        
        self.contentViewPosition.constant = -CGRectGetHeight(self.contentView.frame);
        
        self.toolBar.barTintColor = [UIColor whiteColor];
        self.toolBar.translucent = NO;
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [self.toolBar setItems:@[[[UIBarButtonItem alloc] initWithCustomView:self.btnCancel],flexibleSpace,
                                 [[UIBarButtonItem alloc] initWithCustomView:self.lblTitle],flexibleSpace,
                                 [[UIBarButtonItem alloc] initWithCustomView:self.btnDone]]];
        
        self.backView.userInteractionEnabled = YES;
        [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDissmiss:)]];
    }
    
    return self;
}

- (UIButton *)btnCancel
{
    if (!_btnCancel) {
        _btnCancel = [self createBarButtonWithTitle:@"Cancel" font:[UIFont fontWithName:@"HelveticaNeue" size:15.0] textColor:0x5e48cd position:UIControlContentHorizontalAlignmentCenter target:self action:@selector(touchDissmiss:)];
        _btnCancel.frame = CGRectMake(0.0, 0.0, 80.0, 40.0);
    }
    return _btnCancel;
}

- (UIButton *)btnDone
{
    if (!_btnDone) {
        _btnDone = [self createBarButtonWithTitle:@"Done" font:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0] textColor:0x5e48cd position:UIControlContentHorizontalAlignmentCenter target:self action:@selector(touchDone:)];
        _btnDone.frame = CGRectMake(0.0, 0.0, 80.0, 40.0);
    }
    return _btnDone;
}

- (UILabel *)lblTitle
{
    if (!_lblTitle) {
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
        _lblTitle.textColor = [self colorWithRGBHex:0x5e48cd];
        _lblTitle.frame = CGRectMake(0.0, 0.0, 120.0, 40.0);
    }
    return _lblTitle;
}

#pragma mark - Method

- (void)showWithCurrentFontName:(NSString *)fontName demoText:(NSString *)demoText block:(void (^)(NSString *fontName))handler
{
    self.pickerType = kPickerTypeFont;
    self.demoText = demoText;
    
    if (handler) {
        self.selectFont = handler;
    }
    
    NSInteger fontIndex = [self.fontList indexOfObject:fontName];
    if (fontIndex != NSNotFound) {
        [self.pickerView selectRow:fontIndex inComponent:0 animated:NO];
    }
    
    [self show];
}

- (void)showWithCurrentColor:(UIColor *)color block:(void (^)(UIColor *color))handler
{
    self.pickerType = kPickerTypeColor;
    
    if (handler) {
        self.selectColor = handler;
    }
    
    NSInteger colorIndex = [self.colorList indexOfObject:color];
    if (colorIndex != NSNotFound) {
        [self.pickerView selectRow:colorIndex inComponent:0 animated:NO];
    }
    
    [self show];
}

- (void)setPickerType:(kPickerType)pickerType
{
    _pickerType = pickerType;
    
    NSString *title = nil;
    if (self.pickerType == kPickerTypeFont) {
        title = @"Text Font";
    }
    else if (self.pickerType == kPickerTypeColor) {
        title = @"Text Color";
    }
    
    self.lblTitle.text = title;
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [self layoutIfNeeded];
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
        self.contentViewPosition.constant = 0.0;
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)hide:(void (^)())completion
{
    [self layoutIfNeeded];
    self.alpha = 1.0;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
        self.contentViewPosition.constant = -CGRectGetHeight(self.contentView.frame);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Action

- (void)touchDissmiss:(UIButton *)sender {
    [self hide:nil];
}

- (void)touchDone:(UIButton *)sender
{
    if (self.pickerType == kPickerTypeFont) {
        NSUInteger iSelectedFontRow = [self.pickerView selectedRowInComponent:0];
        NSString *fontName = self.fontList[iSelectedFontRow];
        
        [self hide:^{
            if (self.selectFont) {
                self.selectFont(fontName);
            }
            self.selectFont = nil;
        }];
    }
    else if (self.pickerType == kPickerTypeColor) {
        NSUInteger iSelectedColorRow = [self.pickerView selectedRowInComponent:0];
        UIColor *color = self.colorList[iSelectedColorRow];
        
        [self hide:^{
            if (self.selectColor) {
                self.selectColor(color);
            }
            self.selectColor = nil;
        }];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerType == kPickerTypeFont) {
        return self.fontList.count;
    }
    else if (self.pickerType == kPickerTypeColor) {
        return self.colorList.count;
    }
    return -1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return CGRectGetWidth(pickerView.frame);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    if (self.pickerType == kPickerTypeFont) {
        NSString *sFontName = self.fontList[row];
        
        UILabel *lblFontName = [[UILabel alloc] init];
        lblFontName.adjustsFontSizeToFitWidth = YES;
        lblFontName.font = [UIFont fontWithName:sFontName size:15.0];
        lblFontName.textAlignment = NSTextAlignmentCenter;
        lblFontName.textColor = [UIColor darkTextColor];
        lblFontName.text = self.demoText;
        
        return lblFontName;
    }
    else if (self.pickerType == kPickerTypeColor) {
        UIColor *color = self.colorList[row];
        
        UIView *colorView = [[UIView alloc] init];
        colorView.backgroundColor = color;
        colorView.layer.borderWidth = 1.0;
        colorView.layer.borderColor = [UIColor blackColor].CGColor;
        
        return colorView;
    }
    
    return nil;
}

#pragma mark - InitData

- (NSArray *)fontList
{
    if (_fontList.count) {
        return _fontList;
    }
    
    NSMutableArray *fonts = [[NSMutableArray alloc] init];
    NSArray *listFont = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIAppFonts"];
    
    for (NSString *name in listFont) {
        NSString *fontName = [name stringByDeletingPathExtension];
        [fonts addObject:fontName];
    }
    
    _fontList = fonts;
    return _fontList;
}

- (NSArray *)colorList
{
    if (_colorList.count) {
        return _colorList;
    }
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    [colors addObject:[UIColor whiteColor]];
    
    NSInteger colorCount = 36;
    NSInteger createdColors = 0;
    CGFloat hueStep = 1.0/colorCount;
    
    CGFloat currentHue = 0.0;
    
    while (createdColors < colorCount) {
        UIColor *tmpColor = [UIColor colorWithHue:currentHue saturation:1.0 brightness:1.0 alpha:1.0];
        [colors addObject:tmpColor];
        
        currentHue += hueStep;
        createdColors++;
    }
    
    [colors addObject:[UIColor blackColor]];
    
    _colorList = [colors copy];
    return _colorList;
}

#pragma mark - Utils

- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0];
}

- (UIButton *)createBarButtonWithTitle:(NSString *)sTitle font:(UIFont *)font textColor:(UInt32)hexColor position:(UIControlContentHorizontalAlignment)position target:(id)target action:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setContentHorizontalAlignment:position];
    button.multipleTouchEnabled = YES;
    button.exclusiveTouch = YES;
    button.backgroundColor = [UIColor clearColor];
    
    float titleWidth = 0.0;
    float imageWidth = 0.0;
    
    if (sTitle) {
        [button setTitle:sTitle forState:UIControlStateNormal];
        
        if (!font) {
            font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        }
        button.titleLabel.font = font;
        
        UIColor *normalColor = [self colorWithRGBHex:hexColor];
        UIColor *highlightedColor = [UIColor lightGrayColor];
        
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [button setTitleColor:highlightedColor forState:UIControlStateSelected];
        [button setTitleColor:highlightedColor forState:UIControlStateDisabled];
        
        titleWidth = [self getWidthWithString:sTitle font:font];
    }
    
    float width = imageWidth + titleWidth;
    width += 5.0;
    
    if (width < 40.0) width = 40.0;
    [button setFrame:CGRectMake(0.0, 0.0, width, 40.0)];
    
    return button;
}

- (float)getWidthWithString:(NSString *)contentString font:(UIFont *)font
{
    return ceilf([contentString sizeWithAttributes:@{NSFontAttributeName:font}].width);
}

@end

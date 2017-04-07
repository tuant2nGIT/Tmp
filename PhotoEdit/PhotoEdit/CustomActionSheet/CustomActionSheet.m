//
//  CustomActionSheet.m
//  SlideMaker2.0
//
//  Created by TuanTN8 on 2/11/17.
//  Copyright © 2017 TuanTN. All rights reserved.
//

#import "CustomActionSheet.h"

#import "CustomActionSheetCell.h"

#define kActionSheetColor            [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f]
#define kTitleColor                  [UIColor colorWithRed:111.0f/255.0f green:111.0f/255.0f blue:111.0f/255.0f alpha:1.0f]
#define kActionItemHighlightedColor  [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]
#define kDestructiveItemNormalColor  [UIColor colorWithRed:255.0f/255.0f green:10.00f/255.0f blue:10.00f/255.0f alpha:1.0f]
#define kDividerColor                [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f]

const NSInteger destructiveButtonIndex = -1;
const NSInteger cancelButtonIndex = -2;

@interface CustomActionSheet() <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) ActionSheetDidSelectSheetBlock selectSheetBlock;

@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSLayoutConstraint *contentViewPosition;
@property (nonatomic, assign) CGFloat contentViewHeight;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) NSString *destructiveTitle;

@property (nonatomic, strong) NSArray *actionItems;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;

@end

@implementation CustomActionSheet

#pragma mark - Init

- (id)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle actionTitles:(NSArray *)actionTitles selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock
{
    if (self = [self initWithFrame:[UIScreen mainScreen].bounds])
    {
        _title = title;
        _cancelTitle = cancelTitle;
        _destructiveTitle = destructiveTitle;
        _actionItems = actionTitles;
        
        _selectSheetBlock = selectSheetBlock;
        
        [self setupUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|
        UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (NSInteger)firstButtonIndex
{
    return 0;
}

- (NSInteger)destructiveButtonIndex
{
    return destructiveButtonIndex;
}

- (NSInteger)cancelButtonIndex
{
    return cancelButtonIndex;
}

#pragma mark - SetupUI

- (void)setupUI
{
    _cover = [[UIView alloc] init];
    _cover.translatesAutoresizingMaskIntoConstraints = NO;
    _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _cover.alpha = 0;
    [_cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self addSubview:_cover];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CV]|" options:0 metrics:nil views:@{@"CV":_cover}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[CV]|" options:0 metrics:nil views:@{@"CV":_cover}]];

    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    float fTitleHeight = 0.0;
    float fContentHeight = 0.0;
    float fDestructiveHeight = 0.0;
    float fCancelHeight = 0.0;
    
    if (_title && _title.length > 0) {
        fTitleHeight = 40.0;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:titleLabel];
        
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = kTitleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        titleLabel.numberOfLines = 0;
        titleLabel.text = _title;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[TL]|" options:0 metrics:nil views:@{@"TL":titleLabel}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[TL(40.0)]" options:0 metrics:nil views:@{@"TL":titleLabel}]];
        
        UIView *line = [[UIView alloc] init];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = kActionSheetColor;
        [titleLabel addSubview:line];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[L]|" options:0 metrics:nil views:@{@"L":line}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[L(1.0)]|" options:0 metrics:nil views:@{@"L":line}]];
    }
    
    if (_actionItems && _actionItems.count > 0)
    {
        UITableView *tblListActions = [[UITableView alloc] init];
        tblListActions.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:tblListActions];
        
        int iNumberOfButton = (int)_actionItems.count;
        if (iNumberOfButton > 4) {
            iNumberOfButton = 4;
            tblListActions.scrollEnabled = YES;
        }
        else {
            tblListActions.scrollEnabled = NO;
        }
        
        tblListActions.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblListActions.showsVerticalScrollIndicator = NO;
        tblListActions.showsHorizontalScrollIndicator = NO;
        tblListActions.pagingEnabled = YES;
        [tblListActions registerNib:[UINib nibWithNibName:@"CustomActionSheetCell" bundle:nil] forCellReuseIdentifier:@"CustomActionSheetCellId"];
        
        tblListActions.dataSource = self;
        tblListActions.delegate = self;
        [tblListActions reloadData];
        
        fContentHeight = [CustomActionSheetCell height]*iNumberOfButton;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[TBL]|" options:0 metrics:nil views:@{@"TBL":tblListActions}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(position)-[TBL(height)]"
                                                                     options:0
                                                                     metrics:@{@"position":@(fTitleHeight),
                                                                               @"height":@(fContentHeight)}
                                                                       views:@{@"TBL":tblListActions}]];
    }
    
    if (_destructiveTitle && _destructiveTitle.length > 0) {
        fDestructiveHeight = 40.0;
        
        UIButton *destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        destructiveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:destructiveButton];
        
        destructiveButton.backgroundColor = [UIColor whiteColor];
        destructiveButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        [destructiveButton setTitleColor:kDestructiveItemNormalColor forState:UIControlStateNormal];
        [destructiveButton setTitle:_destructiveTitle forState:UIControlStateNormal];
        [destructiveButton setBackgroundImage:self.normalImage forState:UIControlStateNormal];
        [destructiveButton setBackgroundImage:self.highlightedImage forState:UIControlStateHighlighted];
        [destructiveButton addTarget:self action:@selector(touchDestructiveButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[DB]|" options:0 metrics:nil views:@{@"DB":destructiveButton}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(position)-[DB(40.0)]"
                                                                     options:0
                                                                     metrics:@{@"position":@(fTitleHeight + fContentHeight)}
                                                                       views:@{@"DB":destructiveButton}]];
        
        UIView *line = [[UIView alloc] init];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = kActionSheetColor;
        [destructiveButton addSubview:line];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[L]|" options:0 metrics:nil views:@{@"L":line}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[L(1.0)]" options:0 metrics:nil views:@{@"L":line}]];
    }
    
    if (_cancelTitle) {
        fCancelHeight += 5.0;
        fCancelHeight += 40.0;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:cancelBtn];
        
        cancelBtn.backgroundColor = [UIColor greenColor];
        cancelBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:_cancelTitle forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:self.normalImage forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:self.highlightedImage forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(touchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *dividerView = [[UIView alloc] init];
        dividerView.translatesAutoresizingMaskIntoConstraints = NO;
        dividerView.backgroundColor = kDividerColor;
        [_contentView addSubview:dividerView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CB]|" options:0 metrics:nil views:@{@"CB":cancelBtn}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[DV]|" options:0 metrics:nil views:@{@"DV":dividerView}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[DV(5.0)][CB(40.0)]|" options:0 metrics:nil views:@{@"CB":cancelBtn,@"DV":dividerView}]];
    }
    
    _contentViewHeight = fTitleHeight + fContentHeight + fDestructiveHeight + fCancelHeight;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[CT]|" options:0 metrics:nil views:@{@"CT":_contentView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[CT(height)]" options:0 metrics:@{@"height":@(_contentViewHeight)} views:@{@"CT":_contentView}]];
    
    _contentViewPosition = [NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:_contentViewHeight];
    [self addConstraint:_contentViewPosition];
}

#pragma mark - SetupListAction

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.actionItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CustomActionSheetCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CustomActionSheetCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomActionSheetCellId"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![cell isKindOfClass:[CustomActionSheetCell class]]) {
        return;
    }
    
    CustomActionSheetCell *customActionSheetCell = (CustomActionSheetCell *)cell;
    [customActionSheetCell configWithItem:self.actionItems[indexPath.row]];
    [customActionSheetCell setShowLine:(indexPath.row != self.actionItems.count - 1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self touchButtonAtIndex:indexPath.row];
}

#pragma mark - Actions

- (void)touchCancelButton:(id)sender
{
    [self dismiss:cancelButtonIndex];
}

- (void)touchDestructiveButton:(id)sender
{
    [self dismiss:destructiveButtonIndex];
}

- (void)touchButtonAtIndex:(NSInteger)index
{
    [self dismiss:index];
}

#pragma mark - Animations

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _cover.alpha = 1.0;
        _contentViewPosition.constant = 0.0;
        
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)dismiss
{
    [self.layer removeAllAnimations];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _cover.alpha = 0.0;
        _contentViewPosition.constant = _contentViewHeight;
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismiss:(NSInteger)buttonIndex
{
    [self.layer removeAllAnimations];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _cover.alpha = 0.0;
        _contentViewPosition.constant = _contentViewHeight;
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (_selectSheetBlock) {
            _selectSheetBlock(buttonIndex);
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - ToolMethod

- (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)normalImage {
    
    if (!_normalImage) {
        _normalImage = [self imageFromColor:[UIColor whiteColor]];
    }
    return _normalImage;
}

- (UIImage *)highlightedImage {
    
    if (!_highlightedImage) {
        _highlightedImage = [self imageFromColor:kActionItemHighlightedColor];
    }
    return _highlightedImage;
}

- (void)dealloc
{
    
}

@end

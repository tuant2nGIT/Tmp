//
//  LuuButView.m
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButView.h"
#import "LuuButUtils.h"

@interface LuuButView() <UIGestureRecognizerDelegate>
{
    int lineIndex;
    int redoIndex;
}

@property (strong, nonatomic) UIImageView *changeWidthControl, *changeHeightControl, *rotateControl;
@property (strong, nonatomic) UIButton *deleteControl;

@property (nonatomic, strong) NSMutableArray *arrayState;

@end

@implementation LuuButView

@synthesize editing;

- (NSMutableArray *)arrayState
{
    if (!_arrayState) {
        _arrayState = [[NSMutableArray alloc] init];
    }
    return _arrayState;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, viewGlobalInset, viewGlobalInset)];
    self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [LuuButUtils makeViewAntialiasing:self.contentView];
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = [UIColor redColor].CGColor;
    self.contentView.userInteractionEnabled = YES;
    [self addSubview:self.contentView];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    panRecognizer.cancelsTouchesInView = NO;
    [self.contentView addGestureRecognizer:panRecognizer];
    
    //
    self.deleteControl = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteControl.frame = CGRectMake(0.0, 0.0, viewControlSize, viewControlSize);
    self.deleteControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.deleteControl.backgroundColor = [UIColor clearColor];
    [self.deleteControl setImage:[UIImage imageNamed:@"control_remove.png"] forState:UIControlStateNormal];
    [LuuButUtils makeViewAntialiasing:self.deleteControl];
    [self.deleteControl addTarget:self action:@selector(touchDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteControl];
    
    //
    self.changeWidthControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - viewControlSize, (self.frame.size.height - viewControlSize)/2.0, viewControlSize, viewControlSize)];
    self.changeWidthControl.contentMode = UIViewContentModeCenter;
    self.changeWidthControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.changeWidthControl.image = [UIImage imageNamed:@"control_change_width.png"];
    self.changeWidthControl.contentMode = UIViewContentModeScaleAspectFit;
    [LuuButUtils makeViewAntialiasing:self.changeWidthControl];
    
    self.changeWidthControl.userInteractionEnabled = YES;
    UIPanGestureRecognizer *resizeWidthGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleChangeWidth:)];
    resizeWidthGesture.delegate = self;
    resizeWidthGesture.cancelsTouchesInView = NO;
    [self.changeWidthControl addGestureRecognizer:resizeWidthGesture];
    [self addSubview:self.changeWidthControl];
    
    //
    self.changeHeightControl = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - viewControlSize)/2.0, self.frame.size.height - viewControlSize, viewControlSize, viewControlSize)];
    self.changeHeightControl.contentMode = UIViewContentModeCenter;
    self.changeHeightControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    self.changeHeightControl.image = [UIImage imageNamed:@"control_change_height.png"];
    self.changeHeightControl.contentMode = UIViewContentModeScaleAspectFit;
    [LuuButUtils makeViewAntialiasing:self.changeHeightControl];
    
    self.changeHeightControl.userInteractionEnabled = YES;
    UIPanGestureRecognizer *resizeHeightGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleChangeHeight:)];
    resizeHeightGesture.delegate = self;
    resizeHeightGesture.cancelsTouchesInView = NO;
    [self.changeHeightControl addGestureRecognizer:resizeHeightGesture];
    [self addSubview:self.changeHeightControl];
    
    //
    self.rotateControl = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - viewControlSize, self.frame.size.height - viewControlSize, viewControlSize,viewControlSize)];
    self.rotateControl.contentMode = UIViewContentModeCenter;
    self.rotateControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
    self.rotateControl.image = [UIImage imageNamed:@"control_rotate.png"];
    self.rotateControl.contentMode = UIViewContentModeScaleAspectFit;
    [LuuButUtils makeViewAntialiasing:self.rotateControl];
    
    self.rotateControl.userInteractionEnabled = YES;
    UIPanGestureRecognizer *rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    rotateGesture.delegate = self;
    rotateGesture.cancelsTouchesInView = NO;
    [self.rotateControl addGestureRecognizer:rotateGesture];
    [self addSubview:self.rotateControl];
    
    deltaAngle = atan2(self.frame.origin.y + self.frame.size.height - self.center.y,
                       self.frame.origin.x + self.frame.size.width - self.center.x);

    [self bringSubviewToFront:self.changeWidthControl];
    [self bringSubviewToFront:self.changeHeightControl];
    [self bringSubviewToFront:self.rotateControl];
    [self bringSubviewToFront:self.deleteControl];
}

#pragma mark - Method

- (void)remove
{
    self.hidden = YES;
}

#pragma mark - Undo/Redo

- (void)initialState
{
    lineIndex = 0;
    redoIndex = 0;
    
    [self.arrayState addObject:[self getCurrentState]];
}

- (LuuButState *)getCurrentState
{
    LuuButState *currentState = [[LuuButState alloc] initWithCenterPointRatio:self.centerPointRatio boundsRatio:self.boundsRatio angle:self.angle andHidden:self.hidden];
    return currentState;
}

- (void)restoreState:(LuuButState *)state
{
    CGPoint center = CGPointZero;
    center.x = self.superviewBoundsSize.width*state.centerPointRatio.width;
    center.y = self.superviewBoundsSize.height*state.centerPointRatio.height;
    [self setCenter:center];
    
    CGSize bounds = CGSizeZero;
    bounds.width = self.superviewBoundsSize.width*state.boundsRatio.width + 2*viewGlobalInset;
    bounds.height = self.superviewBoundsSize.height*state.boundsRatio.height + 2*viewGlobalInset;
    [self setBounds:(CGRect){CGPointZero, bounds}];
    
    [self setRotate:state.angle];
    
    self.hidden = state.hidden;
}

- (void)doSaveState
{
    lineIndex++;
    redoIndex = 0;
    
    if (lineIndex < self.arrayState.count) {
        [self.arrayState removeObjectsInRange:NSMakeRange(lineIndex, self.arrayState.count - lineIndex)];
    }
    
    [self.arrayState addObject:[self getCurrentState]];
}

- (void)doRemoveAllSaveState
{
    lineIndex = 0;
    redoIndex = 0;
    [self.arrayState removeAllObjects];
}

- (void)doUndo
{
    if (lineIndex > 0)
    {
        lineIndex--;
        redoIndex++;
        
        LuuButState *prevState = self.arrayState[lineIndex];
        [self restoreState:prevState];
    }
}

- (void)doRedo
{
    if (redoIndex > 0)
    {
        lineIndex++;
        redoIndex--;
        
        LuuButState *nextState = self.arrayState[lineIndex];
        [self restoreState:nextState];
    }
}

- (BOOL)canUndo
{
    return (lineIndex > 0);
}

- (BOOL)canRedo
{
    return (redoIndex > 0);
}

#pragma mark - Properties

- (void)setSuperviewBoundsSize:(CGSize)superviewBoundsSize
{
    _superviewBoundsSize = superviewBoundsSize;
    
    float min = MIN(superviewBoundsSize.width, superviewBoundsSize.height);
    if (sizeRatio > 1) {
        maxHeight = min;
        maxWidth = [LuuButUtils round:min*sizeRatio toPlace:0];;
    }
    else {
        maxWidth = min;
        maxHeight = [LuuButUtils round:min/sizeRatio toPlace:0];
    }
    
    maxWidth += 2.0*viewGlobalInset;
    maxHeight += 2.0*viewGlobalInset;
}

- (void)setEditing:(BOOL)isEditing
{
    editing = isEditing;
    self.contentView.layer.borderColor = (isEditing?[UIColor redColor].CGColor:[UIColor clearColor].CGColor);
    self.contentView.backgroundColor = (isEditing?[UIColor colorWithWhite:1.0 alpha:0.2]:[UIColor clearColor]);
    
    self.changeWidthControl.hidden = !isEditing;
    self.changeHeightControl.hidden = !isEditing;
    self.rotateControl.hidden = !isEditing;
    self.deleteControl.hidden = !isEditing;
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    
    if (CGSizeEqualToSize(CGSizeZero, self.superviewBoundsSize)) return;
    self.centerPointRatio = CGSizeMake(center.x/self.superviewBoundsSize.width, center.y/self.superviewBoundsSize.height);
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    if (CGSizeEqualToSize(CGSizeZero, self.superviewBoundsSize)) return;
    
    CGRect contentBounds = CGRectInset(bounds, viewGlobalInset, viewGlobalInset);
    self.boundsRatio = CGSizeMake(contentBounds.size.width/self.superviewBoundsSize.width, contentBounds.size.height/self.superviewBoundsSize.height);
}

- (void)setRotate:(float)rotate
{
    self.angle = rotate;
    
    if (rotate == 0) {
        self.transform = CGAffineTransformMakeRotation(0);
    }
    else {
        deltaAngle = atan2(self.frame.origin.y + self.frame.size.height - self.center.y,
                           self.frame.origin.x + self.frame.size.width - self.center.x);
        float angleDiff = deltaAngle - self.angle;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
    }
}

#pragma mark - Action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(didBeginEditLuuButView:)]) {
        [self.delegate didBeginEditLuuButView:self];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(didEndEditLuuButView:)]) {
        [self.delegate didEndEditLuuButView:self];
    }
}

- (void)touchDelete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectRemoveLuuButView:)]) {
        [self.delegate didSelectRemoveLuuButView:self];
    }
}

#pragma mark - UIGestureRecognizerHandle

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    
}

- (void)handleChangeWidth:(UIPanGestureRecognizer *)gestureRecognizer
{
    
}

- (void)handleChangeHeight:(UIPanGestureRecognizer *)gestureRecognizer
{
    
}

- (void)handleRotate:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        float angle = atan2([gestureRecognizer locationInView:self.superview].y - self.center.y,
                            [gestureRecognizer locationInView:self.superview].x - self.center.x);
        [self setRotate:angle];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@implementation LuuButState

- (id)initWithCenterPointRatio:(CGSize)centerPointRatio boundsRatio:(CGSize)boundsRatio angle:(float)angle andHidden:(BOOL)hidden
{
    self = [super init];
    if (self) {
        _centerPointRatio = centerPointRatio;
        _boundsRatio = boundsRatio;
        _hidden = hidden;
        _angle = angle;
    }
    return self;
}

- (void)setText:(NSString *)text font:(NSString *)textFont color:(UIColor *)textColor bold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline
{
    self.text = text;
    self.textFont = textFont;
    self.textColor = textColor;
    
    self.bold = bold;
    self.italic = italic;
    self.underline = underline;
}

@end

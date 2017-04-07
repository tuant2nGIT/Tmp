//
//  LuuButTextView.m
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButTextView.h"

#import "LuuButUtils.h"

@interface LuuButTextView()

@property (strong, nonatomic) UILabel *textView;

@property (strong, nonatomic) NSOperationQueue *getFontSizeQueue;

@end

@implementation LuuButTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)initValue
{
    minSize = 3.0*viewControlSize;
    delta = 2.0*viewGlobalInset;
    
    self.getFontSizeQueue = [[NSOperationQueue alloc] init];
    self.getFontSizeQueue.name = @"queue.getfontsize";
    self.getFontSizeQueue.maxConcurrentOperationCount = 1;
    self.color = [UIColor whiteColor];
}

- (void)initialize
{
    [super initialize];
    
    self.textView = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    self.textView.userInteractionEnabled = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [LuuButUtils makeViewAntialiasing:self.textView];
    [self.contentView addSubview:self.textView];
    
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.lineBreakMode = NSLineBreakByWordWrapping;
    self.textView.numberOfLines = 0;
}

#pragma mark - Undo/Redo

- (LuuButState *)getCurrentState
{
    LuuButState *currentState = [super getCurrentState];
    if (currentState) {
        [currentState setText:self.text font:self.fontName color:self.color bold:self.bold italic:self.italic underline:self.underline];
    }
    return currentState;
}

- (void)restoreState:(LuuButState *)state
{
    [super restoreState:state];
    
    [self setText:state.text];
    [self setFontName:state.textFont];
    [self setColor:state.textColor];
    
    [self setBold:state.bold];
    [self setItalic:state.italic];
    [self setUnderline:state.underline];
}

#pragma mark - Method

- (void)setBold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline
{
    _bold = bold;
    _italic = italic;
    _underline = underline;
    
    [self adjustTextView];
}

- (void)setText:(NSString *)sText
{
    _text = sText;
    [self adjustTextView];
}

- (void)setFontName:(NSString *)sFontName
{
    _fontName = sFontName;
    [self adjustTextView];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self adjustTextView];
}

- (void)setBold:(BOOL)bold
{
    _bold = bold;
    [self adjustTextView];
}

- (void)setItalic:(BOOL)italic
{
    _italic = italic;
    [self adjustTextView];
}

- (void)setUnderline:(BOOL)underline
{
    _underline = underline;
    [self adjustTextView];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self adjustTextView];
}

- (void)adjustTextView
{
    if (!self.superview) return;
    if (!_fontName || _fontName.length <= 0) return;
    if (!_text || _text.length <= 0) return;
    
    [self.getFontSizeQueue cancelAllOperations];
    
    CGSize boundsSize = self.textView.bounds.size;
    NSString *text = self.text;
    NSString *fontName = self.fontName;
    UIColor *color = self.color;
    
    BOOL bold = self.bold;
    BOOL italic = self.italic;
    BOOL underline = self.underline;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    operation.queuePriority = NSOperationQueuePriorityVeryLow;
    
    __weak typeof(self) weakSelf = self;
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        NSString *newFontName = fontName;
        
        UIFontDescriptorSymbolicTraits symbolicTraits = -1;
        if (bold && italic) {
            symbolicTraits = UIFontDescriptorTraitBold|UIFontDescriptorTraitItalic;
        }
        else if (bold && !italic) {
            symbolicTraits = UIFontDescriptorTraitBold;
        }
        else if (!bold && italic) {
            symbolicTraits = UIFontDescriptorTraitItalic;
        }
        
        if (symbolicTraits != -1) {
            UIFontDescriptor *fontDescriptor = [[UIFont fontWithName:fontName size:10].fontDescriptor fontDescriptorWithSymbolicTraits:symbolicTraits];
            if (fontDescriptor) {
                newFontName = fontDescriptor.postscriptName;
            }
        }
        
        int fontSize = [LuuButUtils findFontSizeToFitSize:boundsSize widthText:text fontName:newFontName minFontSize:1];
        UIFont *font = [UIFont fontWithName:newFontName size:fontSize];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:
                                                       @{NSFontAttributeName:font,
                                                         NSForegroundColorAttributeName:color,
                                                         NSStrokeWidthAttributeName:@(-0.5),
                                                         NSStrokeColorAttributeName:[UIColor darkGrayColor]}];
        
        if (underline) {
            [attributedString addAttribute:NSUnderlineStyleAttributeName
                                     value:@(NSUnderlineStyleSingle)
                                     range:NSMakeRange(0, attributedString.length)];
        }
        
        if (!weakOperation || [weakOperation isCancelled]) return;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.textView setAttributedText:attributedString];
            }
        }];
    }];
    
    [self.getFontSizeQueue addOperation:operation];
}

#pragma mark - UIGestureRecognizerHandle

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        CGPoint translatedCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
        
        if (translatedCenter.y - delta <= 0) {
            translatedCenter.y = delta;
        }
        
        if (translatedCenter.y + delta >= self.superview.bounds.size.height) {
            translatedCenter.y = self.superview.bounds.size.height - delta;
        }
        
        if (translatedCenter.x - delta <= 0) {
            translatedCenter.x = delta;
        }
        
        if (translatedCenter.x + delta >= self.superview.bounds.size.width) {
            translatedCenter.x = self.superview.bounds.size.width - delta;
        }
        
        [self setCenter:translatedCenter];
        [gestureRecognizer setTranslation:CGPointZero inView:self];
    }
}

- (void)handleChangeWidth:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [gestureRecognizer locationInView:self];
        float newWidth = self.bounds.size.width + (point.x - prevWidth);
        if (newWidth < minSize) newWidth = minSize;
        
        CGSize newSize = CGSizeMake(newWidth, self.bounds.size.height);
        [self setBounds:(CGRect){CGPointZero,newSize}];
    }
    
    prevWidth = [gestureRecognizer locationInView:self].x;
}

- (void)handleChangeHeight:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint point = [gestureRecognizer locationInView:self];
        float newHeight = self.bounds.size.height + (point.y - prevHeight);
        if (newHeight < minSize) newHeight = minSize;
        
        CGSize newSize = CGSizeMake(self.bounds.size.width, newHeight);
        [self setBounds:(CGRect){CGPointZero,newSize}];
    }
    
    prevHeight = [gestureRecognizer locationInView:self].y;
}
@end

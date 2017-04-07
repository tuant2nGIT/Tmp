//
//  LuuButView.h
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LuuButView;
@class LuuButState;

@protocol LuuButViewDelegate <NSObject>

- (void)didBeginEditLuuButView:(LuuButView *)luubutView;
- (void)didEndEditLuuButView:(LuuButView *)luubutView;

- (void)didSelectRemoveLuuButView:(LuuButView *)luubutView;

@end

@interface LuuButView : UIView
{
    float minSize;
    float delta;
    
    float prevWidth, prevHeight;
    
    float minWidth, minHeight;
    float maxWidth, maxHeight;
    
    float sizeRatio;
    CGFloat deltaAngle;
}

@property (nonatomic, weak) id<LuuButViewDelegate> delegate;

@property (strong, nonatomic) UIView *contentView;

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, assign) CGSize superviewBoundsSize;
@property (nonatomic, assign) CGSize centerPointRatio, boundsRatio;
@property (nonatomic, assign) float angle;

- (void)initialize;
- (void)remove;
- (void)setRotate:(float)rotate;

#pragma mark - Undo/Redo

- (void)initialState;

- (LuuButState *)getCurrentState;
- (void)restoreState:(LuuButState *)state;

- (void)doSaveState;
- (void)doRemoveAllSaveState;

- (void)doUndo;
- (void)doRedo;

- (BOOL)canUndo;
- (BOOL)canRedo;

#pragma mark - UIGestureRecognizerHandle

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handleChangeWidth:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handleChangeHeight:(UIPanGestureRecognizer *)gestureRecognizer;

@end

@interface LuuButState : NSObject

@property (nonatomic, assign) CGSize centerPointRatio;
@property (nonatomic, assign) CGSize boundsRatio;
@property (nonatomic, assign) float angle;
@property (nonatomic, assign) BOOL hidden;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL underline, bold, italic;

- (id)initWithCenterPointRatio:(CGSize)centerPointRatio boundsRatio:(CGSize)boundsRatio angle:(float)angle andHidden:(BOOL)hidden;
- (void)setText:(NSString *)text font:(NSString *)textFont color:(UIColor *)textColor bold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline;

@end

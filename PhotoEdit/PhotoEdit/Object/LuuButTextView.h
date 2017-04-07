//
//  LuuButTextView.h
//  PhotoEdit
//
//  Created by TuanTN8 on 3/27/17.
//  Copyright © 2017 Storm. All rights reserved.
//

#import "LuuButView.h"

@interface LuuButTextView : LuuButView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL underline, bold, italic;

- (void)setBold:(BOOL)bold italic:(BOOL)italic underline:(BOOL)underline;
- (void)adjustTextView;

@end

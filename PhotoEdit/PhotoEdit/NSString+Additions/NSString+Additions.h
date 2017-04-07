//
//  NSString+Additions.h
//  MediaManager
//
//  Created by TuanTN on 6/5/16.
//  Copyright © 2016 polymath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingAndLeadingWhitespaceAndNewlineCharacters;

@end

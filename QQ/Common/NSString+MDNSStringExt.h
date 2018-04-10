//
//  NSString+MDNSStringExt.h
//  QQ
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MDNSStringExt)

- (CGSize)sizeOfTextWithMaxSize: (CGSize)maxSize font:(UIFont *)font;

+ (CGSize)sizeWithText: (NSString *)text maxSize: (CGSize)maxSize font: (UIFont *)font;

@end

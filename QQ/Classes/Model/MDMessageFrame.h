//
//  MDMessageFrame.h
//  QQ
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//
#define textFont [UIFont systemFontOfSize:14]
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

//引入class方式1
//#import "MDMessage.h"

//引入class方式2
@class MDMessage;
@interface MDMessageFrame : NSObject

@property (nonatomic, strong) MDMessage *message;

@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect imageFrame;

@property (nonatomic, assign, readonly) CGFloat rowHeight;

@end

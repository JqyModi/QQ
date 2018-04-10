//
//  MDMessageFrame.m
//  QQ
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MDMessageFrame.h"
#import <UIKit/UIKit.h>

#import "MDMessage.h"
#import "NSString+MDNSStringExt.h"

@implementation MDMessageFrame

-(void)setMessage:(MDMessage *)message {
    //赋值
    _message = message;
    CGFloat margin = 5;
    //通过数据模型计算行高
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    //计算时间label的frame
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = screenW;
    CGFloat timeH = 15;
    if (!message.hideTime) {
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    
    //计算头像的frame
    CGFloat iconW = 30;
    CGFloat iconH = iconW;
    CGFloat iconY = CGRectGetMaxY(_timeFrame) + margin;
    CGFloat iconX = message.type == MDMessageTypeSender ? margin : screenW - margin - iconW;
    _imageFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //计算消息正文frame
    
    //1.计算正文大小
    CGSize textSize = [message.text sizeOfTextWithMaxSize:CGSizeMake(200, MAXFLOAT) font:textFont];
    //2.计算x,y
    CGFloat textW = textSize.width + 40; //放大按钮W
    CGFloat textH = textSize.height + 30; //放大按钮H
    CGFloat textY = iconY;
    CGFloat textX = message.type == MDMessageTypeRecevier ? screenW - iconW - margin - textW : CGRectGetMaxY(_imageFrame);
    _textFrame = CGRectMake(textX, textY, textW, textH);
    
    //计算行高：消息文本较多时行高等于消息文本的bottom否则等头像的bottom
    CGFloat maxY = MAX(CGRectGetMaxY(_textFrame), CGRectGetMaxY(_imageFrame));
    _rowHeight = maxY;
    
    
}

@end

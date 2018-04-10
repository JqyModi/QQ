//
//  MDMessage.h
//  QQ
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个枚举: 枚举就是一个数字：通过英文表示见名知意
typedef enum {
    MDMessageTypeSender = 0,
	MDMessageTypeRecevier = 1
} MDMessageType;

@interface MDMessage : NSObject

//定义属性
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) MDMessageType type;

//定义一个属性来记录是否需要隐藏当前时间
@property (nonatomic, assign) BOOL hideTime;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)messageWithDict: (NSDictionary *)dict;

@end

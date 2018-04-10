//
//  MDMessage.m
//  QQ
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MDMessage.h"

@implementation MDMessage

-(instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+(instancetype)messageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end

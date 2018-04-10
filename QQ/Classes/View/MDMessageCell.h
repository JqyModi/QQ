//
//  MDMessageCell.h
//  QQ
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDMessageFrame.h"


@interface MDMessageCell : UITableViewCell
@property (nonatomic, strong) MDMessageFrame *modelFrame;

+ (instancetype)messageCellWithTableView: (UITableView *)tableView;
@end

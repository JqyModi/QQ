//
//  MDMessageCell.m
//  QQ
//
//  Created by Mac on 2018/4/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "MDMessageCell.h"
#import "MDMessage.h"

//在.m文件中定义属性
@interface MDMessageCell()

@property (nonatomic, weak) UILabel *lblTime;
@property (nonatomic, weak) UIImageView *imgViewIcon;
@property (nonatomic, weak) UIButton *btnText;

@end

@implementation MDMessageCell

//重写初始化方法来自定义View
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    //调用父类初始化方法
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        UILabel *lblTime = [[UILabel alloc] init];
        [self.contentView addSubview:lblTime];
        lblTime.font = [UIFont systemFontOfSize:12];
        lblTime.textAlignment = NSTextAlignmentCenter;
        self.lblTime = lblTime;
        
        UIImageView *imgViewIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:imgViewIcon];
        self.imgViewIcon = imgViewIcon;
        
        UIButton *btnText = [[UIButton alloc] init];
        btnText.titleLabel.font = [UIFont systemFontOfSize:14];
        //自动换行
        btnText.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:btnText];
        self.btnText = btnText;
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

+ (instancetype)messageCellWithTableView: (UITableView *)tableView {
    static NSString *ID = @"message_cell";
    MDMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MDMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

//重写模型的set方法设置子控件数据及frame
- (void)setModelFrame:(MDMessageFrame *)modelFrame {
    
    _modelFrame = modelFrame;
    
    //获取数据源
    MDMessage *message = modelFrame.message;
    //设置子控件frame
    self.lblTime.frame = modelFrame.timeFrame;
    self.imgViewIcon.frame = modelFrame.imageFrame;
    self.btnText.frame = modelFrame.textFrame;
    //设置数据
    self.lblTime.text = message.time;
    //通过是否显示当前时间来设置label是否显示
    self.lblTime.hidden = message.hideTime;
    //根据消息类型判断显示那种头像图片
    NSString *iconImg = message.type == MDMessageTypeSender ? @"me" : @"other";
    self.imgViewIcon.image = [UIImage imageNamed:iconImg];
    [self.btnText setTitle:message.text forState:UIControlStateNormal];
    
    //设置正文背景图
    NSString *norImg = @"";
    NSString *hightLightImg = @"";
    if (message.type == MDMessageTypeRecevier) {
        norImg = @"chat_send_nor";
        hightLightImg = @"chat_send_press_pic";
    }else{
        norImg = @"chat_recive_nor";
        hightLightImg = @"chat_recive_press_pic";
    }
    
    UIImage *nor = [UIImage imageNamed:norImg];
    UIImage *hightLight = [UIImage imageNamed:hightLightImg];
    
    /*
     解决文字超出背景图问题：
     1.以平铺方式拉升背景图
     2.放大按钮：这时背景图跟着放大：设置按钮内容内边距使内容不跟着放大
     */
    
    //以平铺方式拉升图片
    nor = [nor stretchableImageWithLeftCapWidth:nor.size.width * 0.5 topCapHeight:nor.size.height * 0.5];
    hightLight = [hightLight stretchableImageWithLeftCapWidth:hightLight.size.width * 0.5 topCapHeight:hightLight.size.height * 0.5];
    
    [self.btnText setBackgroundImage:nor forState:UIControlStateNormal];
    [self.btnText setBackgroundImage:hightLight forState:UIControlStateHighlighted];
    
    //调试设置按钮背景色
//    self.btnText.backgroundColor = [UIColor greenColor];
//    self.btnText.titleLabel.backgroundColor = [UIColor purpleColor];
    
    //2.设置内容内边距:需要在frame中放大对应的W=40，H=30
    self.btnText.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 15, 20);
    
    //设置正文文字颜色
    UIColor *textColor = [UIColor whiteColor];
    if (message.type == MDMessageTypeSender) {
        textColor = [UIColor blackColor];
    }
    [self.btnText setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ViewController.m
//  QQ
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ViewController.h"

//导入class
#import "MDMessage.h"
#import "MDMessageFrame.h"
#import "MDMessageCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
//定义数据模型
@property (nonatomic, strong) NSMutableArray *messageFrames;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputView;
@end

@implementation ViewController

//懒加载数据源
- (NSMutableArray *)messageFrames {
    if (_messageFrames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil];
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            //讲义一个数据模型
            MDMessage *model = [MDMessage messageWithDict:dict];
            
            //获取上一个数据模型：没加新数据前的最后一个模型
            MDMessage *laseMessage = (MDMessage *)[[arrayModels lastObject] message];
            if ([model.time isEqualToString:laseMessage.time]) {
                model.hideTime = YES;
            }
            
            //创建一个frame模型
            MDMessageFrame *modelFrame = [[MDMessageFrame alloc] init];
            modelFrame.message = model;
            
            //把frame模型加到arrayModels
            [arrayModels addObject:modelFrame];
        }
        _messageFrames = arrayModels;
    }
    return _messageFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"bounds ---> %@", [[UIScreen mainScreen] bounds]);
    
    //去掉多余的cell
    self.tableView.tableFooterView = [[UIView alloc] init];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置背景色:回被Cell的背景色挡住：将cell背景色设置为clear
    self.tableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
    //设置Cell不可选中
    self.tableView.allowsSelection = NO;
    
    //设置输入框左边光标位置间隔
    [self leftLineOfInputView];
    
    //通过通知监听系统事件:如键盘弹出事件，电池事件，电话等
    [self addObserverOfInputView];
    
    //监听tableview的滚动事件:滚动隐藏键盘
    //delegate已经在sb里面设置
    
}

- (void)scrollTableView{
    
}

/*
 事件监听分三类：
 1.普通控件的事件通过:addTarget监听
 2.滚动、缩放等通过代理监听
 3.系统事件：通过通知监听
 */
- (void)addObserverOfInputView{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(scrollToolView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//响应键盘弹出事件
- (void)scrollToolView:(NSNotification *)notify {
    NSLog(@"notify ---->> %@", notify);
    //通过获取键盘参数：弹出时间、键盘frame来设置View上移动画
    //获取键盘高度
    CGRect kbEndRect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbY = kbEndRect.origin.y;
    CGFloat transformValue = kbY - self.view.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformValue);
    }];
    
    //让tableview滚动到最上面
    [self scrollTableViewToTop];
}

- (void)scrollTableViewToTop{
    //获取最后一行的indexpath
    NSIndexPath *lastRowIdxPath = [NSIndexPath indexPathForRow:self.messageFrames.count-1 inSection:0];
    //滚动指定indexpath到最上方：如果前面有Cell则滚动到可滚动最大限度
    [self.tableView scrollToRowAtIndexPath:lastRowIdxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)leftLineOfInputView {
    //设置输入框左边View
    UIView *left = [[UIView alloc] init];
    left.frame = CGRectMake(0, 0, 10, 1);
    self.inputView.leftView = left;
    //设置左边View显示模式
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - tableviewDataSource / tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //初始化cell
    MDMessageCell *cell = [MDMessageCell messageCellWithTableView:tableView];
    //获取数据源
    MDMessageFrame *modelFrame = self.messageFrames[indexPath.row];
    //设置数据模型
    cell.modelFrame = modelFrame;
    //返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取数据源
    MDMessageFrame *modelFrame = self.messageFrames[indexPath.row];
    return modelFrame.rowHeight;
}

//监听tableview滚动事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma mark - UITaxtFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //实现发送消息
    //1.获取用户输入文字
    NSString *text = textField.text;
    
    //发送消息
    [self sendMessage:text type:MDMessageTypeRecevier];
    
    //发送一条自动回复消息:可以从plist中动态读取内容并回复
    [self sendMessage:@"哈哈哈，你懂的 ~" type:MDMessageTypeSender];
    
    //清空消息
    textField.text = @"";
    return YES;
}

#pragma 封装发送消息方法
- (void)sendMessage: (NSString *)msg type: (MDMessageType)type {
    //2.加入到数据源
    
    //2.1 创建一个数据模型
    MDMessage *message = [[MDMessage alloc] init];
    //获取当前系统时间
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"今天 HH:mm";
    message.time = [formatter stringFromDate:date];
    message.text = msg;
    message.type = type;
    //2.2创建frame模型
    MDMessageFrame *frame = [[MDMessageFrame alloc] init];
    frame.message = message;
    
    //获取上一个数据模型：没加新数据前的最后一个模型
    MDMessage *laseMessage = (MDMessage *)[[self.messageFrames lastObject] message];
    if ([message.time isEqualToString:laseMessage.time]) {
        message.hideTime = YES;
    }
    //加入数据模型中
    [self.messageFrames addObject:frame];
    //3.刷新tableview
    [self.tableView reloadData];
    //滚动到最上方
    [self scrollTableViewToTop];
    
}

@end


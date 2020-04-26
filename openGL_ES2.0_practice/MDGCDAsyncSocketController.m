
//
//  MDGCDAsyncSocketController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/4/17.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import "MDGCDAsyncSocketController.h"
#import <GCDAsyncSocket.h>

static const long kServiceTag = 10086;

@interface MDGCDAsyncSocketController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic, strong) UIButton *sendMsgBtn;
@property (nonatomic, strong) UITextField *inputTextField;

@end

@implementation MDGCDAsyncSocketController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureUI];
}

- (void)configureUI {
    CGFloat margin = 30;
    UIButton *connectBtn = [self buttonWithTitle:@"连接socket"
                                         bgColor:[UIColor redColor]
                                             SEL:@selector(didClickConnectBtn)
                                             top:100];
    
    UIButton *reConnectBtn = [self buttonWithTitle:@"重连socket"
                                         bgColor:[UIColor redColor]
                                             SEL:@selector(didClickReConnectBtn)
                                             top:CGRectGetMaxY(connectBtn.frame) + margin];
    
    UIButton *disConnectBtn = [self buttonWithTitle:@"断开socket"
                                            bgColor:[UIColor redColor]
                                                SEL:@selector(didClickDisConnectBtn)
                                                top:CGRectGetMaxY(reConnectBtn.frame) + margin];
    
    [self.view addSubview:connectBtn];
    [self.view addSubview:reConnectBtn];
    [self.view addSubview:disConnectBtn];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(connectBtn.frame), CGRectGetMaxY(disConnectBtn.frame) + 20, 250, 40)];
    _inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
    _inputTextField.layer.borderWidth = 1.0f;
    _inputTextField.placeholder = @"发送消息";
    [self.view addSubview:_inputTextField];
    
    _sendMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_inputTextField.frame), CGRectGetMinY(_inputTextField.frame), 50, 40)];
    [_sendMsgBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendMsgBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_sendMsgBtn addTarget:self action:@selector(didClickSendMsgBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendMsgBtn];
}

- (UIButton *)buttonWithTitle:(NSString *)title
                      bgColor:(UIColor *)bgColor
                       SEL:(SEL)sel
                          top:(CGFloat)top {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, top, 150, 50)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:bgColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    
    return btn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputTextField resignFirstResponder];
}

#pragma mark - handle event

- (void)connectSocket {
    if (self.socket == nil) {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    }
    
    if (!self.socket.isConnected) {
        NSError *error = nil;
        [self.socket connectToHost:@"172.16.224.114" onPort:9877 error:&error];
        if (error) {
            NSLog(@"connect fail: %@", error.localizedDescription);
        }
    }
}

- (void)disConnectSocket {
    if (!self.socket.isConnected) {
        return;
    }
    [self.socket disconnect];
    self.socket.delegate = nil;
    self.socket = nil;
}

- (void)didClickConnectBtn {
    [self connectSocket];
}

- (void)didClickReConnectBtn {
    [self disConnectSocket];
    [self connectSocket];
}

- (void)didClickDisConnectBtn {
    [self disConnectSocket];
}

- (void)didClickSendMsgBtn {
    NSString *text = self.inputTextField.text;
    if (text.length == 0) return;
    
    NSData *msgData = [text dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:msgData withTimeout:-1 tag:kServiceTag];
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功 : %@---%d",host,port);
    //连接成功或者收到消息，必须开始read，否则将无法收到消息,
    //不read的话，缓存区将会被关闭
    // -1 表示无限时长 ,永久不失效
    [self.socket readDataWithTimeout:-1 tag:kServiceTag];
}

// 连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"断开 socket连接 原因:%@",err);
}

//已经接收服务器返回来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"接收到tag = %ld : %lu 长度的数据",tag, (unsigned long)data.length);
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg.length > 0) {
        NSLog(@"recv msg: %@", msg);
    }
    
    //连接成功或者收到消息，必须开始read，否则将无法收到消息
    //不read的话，缓存区将会被关闭
    // -1 表示无限时长 ， tag
    [self.socket readDataWithTimeout:-1 tag:10086];
}

//消息发送成功 代理函数 向服务器 发送消息
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"%ld 发送数据成功", tag);
}

@end

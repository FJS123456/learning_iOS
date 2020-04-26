//
//  MDSocketClient_001.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/4/16.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import "MDSocketClient_001.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <GCDAsyncSocket.h>

//htons : 将一个无符号短整型的主机数值转换为网络字节顺序
#define SocketPort htons(9877)
//inet_addr是一个计算机函数，功能是将一个点分十进制的IP转换成一个长整数型数
#define SocketIP inet_addr("127.0.0.1")

@interface MDSocketClient_001 ()

//套接字描述符
@property (nonatomic, assign) int clientID;

@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *sendMsgBtn;
@property (nonatomic, strong) UILabel *presentLabel;

@end

@implementation MDSocketClient_001

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureUI];
}

- (void)configureUI {
    _connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 40)];
    [_connectBtn setBackgroundColor:[UIColor redColor]];
    [_connectBtn setTitle:@"连接socket" forState:UIControlStateNormal];
    [_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_connectBtn addTarget:self action:@selector(didClickConnectBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectBtn];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_connectBtn.frame), CGRectGetMaxY(_connectBtn.frame) + 30, 150, 40)];
    _inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
    _inputTextField.layer.borderWidth = 1.0f;
    _inputTextField.placeholder = @"发送消息";
    [self.view addSubview:_inputTextField];
    
    _sendMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_inputTextField.frame), CGRectGetMinY(_inputTextField.frame), 50, 40)];
    [_sendMsgBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendMsgBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_sendMsgBtn addTarget:self action:@selector(didClickSendMsgBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendMsgBtn];
    
    _presentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_sendMsgBtn.frame) + 50, 300, 300)];
    _presentLabel.numberOfLines = 0;
    _presentLabel.backgroundColor = [UIColor grayColor];
    _presentLabel.font = [UIFont systemFontOfSize:18];
    _presentLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_presentLabel];
}

- (void)didClickConnectBtn {
    //1.创建socket
    /*
     domain: 协议域，又称协议族（family）。常用的协议族有*AF_INET(ipv4)、AF_INET6(ipv6)、*AF_LOCAL（或称AF_UNIX，Unix域Socket）、AF_ROUTE等。协议族决定了socket的地址类型，在通信中必须采用对应的地址，
         如AF_INET决定了要用ipv4地址（32位的）与端口号（16位的）的组合、AF_UNIX决定了要用一个绝对路径名作为地址。
     type:
        指定Socket类型。常用的socket类型有SOCK_STREAM、SOCK_DGRAM、SOCK_RAW、SOCK_PACKET、SOCK_SEQPACKET等。流式Socket（SOCK_STREAM）
        是一种面向连接的Socket，针对于面向连接的TCP服务应用。数据报式Socket（SOCK_DGRAM）是一种无连接的Socket，对应于无连接的UDP服务应用。
     protocol:
        指定协议。常用协议有IPPROTO_TCP、IPPROTO_UDP等等，给0，系统会指定和type对应的默认协议

     */
    self.clientID = socket(AF_INET, SOCK_STREAM, 0);
    if (_clientID == -1) {
        NSLog(@"fail create socket");
        return;
    }
    
    //2.连接socket
    struct sockaddr_in socketAddr;
    socketAddr.sin_family = AF_INET;
    socketAddr.sin_port = SocketPort;
    
    //ip 信息描述
    struct in_addr socketIn_addr;
    socketIn_addr.s_addr = SocketIP;
    
    socketAddr.sin_addr = socketIn_addr;
    
    int result = connect(_clientID, (const struct sockaddr *)&socketAddr, sizeof(socketAddr));
    if (result != 0) {
        NSLog(@"connect socket fail");
        return;
    }
    
    NSLog(@"connect success");
    
    // 调用开始接受信息的方法
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self recvMsg];
    });
    
}

- (void)didClickSendMsgBtn {
    NSString *text = self.inputTextField.text;
    if (text.length == 0) {
        return;
    }
    
    const char *msg = text.UTF8String;
    ssize_t sendLen = send(_clientID, msg, strlen(msg), 0);
    NSLog(@"send %ld byte", sendLen);
}

#pragma mark - 消息接收处理
- (void)recvMsg {
    while (true) {
        uint8_t buffer[1024];
        ssize_t recvLen = recv(_clientID, buffer, sizeof(buffer), 0);
        NSLog(@"receive %ld byte", recvLen);
        if (recvLen == 0) {
            continue;
        }
        
        //buffer->data->string
        NSData *data = [NSData dataWithBytes:buffer length:recvLen];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *originStr = self.inputTextField.text;
        self.inputTextField.text = [NSString stringWithFormat:@"%@\n%@",originStr, str];
    }
}


@end

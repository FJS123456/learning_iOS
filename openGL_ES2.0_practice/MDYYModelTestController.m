//
//  MDYYModelTestController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/3/18.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import "MDYYModelTestController.h"
#import "YYKit.h"

@protocol MDTestProtocol <NSObject>

@optional
- (void)test_protocolOne;

@end

@interface YYAuthor : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSDate *birthday;
@end

@implementation YYAuthor
@end


@interface YYTextInfo : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger line;
@end

@implementation YYTextInfo
@end


@interface YYBook : NSObject
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *bookID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger pages;
@property (nonatomic, strong) YYAuthor *author;
@property (nonatomic, strong) NSArray<YYTextInfo *> *textInfos;
@property (nonatomic, weak) id<MDTestProtocol> delegate;
@end

@implementation YYBook

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc"  : @"ext.desc",
             @"bookID": @[@"id", @"ID", @"book_id"]};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"textInfos" : [YYTextInfo class],};
}

@end

@interface MDYYModelTestController ()

@end

@implementation MDYYModelTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self testModelFromJson];
}

- (void)testModelFromJson {
    YYBook *book = [YYBook modelWithJSON:@"{\"book_id\": \"aaaaa\",\"name\": \"Harry Potter\", \"pages\": 256, \"author\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" }, \"ext\": {\"desc\": \"ext-descInfo\"}, \"textInfos\": [{\"text\":\"textInfos_text\"}] }"];
    NSLog(@"%@",book);
}

@end

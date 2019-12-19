//
//  UpLoadImageTool.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "UpLoadImageTool.h"
//并行分块上传，适合追求速度
#import "UpYunConcurrentBlockUpLoader.h"
#import "UpYunFileDealManger.h" // 文件处理任务
#import "UpYunFormUploader.h" //图片，小文件，短视频
@interface UpLoadImageTool ()
@property (nonatomic, strong) NSMutableArray * dataSource;
@end
@implementation UpLoadImageTool
+ (UpLoadImageTool *)shareInstance {
    static UpLoadImageTool * tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[UpLoadImageTool alloc]init];
    });
    return tool;
}

-(NSString*)randomStr
{
    static const char _randomStr[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";   //!@#$%^*()
    char datas[32];
    for (int x=0;x<32;datas[x++] =_randomStr[arc4random()%62]); //71
    return [[NSString alloc] initWithBytes:datas length:32 encoding:NSUTF8StringEncoding];
}

- (RACSignal *)uploadImage:(UIImage *)image {
    RACSubject * subject = [RACSubject subject];
    NSData *fileData = UIImageJPEGRepresentation(image,0.5);
    
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    
    NSString *bucketName = CurrentUpYunImageSpace;
    [up uploadWithBucketName:bucketName
                    operator:CurrentUpYunImageOperater
                    password:CurrentUpYunImagePassword
                    fileData:fileData
                    fileName:nil
                     saveKey:[NSString stringWithFormat:@"%@ios_sdk_new/Image.png",[self randomStr]]
             otherParameters:nil
                     success:^(NSHTTPURLResponse *response,
                               NSDictionary *responseBody) {
                         NSLog(@"上传成功 responseBody：%@", responseBody);
                         NSLog(@"可将您的域名与返回的 url 路径拼接成完整文件 URL，再进行访问测试。注意生产环境请用正式域名，新开空间可用 test.upcdn.net 进行测试。https 访问需要空间开启 https 支持");
                         NSString * url = [NSString stringWithFormat:@"/%@",[responseBody objectForKey:@"url"]];
                         [subject sendNext:url];
                         [subject sendCompleted];

                     }
                     failure:^(NSError *error,
                               NSHTTPURLResponse *response,
                               NSDictionary *responseBody) {
                         NSLog(@"上传失败 error：%@", error);
                         NSLog(@"上传失败 code=%ld, responseHeader：%@", (long)response.statusCode, response.allHeaderFields);
                         NSLog(@"上传失败 message：%@", responseBody);
                         [subject sendNext:@"失败"];
                         [subject sendCompleted];
                     }
     
                    progress:^(int64_t completedBytesCount,
                               int64_t totalBytesCount) {
//                        [SVProgressHUD showInfoWithStatus:@"正在上传图片，请等待"];
                        NSString *progress = [NSString stringWithFormat:@"%lld / %lld", completedBytesCount, totalBytesCount];
//                        NSString *progress_rate = [NSString stringWithFormat:@"upload %.1f %%", 100 * (float)completedBytesCount / totalBytesCount];
                        NSLog(@"upload progress: %@", progress);
                    }];
    
    return  subject;
}
@end

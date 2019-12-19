//
//  DownLoaderHelp.m
//  HeMeiHui
//
//  Created by 任为 on 2016/12/27.
//  Copyright © 2016年 hefa. All rights reserved.
//

#import "DownLoaderHelp.h"

@implementation DownLoaderHelp

+ (void)saveADImageWithUrlStr:(NSArray*)urlArr{
    
    __weak typeof(self) weakSelf = self;
    NSUserDefaults *defaults     = [NSUserDefaults standardUserDefaults];
    NSMutableArray *adImageArr   = [NSMutableArray array];
    NSMutableArray *adlinkArrary = [NSMutableArray array];
    //已经保存的广告图的数组
    NSArray       *defaultArrary =[defaults objectForKey:@"adImageArraryName"];
//    CurrentEnvironment
    if (!urlArr.count) {
//        删除原本广告图
        [self deleteUserDefaulitImageArrary:defaultArrary];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"adImageArraryName"];
    }
    for (int i=0; i<urlArr.count; i++) {
        
        NSDictionary *imageDic     = urlArr[i];
        NSString     *imageStr     = imageDic[@"picUrl"];
        //图片的名字
        NSArray      *imageNameArr = [imageStr componentsSeparatedByString:@"/"];
        //图片对应的链接
        NSString *linkUrl = imageDic[@"picLink"];
   
        if ([defaultArrary containsObject:[imageNameArr lastObject]]) {
            
            [adImageArr addObject:[imageNameArr lastObject]];
            
            if (linkUrl) {
                
                [adlinkArrary addObject:linkUrl];
                
            }else {
                
                [adlinkArrary addObject:@"hello"];
            }
            
            if (adImageArr.count==urlArr.count) {
                
               
                //保存新的图片链接
                if (adlinkArrary.count) {
                    [[NSUserDefaults standardUserDefaults] setObject:adlinkArrary forKey:@"adImageArraryLink"];
                }
                
                NSMutableArray *temp =[NSMutableArray arrayWithArray:defaultArrary];
                [temp removeObjectsInArray:adImageArr];
                //删除保存的过期的图片
                [weakSelf deleteUserDefaulitImageArrary:temp];
            }
            
            continue;
        }
        
        SDWebImageDownloader *downLoader = [SDWebImageDownloader sharedDownloader];
        [downLoader downloadImageWithURL:[NSURL URLWithString:imageStr]
                                 options:SDWebImageDownloaderHighPriority
                                progress:^(NSInteger receivedSize,
                                           NSInteger expectedSize,NSURL * _Nullable targetURL) {
                                    
                                } completed:^(
                                              UIImage *image,
                                              NSData *data,
                                              NSError *error,
                                              BOOL finished) {
                                    
                                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                                    NSString *imageFilePath = [path stringByAppendingPathComponent:[imageNameArr lastObject]];
                                    BOOL success = [UIImageJPEGRepresentation(image, 1) writeToFile:imageFilePath  atomically:YES];
                                    if (success){
                                        
                                        // NSLog(@"保存照片成功");
                                        
                                        [adImageArr addObject:[imageNameArr lastObject]];
                                        if (linkUrl) {
                                            
                                            [adlinkArrary addObject:linkUrl];
                                            
                                        }else {
                                            
                                            [adlinkArrary addObject:@"hello"];
                                        }
                                        
                                        if (adImageArr.count==urlArr.count) {
                                            
                                            [[NSUserDefaults standardUserDefaults] setObject:adImageArr forKey:@"adImageArraryName"];
                                            //保存新的图片链接
                                            [[NSUserDefaults standardUserDefaults] setObject:adlinkArrary forKey:@"adImageArraryLink"];
                                            //删除保存的过期的图片
                                            NSMutableArray *temp =[NSMutableArray arrayWithArray:defaultArrary];
                                            [temp removeObjectsInArray:adImageArr];
                                            [weakSelf deleteUserDefaulitImageArrary:temp];
                                        }
                                    }
                                }];
    }
}
//删除过期的广告图
+ (void)deleteUserDefaulitImageArrary:(NSArray*)DefaulitImageArrary{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    for (int i=0; i<DefaulitImageArrary.count; i++) {
        NSString *imageFilePath = [path stringByAppendingPathComponent:DefaulitImageArrary[i]];
        [fileManager removeItemAtPath:imageFilePath error:nil];
        if (i == DefaulitImageArrary.count-1) {
            
            //   NSLog(@"删除了%lu张照片",DefaulitImageArrary.count);
            
        }
    }
    
}

@end

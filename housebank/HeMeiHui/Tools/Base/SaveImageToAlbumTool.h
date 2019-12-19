//
//  SaveImageToAlbumTool.h
//  HeMeiHui
//
//  Created by 任为 on 2017/11/7.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "SVProgressHUD.h"
#import "DownLoadAlertView.h"
@interface SaveImageToAlbumTool : NSObject

/**
 根据URL下载图片，并保存到相应的相册

 @param collectionName 相册名字
 @param imageUrl 图片的URL地址
 */
+ (void)svaeImageToassetCollectionName:(NSString *)collectionName formUrl:(NSString*)imageUrl;

/**
 将图片保存到对应的相册

 @param image 要保存的UIImage对象
 @param collectionName 相册的名字
 */
+ (void)saveImage:(UIImage *)image assetCollectionName:(NSString *)collectionName isMoreImages:(BOOL)isMoreImages;


/**
 批量下载图片 保持顺序; 全部下载完成后才进行回调; 回调结果中,下载正确和失败的状态保持与原先一致的顺序;
 @return resultArray 中包含两类对象:UIImage , NSError
 */
+ (void)downloadImages:(DownLoadAlertView*)downLoadAlertView imageArr:(NSArray<NSString *> *)imgsArray completion:(void(^)(NSArray *resultArray,NSError * _Nullable error))completionBlock;
@end

//
//  SaveImageToAlbumTool.m
//  HeMeiHui
//
//  Created by 任为 on 2017/11/7.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "SaveImageToAlbumTool.h"
#import "ContractDataSave.h"

@implementation SaveImageToAlbumTool
/**
 根据URL下载图片，并保存到相应的相册
 
 @param collectionName 相册名字
 @param imageUrl 图片的URL地址
 */
+(void)svaeImageToassetCollectionName:(NSString *)collectionName formUrl:(NSString *)imageUrl{
    __weak typeof(self) weakSelf = self;
    
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];

    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
       
        [weakSelf saveImage:image assetCollectionName:collectionName isMoreImages:NO];

    }];
}

+ (void)saveImage:(UIImage *)image assetCollectionName:(NSString *)collectionName isMoreImages:(BOOL)isMoreImages{
    
    // 1. 获取当前App的相册授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    // 2. 判断授权状态
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {
        
        // 2.1 如果已经授权, 保存图片(调用步骤2的方法)
        [self saveImage:image toCollectionWithName:collectionName isMoreImages:isMoreImages];
        
    } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) { // 如果没决定, 弹出指示框, 让用户选择
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            // 如果用户选择授权, 则保存图片
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImage:image toCollectionWithName:collectionName isMoreImages:isMoreImages];
            }
        }];
    } else {
        
        [SVProgressHUD showWithStatus:@"请在设置界面, 授权访问相册"];
    }
}

// 保存图片
+ (void)saveImage:(UIImage *)image toCollectionWithName:(NSString *)collectionName isMoreImages:(BOOL)isMoreImages{
    
    // 1. 获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 2. 调用changeBlock
    [library performChanges:^{
        
        // 2.1 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest;
        
        // 2.2 取出指定名称的相册
        PHAssetCollection *assetCollection = [self getCurrentPhotoCollectionWithTitle:collectionName];
        
        // 2.3 判断相册是否存在
        if (assetCollection) { // 如果存在就使用当前的相册创建相册请求
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else { // 如果不存在, 就创建一个新的相册请求
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
        }
        
        // 2.4 根据传入的相片, 创建相片变动请求
        PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        // 2.4 创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        
        // 2.5 将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        // 3. 判断是否出错, 如果报错, 声明保存不成功
//        NSLog(@"%@   %d",error,success);
        if (!isMoreImages) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
                [SVProgressHUD dismissWithDelay:1];
                
            } else {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                [SVProgressHUD dismissWithDelay:1];
            }
        }
    }];
}

/**
 根据标题获取相对应的相册
 @param collectionName 相册的名字
 @return 对应的相册
 */
+ (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
    
    // 1. 创建搜索集合
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 2. 遍历搜索集合并取出对应的相册
    for (PHAssetCollection *assetCollection in result) {
        
        if ([assetCollection.localizedTitle containsString:collectionName]) {
            return assetCollection;
        }
    }
    
    return nil;
}


/**
 批量下载图片 保持顺序; 全部下载完成后才进行回调; 回调结果中,下载正确和失败的状态保持与原先一致的顺序;
 @return resultArray 中包含两类对象:UIImage , NSError
 */
+(void)downloadImages:(DownLoadAlertView *)downLoadAlertView imageArr:(NSArray<NSString *> *)imgsArray completion:(void (^)(NSArray *, NSError * _Nullable))completionBlock{
    
    __block BOOL isDownLoadFail = NO;
    __block BOOL isCancelDownLoad = NO;
    __block int num = 0;
    SDWebImageDownloader *sdManager = [SDWebImageDownloader sharedDownloader];
    sdManager.config.downloadTimeout = 20;
    
    __weak typeof(downLoadAlertView)weakAlertView = downLoadAlertView;
    downLoadAlertView.downLoadCancelBtnClick = ^{
        isCancelDownLoad = YES;
        [sdManager cancelAllDownloads];
        [ContractDataSave cleanAllContract];
        [weakAlertView removeFromSuperview];
        
        [SVProgressHUD showErrorWithStatus:@"取消下载"];
    };
    
    downLoadAlertView.titile.text = [NSString stringWithFormat:@"下载中%d/%d",num,(int)imgsArray.count];

    __block NSMutableDictionary *resultDict = [NSMutableDictionary new];
    for(int i=0;i<imgsArray.count;i++){
        // 如果是取消 则退出循环
        if (isCancelDownLoad) {
            return;
        }
        if (isDownLoadFail) {
            return;
        }
        __block int errorNum = 1;
        NSString *imgUrl = [imgsArray objectAtIndex:i];
        [sdManager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderUseNSURLCache|SDWebImageDownloaderScaleDownLargeImages progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if(finished){
                num++;
                if(error){
                    while(errorNum <=5) {
                        UIImage *downImage = [self downloadImageWithUrl:imgUrl withNum:i];
                        if (downImage) {
                            //在对应的位置放一个error对象
//                            [resultDict setObject:downImage forKey:@(i)];
                            [resultDict setObject:[ContractDataSave contractWriteToFileImagePath:imgUrl] forKey:@(i)];
                            return ;
                        }
                        errorNum ++;
                        if (errorNum == 6) {
                            if(completionBlock){
                                completionBlock([NSArray array],error);
                            }
                            // 取消所有下载
                            [sdManager cancelAllDownloads];
                            isDownLoadFail = YES;
                            return;
                        }
                    }
                }else{
                    if(downLoadAlertView)
                        downLoadAlertView.titile.text = [NSString stringWithFormat:@"下载中%d/%d",num,(int)imgsArray.count];
//                    [resultDict setObject:image forKey:@(i)];
                    
                    [data writeToFile:[ContractDataSave contractWriteToFileImagePath:imgUrl] atomically:true];
                    [resultDict setObject:[ContractDataSave contractWriteToFileImagePath:imgUrl] forKey:@(i)];
                    
                    if(resultDict.count == imgsArray.count) { //全部下载完成
                        NSArray *resultArray = [SaveImageToAlbumTool createDownloadResultArray:resultDict count:imgsArray.count];
                        [resultArray writeToFile:[ContractDataSave contractWriteToFilePlistPath] atomically:YES];
                        NSArray *contract = [ContractDataSave getAllContract];
                        
//                        contract = [ContractDataSave getAllContract];
                        
                        NSMutableArray *imagesArr = [NSMutableArray arrayWithCapacity:1];
                        for (int i = 0; i < contract.count; i++) {
                            if ([contract[i] isKindOfClass:[NSString class]]) {
                                UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:contract[i]];
                                [imagesArr addObject:appleImage];
                            }
                        }
                        
                        if(completionBlock){
                            completionBlock(imagesArr,error);
                        }
                    }
                    return ;
                }
            }
        }];
    }
}

+ (UIImage *)downloadImageWithUrl:(NSString *)imgUrl withNum:(int)num{
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    //    [manager cancelAllDownloads];
    manager.config.downloadTimeout = 20;
   __block UIImage *loadImage;
    [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderUseNSURLCache|SDWebImageDownloaderScaleDownLargeImages progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        
        if (!error) {
            loadImage = image;
            
            [data writeToFile:[ContractDataSave contractWriteToFileImagePath:imgUrl] atomically:true];
        }
    }];
    return loadImage;
}

+ (NSArray *)createDownloadResultArray:(NSDictionary *)dict count:(NSInteger)count {
    NSMutableArray *resultArray = [NSMutableArray new];
    for(int i=0;i<count;i++) {
        NSObject *obj = [dict objectForKey:@(i)];
        [resultArray addObject:obj];
    }
    return resultArray;
}

@end

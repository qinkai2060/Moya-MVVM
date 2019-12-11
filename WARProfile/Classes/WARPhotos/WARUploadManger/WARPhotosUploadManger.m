//
//  WARPhotosUploadManger.m
//  Pods
//
//  Created by 秦恺 on 2018/3/26.
//

#import "WARPhotosUploadManger.h"
#import "WARNetwork.h"
#import "WARBaseMacros.h"
#import "WARMacros.h"
#import "WARProfileNetWorkTool.h"
#import "WARUploadingViewController.h"
#import "UIImage+WARCategory.h"
#import "WARDBUserManager.h"
#import "UIImage+WARCategory.h"
#import "WARDBPhotoTaskModel.h"
#import "WARDBUploadPhotoManger.h"
#import "WARProgressHUD.h"
#import "TZImageManager.h"
#import <Photos/Photos.h>
#import "WARUploadManager.h"
#import "WARUploadRespData.h"
#define kScaleFrom_iPhone5(_X_) (_X_ * (kScreenWidth/320))
@implementation WARPhotosUploadManger

+ (WARPhotosUploadManger*)sharedGolbalViewManager
{
    static WARPhotosUploadManger *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
        
    });
    
    return sharedSVC;

}
- (instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

- (void)start //开始任务
{

    // 如果有
    if ([[WARPhotosUploadManger sharedGolbalViewManager] aryTasker].count > 0) {
       
        // 如果没开始执行
        if (!isload) {

            isload = YES;
     
            // 取出第一个
            WARGroupModel *upmodel  = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
            upmodel.stateStr = @"正在上传";
            
            WS(weakself);
            if (upmodel!=nil) {
            
               [self upload];
            }

        }
    }else {
        NSObject *obj =   self;
        obj   = nil;
    }
}


- (void)applicationWillTerminate:(NSNotification *)notification {
    
}

- (void)upload {
    
    WS(weakself);
        WARGroupModel *model  = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
        if (model.uploadArray.count > 0) {
            WARupPictureModel *pictureModel = [model.uploadArray firstObject];
            // 判断是视频还是
            PHAsset *imageAset     =  [[PHAsset fetchAssetsWithLocalIdentifiers:@[pictureModel.localIdentifier] options:nil] firstObject];
            if (pictureModel.mediaType == 1) { // 图片
                // 原图
                [[TZImageManager manager] getOriginalPhotoDataWithAsset:imageAset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                    // 写入本地
                    NSString *filePth = [WARPhotosUploadManger webBrowserCachePath:[NSString stringWithFormat:@"%@.jpg",pictureModel.taskModelId]];
                    if ([data writeToFile:filePth atomically:YES]) {
                        // 写入成功
                        pictureModel.locationFilePath = filePth;
                        [[WARUploadManager shared] uploadFilePath:filePth  type:WARUploadManagerTypeALBUM mimeType:WARUploadManagerMimeTypePhoto beginTime:[NSDate date] progressSpeedBlock:^(NSString *progress, float progressBaifen, NSString *speedStr, NSString *toalSize) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (pictureModel.block) {
                                    pictureModel.block(progress,progressBaifen,speedStr,toalSize);
                                }
                            });
                            
                        } responseBlock:^(WARUploadRespData *respData, NSString *key) {
                            if (respData) {
                                [weakself uploadPhotoWallanServer:pictureModel withParame:respData];
                            }
                 
                        } errorInfo:^{
                            [WARProgressHUD showAutoMessage:@"请求超时失败"];
                            [WARPhotosUploadManger deleDataModel:pictureModel withParame:model];
                            [self upload];
                        }];
      
                        
                    }
                }];
                
            }else { // 视频
          
                
                [self uploadViedoWithGroupModel:model atPictureModel:pictureModel];

            }
            
        }else{
            
            if (model.uploadArray.count == 0) {
                if (self.finshBlock) {
                    self.finshBlock(model.compleArray);
                }
                [model.compleArray removeAllObjects];
            }
            [[WARPhotosUploadManger sharedGolbalViewManager] end];
        }

}
+ (void)deleDataModel:(WARupPictureModel*)pictureModel withParame:(WARGroupModel*)model {
    if (model.uploadArray.count != 0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:pictureModel.locationFilePath]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:pictureModel.locationFilePath error:nil];
        }
        [model.uploadArray removeObjectAtIndex:0];
        [WARDBUploadPhotoManger deleteUoloadTaskBytaskModelId:pictureModel.taskModelId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upCount" object:nil];
    }
}
- (void)uploadPhotoWallanServer:(WARupPictureModel*)pictureModel withParame:(WARUploadRespData*)respData  {
    WARGroupModel *model  = [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] firstObject];
    NSDictionary *dictParms   = @{
                                  @"height":respData.picHeight,
                                  @"pictureId":respData.url,
                                  @"width":respData.picWidth,
                                  @" original":[@(pictureModel.isSelectOriginalPhoto) stringValue]
                                  };
    [WARProfileNetWorkTool postPhotos:model.albumId params:@{@"photoTime":pictureModel.creatDate,@"address":@"",@"picture":dictParms,@"type":@"PICTURE",@"videoCover":@""} CallBack:^(id response) {
        pictureModel.isUploadFinsh = YES;
        [model.compleArray addObject:pictureModel];
        [WARPhotosUploadManger deleDataModel:pictureModel withParame:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upCount" object:nil];
        [self upload];
    } failer:^(id response) {
        [WARProgressHUD showAutoMessage:@"请求超时失败"];
        [WARPhotosUploadManger deleDataModel:pictureModel withParame:model];
        [self upload];
        
    }];
}
- (void)uploadViedoWithGroupModel:(WARGroupModel*)model atPictureModel:(WARupPictureModel*)pictureModel {
    WS(weakself);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
 
        
        PHAsset *imageAset     =  [[PHAsset fetchAssetsWithLocalIdentifiers:@[pictureModel.localIdentifier] options:nil] firstObject];
  
        [[TZImageManager manager] getVideoOutputPathWithAsset:imageAset success:^(NSString *outputPath) {
            if(outputPath){
                pictureModel.locationFilePath = outputPath;
                [[WARUploadManager shared] uploadFilePath: pictureModel.locationFilePath  type:WARUploadManagerTypeALBUM mimeType:WARUploadManagerMimeTypeVideo beginTime:[NSDate date] progressSpeedBlock:^(NSString *progress, float progressBaifen, NSString *speedStr, NSString *toalSize) {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pictureModel.block) {
                            pictureModel.block(progress,progressBaifen,speedStr,toalSize);
                        }
                    });
                } responseBlock:^(WARUploadRespData *respData, NSString *key) {
                    if (respData) {
                        NSDictionary *parms = @{@"photoTime":pictureModel.creatDate,@"address":@"",@"picture":@{
                                                        @"height":respData.videoHeight,
                                                        @"pictureId":respData.url,
                                                        @"width":respData.videoWidth,
                                                        @" original":[@(pictureModel.isSelectOriginalPhoto) stringValue]
                                                        },@"type":@"VIDEO",@"video":@{@"duration":@(respData.videoDuration),@"videoId":respData.url}};
                        [WARProfileNetWorkTool postPhotos:model.albumId params:parms CallBack:^(id response) {
                            pictureModel.isUploadFinsh = YES;
                            [model.compleArray addObject:pictureModel];
                            [WARPhotosUploadManger deleDataModel:pictureModel withParame:model];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"upCount" object:nil];
                            [weakself upload];
                        } failer:^(id response) {
                            [WARProgressHUD showAutoMessage:@"请求超时失败"];
                            [WARPhotosUploadManger deleDataModel:pictureModel withParame:model];
                             [weakself upload];
                        
                        }];
                    }
                    
                } errorInfo:^{
                    [WARPhotosUploadManger deleDataModel:pictureModel withParame:model];
                    [weakself upload];
                }];
            }else{
            }
        } failure:^(NSString *errorMessage, NSError *error) {
            
        }];


        
    });
    
    
}



- (void)end
{
    isload = NO;
    if ([[WARPhotosUploadManger sharedGolbalViewManager] aryTasker].count > 0) {
    
   
        // 删除第一个
        [[[WARPhotosUploadManger sharedGolbalViewManager] aryTasker] removeObjectAtIndex:0];
        // 删除了还有继续下载
        if ([[WARPhotosUploadManger sharedGolbalViewManager] aryTasker].count > 0) {
            [self start];
        }
        
    }
    
}
- (NSMutableArray*)aryTasker //初始化任务列表并且返回任务
{
 
    if (arryQueue == nil) {
        arryQueue = [[NSMutableArray alloc] init];
        
        if ([WARPhotosUploadManger allUploadTaskModel].count != 0) {
            arryQueue = [WARPhotosUploadManger allUploadTaskModel];
        }
        
    }
    return arryQueue;
}
+ (NSArray<WARGroupModel *> *)allUploadTaskModel {
 __block   NSMutableArray *array = [NSMutableArray array];
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableSet *set=[NSMutableSet set];
    for (WARDBPhotoTaskModel *taskModel in [WARDBPhotoTaskModel allObjects]) {

        [set addObject:taskModel.albumId];

    }
 
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {//遍历set数组
         WARGroupModel *model  = [[WARGroupModel alloc] init];
         RLMResults *results = [WARDBPhotoTaskModel objectsWhere:@"albumId = %@",obj];
         model.albumId = (NSString*)obj;
        for (WARDBPhotoTaskModel *taskModel in results) {
            WARupPictureModel * PictureModel = [[WARupPictureModel alloc] init];
            PictureModel.creatDate = taskModel.creatDate;
            PictureModel.stateStr = @"待定";
            PictureModel.pixwidth = taskModel.pixwidth;
            PictureModel.pixHeight = taskModel.pixHeight;
//            PictureModel.location = taskModel.location;
            PictureModel.isSelectOriginalPhoto = taskModel.isSelectOriginalPhoto;
            PictureModel.albumId = taskModel.albumId;
            PictureModel.taskModelId = taskModel.taskModelId;
            PictureModel.filePath = taskModel.filePath;
            PictureModel.mediaType = taskModel.mediaType;
            PictureModel.mimeType = taskModel.mimeType;
            PictureModel.localIdentifier = taskModel.localIdentifier;
            [model.uploadArray addObject:PictureModel];
        }
        [array addObject:model];
    }];
    
    return array;
}
- (void)uploadData:(WARGroupModel*)upGroupModel upImages:(NSArray*)photos upPhaset:(NSArray*)assets loactions:(NSArray<NSString *> *)photoLocations isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    WARGroupModel *groupModel = upGroupModel;

    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[self uploadData:assets loacations:photoLocations isSelectOriginalPhoto:isSelectOriginalPhoto atGroupModel:upGroupModel]];
    [WARDBUploadPhotoManger creatOrUpdateUploadTask:array];
    __block NSInteger idxIndex = 0;

    if ([self isContainKey:groupModel]) {
        [self.aryTasker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            WARGroupModel *gModel = (WARGroupModel*)obj;
            if ([gModel.albumId isEqualToString:groupModel.albumId]) {
                NSMutableArray *arrayM = [NSMutableArray arrayWithArray:gModel.uploadArray];
                idxIndex = idx;
                [arrayM addObjectsFromArray:array];
                groupModel.uploadArray = arrayM;
                
            }
            
        }];
        
        [self.aryTasker replaceObjectAtIndex:idxIndex withObject:groupModel];
    }else{
        
        [groupModel.uploadArray addObjectsFromArray: array];
        
        [self.aryTasker addObject:groupModel];
    }
    
      [self start];
}
- (NSMutableArray*)uploadData:(NSArray*)phassets loacations:(NSArray<NSString *> *)photoLocations isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto atGroupModel:(WARGroupModel*)groupModel {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0;i < phassets.count;i++) {
        WARupPictureModel * model = [[WARupPictureModel alloc] init];
        PHAsset *aset = phassets[i];
//        UIImage *image = photos[i];
      
        model.creatDate = [self dateStr:aset.creationDate];
        if (aset.mediaType == 1) {
       
            model.filePath = [NSString stringWithFormat:@"%@.jpg",[self dateStr:aset.creationDate]];
        }else{

            model.filePath = [NSString stringWithFormat:@"%@.mp4",[self dateStr:aset.creationDate]];
        }

        model.stateStr = @"待定";
        NSString *localIdentifier =  aset.localIdentifier;
        model.localIdentifier = aset.localIdentifier;
        model.mediaType = aset.mediaType;
        model.pixwidth = aset.pixelWidth;
        model.pixHeight = aset.pixelHeight;
//        model.location = (photoLocations[i].length == 0 ? @"" : photoLocations[i]);
        model.isSelectOriginalPhoto = isSelectOriginalPhoto;
        model.albumId = groupModel.albumId;
        model.taskModelId = [[NSUUID UUID] UUIDString];
        [array addObject:model];
    }
    return array;
}
- (BOOL)isContainKey:(WARGroupModel*)model{
    __block  BOOL isContain = NO;
    [self.aryTasker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARGroupModel *gModel = (WARGroupModel*)obj;
        if ([gModel.albumId isEqualToString:model.albumId]) {
            isContain = YES;
        }
        
    }];
    return isContain;
}

- (NSString*)dateStr:(NSDate*)number{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:kCFCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear fromDate:number];
    return    [NSString stringWithFormat:@"%zd-%02zd-%02zd",[components year],[components month],[components day]];
}

+ (NSString *)webBrowserDirectory {
    NSString * documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"WARProfile"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!existed) {
        if ([fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return filePath;
        } else {
            return nil;
        }
    } else {
        return filePath;
    }
}

+ (NSString *)webBrowserCachePath:(NSString *)fileName {
    if (fileName == nil || fileName.length <= 0) {
        return nil;
    }
    return [[self webBrowserDirectory] stringByAppendingPathComponent:fileName];
}

@end
@implementation WARPhotosUploaModel


@end

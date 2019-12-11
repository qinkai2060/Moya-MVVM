//
//  WARDownPhotoManger.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/8.
//

#import "WARDownPhotoManger.h"
#import "WARGroupModel.h"
#import "WARMacros.h"
#import "WARNetwork.h"
#import "WARDBUploadPhotoManger.h"
#import "WARDBPhotoTaskModel.h"
#import "WARDBPhotoDownTaskModel.h"
@implementation WARDownPhotoManger
+ (WARDownPhotoManger*)sharedDownManager
{
    static WARDownPhotoManger *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
        
    });
    
    return sharedSVC;
    
}

- (void)start //开始任务
{
    
    // 如果有
    if ([[WARDownPhotoManger sharedDownManager] aryTasker].count > 0) {
        
        // 如果没开始执行
        if (!isload) {
            
            isload = YES;
            
            // 取出第一个
            WARGroupModel *downmodel  = [[[WARDownPhotoManger sharedDownManager] aryTasker] firstObject];
            downmodel.stateStr = @"正在上传";
                                  
            if (downmodel!=nil) {
                
                [self download];
            }
            
        }
    }else {
        
        NSObject *obj =   self;
        obj   = nil;
        
    }
}
+ (NSArray<WARGroupModel *> *)allUploadTaskModel {
    __block   NSMutableArray *array = [NSMutableArray array];
    

    NSMutableSet *set=[NSMutableSet set];
    for (WARDBPhotoDownTaskModel *taskModel in [WARDBPhotoDownTaskModel allObjects]) {
        
        [set addObject:taskModel.albumId];
        
    }
    
    [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {//遍历set数组
        WARGroupModel *model  = [[WARGroupModel alloc] init];
        RLMResults *results = [WARDBPhotoDownTaskModel objectsWhere:@"albumId = %@",obj];
        model.albumId = (NSString*)obj;
        for (WARDBPhotoDownTaskModel *taskModel in results) {
            WARDownPictureModel * PictureModel = [[WARDownPictureModel alloc] init];
            
            PictureModel.image = [UIImage imageWithData:taskModel.image];
            PictureModel.creatDate = taskModel.creatDate;
            PictureModel.stateStr = @"待定";
            PictureModel.totalSize = taskModel.totalSize;
            PictureModel.isSelectOriginalPhoto = taskModel.isSelectOriginalPhoto;
            PictureModel.albumId = taskModel.albumId;
            PictureModel.pictureId = taskModel.pictureId;
            PictureModel.taskModelId = taskModel.taskModelId;
            [model.downArray addObject:PictureModel];
        }
        [array addObject:model];
    }];
    
    return array;
}

- (void)download {
    WS(weakself);
    WARGroupModel *model  = [[[WARDownPhotoManger sharedDownManager] aryTasker] firstObject];
    if (model.downArray.count > 0) {
        WARDownPictureModel *pictureModel = [model.downArray firstObject];
        NSString *url = @"";

        if([pictureModel.type isEqualToString:@"VIDEO"]){
            url = pictureModel.videoId;
        }else{
            NSString *tempStr = kOriginMediaUrl(pictureModel.pictureId).absoluteString;
            if (pictureModel.isSelectOriginalPhoto) {
                url = tempStr;
            }else {
                tempStr = kCMPRPhotoUrl(pictureModel.pictureId).absoluteString;
                url = tempStr;
            }
        }
        
        [WARNetwork downloadWithURL:url downProgressBlock:^(NSProgress *downProgress) {

            float progressfloat = ((float)(downProgress.completedUnitCount)) / downProgress.totalUnitCount;
            NSDictionary *progressInfo = downProgress.userInfo;
            NSNumber *startTimeValue = progressInfo[@"starTime"];
            NSNumber *startOffsetValue = progressInfo[@"offset"];
            NSInteger downloadSpeed = 0;
            if (startTimeValue) {
                CFAbsoluteTime startTime = [startTimeValue doubleValue];
                int64_t startOffset = [startOffsetValue longLongValue];
                downloadSpeed = (NSInteger)((downProgress.completedUnitCount - startOffset) / (CFAbsoluteTimeGetCurrent() - startTime));

                if (pictureModel.downblock) {
                    pictureModel.downblock(progressfloat,[weakself speed:downloadSpeed],downProgress.totalUnitCount);
                }
            } else {
                [downProgress setUserInfoObject:@(CFAbsoluteTimeGetCurrent()) forKey:@"starTime"];
                [downProgress setUserInfoObject:@(downProgress.completedUnitCount) forKey:@"offset"];
                if (pictureModel.downblock) {
                    pictureModel.downblock(progressfloat,[weakself speed:downloadSpeed],downProgress.totalUnitCount);
                }
                
            }
        } completion:^(id responseObj, NSError *err) {
             NSDictionary *dict = responseObj;
            weakself.filePath = dict[@"localPath"];
            if ([pictureModel.type isEqualToString:@"VIDEO"]) {
                  UISaveVideoAtPathToSavedPhotosAlbum(dict[@"localPath"], self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
            }else{
                
                UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:dict[@"localPath"]], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
            }

        }];

    }else{
        
        
        [[WARDownPhotoManger sharedDownManager] end];
      
    }
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (!error) {
        NDLog(@"保存视频成功%@", error.localizedDescription);
        WARGroupModel *model  = [[self aryTasker] firstObject];
        if (model.downArray.count != 0) {
            WARDownPictureModel *pictureModel = [model.downArray firstObject];
            [WARDBUploadPhotoManger deleteDownTaskBytaskModelId:pictureModel.taskModelId];
            [model.downArray removeObjectAtIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downCount" object:nil];
        }
        if (self.filePath.length >0) {
            if ([[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil]) {
                self.filePath = @"";
            }
        }
        if (self.finshBlock) {
            self.finshBlock();
        }
        
        [self download];
    }else{
        WARGroupModel *model  = [[self aryTasker] firstObject];
        if (model.downArray.count != 0) {
            WARDownPictureModel *pictureModel = [model.downArray firstObject];
            [WARDBUploadPhotoManger deleteDownTaskBytaskModelId:pictureModel.taskModelId];
            [model.downArray removeObjectAtIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downCount" object:nil];
        }
             [self download];
    }
}
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {


    if (error) {
        NDLog(@"保存图片失败%@", error.localizedDescription);
        WARGroupModel *model  = [[self aryTasker] firstObject];
        if (model.downArray.count != 0) {
            WARDownPictureModel *pictureModel = [model.downArray firstObject];
            [WARDBUploadPhotoManger deleteDownTaskBytaskModelId:pictureModel.taskModelId];
            [model.downArray removeObjectAtIndex:0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downCount" object:nil];
        }
            [self download];
    } else {
        NDLog(@"保存图片成功");
        WARGroupModel *model  = [[self aryTasker] firstObject];
        if (model.downArray.count != 0) {
            WARDownPictureModel *pictureModel = [model.downArray firstObject];
            [WARDBUploadPhotoManger deleteDownTaskBytaskModelId:pictureModel.taskModelId];
            [model.downArray removeObjectAtIndex:0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downCount" object:nil];
        }
        if (self.filePath.length >0) {
            if ([[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil]) {
                self.filePath = @"";
            }
        }
        if (self.finshBlock) {
            self.finshBlock();
        }
     
        [self download];
    }

}
- (NSString*)speed:(NSInteger)speedValue {
    if (speedValue < 1024) {
        return  [NSString stringWithFormat:@"%li Byte/s", speedValue];
    } else if (speedValue < 1024 * 1024 ) {
        return [NSString stringWithFormat:@"%li kb/s", speedValue / 1024];
    }else if (speedValue == 0) {
        
        return @"0 Byte/s";
    }
    else {
        return  [NSString stringWithFormat:@"%li mb/s", speedValue / 1024 / 1024];
    }
}
- (void)end
{
    isload = NO;
    if ([[WARDownPhotoManger sharedDownManager] aryTasker].count > 0) {
        
        
        // 删除第一个
        [[[WARDownPhotoManger sharedDownManager] aryTasker] removeObjectAtIndex:0];
        // 删除了还有继续下载
        if ([[WARDownPhotoManger sharedDownManager] aryTasker].count > 0) {
            [self start];
        }
        
    }
    
}
- (void )downDataSourceMore:(NSArray*)sourceArr atCurrentGroupModel:(WARGroupModel*)curretModel {
    NSMutableArray *arrayDownTask = [NSMutableArray array];
    for (int i = 0; i < sourceArr.count; i++) {
        WARDownPictureModel *downTaskModel = [[WARDownPictureModel alloc] init];
        WARPictureModel *pTempmodel = sourceArr[i];
        //                        downTaskModel.image = pTempmodel.image;
        downTaskModel.creatDate = pTempmodel.sortTime;
        downTaskModel.stateStr = @"待定";
        downTaskModel.pictureId = pTempmodel.pictureId;
        downTaskModel.albumId = pTempmodel.albumId;
        downTaskModel.videoId = pTempmodel.videoId.length == 0 ?@"":pTempmodel.videoId;
        downTaskModel.type = pTempmodel.type;
        downTaskModel.taskModelId = [[NSUUID UUID] UUIDString];
        [arrayDownTask addObject:downTaskModel];
    }
    [WARDBUploadPhotoManger creatOrUpdateDownTask:arrayDownTask];
    __block NSInteger idxIndex = 0;
    if ([self isContainKey:curretModel]) {
        [self.aryTasker  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            WARGroupModel *gModel = (WARGroupModel*)obj;
            if ([gModel.albumId isEqualToString:curretModel.albumId]) {
                NSMutableArray *arrayM = [NSMutableArray arrayWithArray:gModel.downArray];
                idxIndex = idx;
                [arrayDownTask addObjectsFromArray:gModel.downArray];
                curretModel.downArray = arrayDownTask;
                
                
            }
            
        }];
        
        [self.aryTasker replaceObjectAtIndex:idxIndex withObject:curretModel];
    }else{
        
        [curretModel.downArray addObjectsFromArray:arrayDownTask];
        
        [self.aryTasker  addObject:curretModel];
        
    }
    
        [self start];
    
}
- (void)downDataCurrentGroupModel:(WARGroupModel*)curretModel Source:(NSArray*)sourceArr atIndex:(NSInteger)index{
    NSMutableArray *arrayDownTask = [NSMutableArray array];
    arrayDownTask = [self downDataSource:sourceArr atIndex:index];
    WS(weakself);
    [WARDBUploadPhotoManger creatOrUpdateDownTask:arrayDownTask];
    __block NSInteger idxIndex = 0;
    if ([self isContainKey:curretModel]) {
        [ self.aryTasker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            WARGroupModel *gModel = (WARGroupModel*)obj;
            if ([gModel.albumId isEqualToString:curretModel.albumId]) {
                NSMutableArray *arrayM = [NSMutableArray arrayWithArray:gModel.downArray];
                idxIndex = idx;
                [arrayDownTask addObjectsFromArray:gModel.downArray];
                curretModel.downArray = arrayDownTask;
                
                
            }
            
        }];
        [[[WARDownPhotoManger sharedDownManager] aryTasker] replaceObjectAtIndex:idxIndex withObject:curretModel];
    }else{
        
        [curretModel.downArray addObjectsFromArray:arrayDownTask];
        
        [[[WARDownPhotoManger sharedDownManager]  aryTasker] addObject:curretModel];
    }
    [[WARDownPhotoManger sharedDownManager] start];
}
- (BOOL)isContainKey :(WARGroupModel*)model {
    __block  BOOL isContain = NO;
    [self.aryTasker enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WARGroupModel *gModel = (WARGroupModel*)obj;
        if ([gModel.albumId isEqualToString:model.albumId]) {
            isContain = YES;
        }
        
    }];
    return isContain;
}
- (NSMutableArray *)downDataSource:(NSArray*)sourceArr atIndex:(NSInteger)index {
    NSMutableArray *arrayDownTask = [NSMutableArray array];
    WARPictureModel *urlStr = sourceArr[index];
    
    WARDownPictureModel *downTaskModel = [[WARDownPictureModel alloc] init];
    
    downTaskModel.creatDate = urlStr.sortTime;
    downTaskModel.stateStr = @"待定";
    downTaskModel.pictureId = urlStr.pictureId;
    downTaskModel.albumId =  urlStr.albumId;
    downTaskModel.videoId = urlStr.videoId.length == 0 ?@"":urlStr.videoId;
    downTaskModel.type = urlStr.type;
    downTaskModel.taskModelId = [[NSUUID UUID] UUIDString];
    [arrayDownTask addObject:downTaskModel];
    return arrayDownTask;
}

- (NSMutableArray*)aryTasker //初始化任务列表并且返回任务
{
    
    if (arryQueue == nil) {
        arryQueue = [[NSMutableArray alloc] init];
        
        if ([WARDownPhotoManger allUploadTaskModel].count != 0) {
            
            arryQueue = [WARDownPhotoManger allUploadTaskModel];
        }
        
    }
    return arryQueue;
}
@end

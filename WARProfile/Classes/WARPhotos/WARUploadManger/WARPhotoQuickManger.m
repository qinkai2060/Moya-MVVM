//
//  WARPhotoQuickManger.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/14.
//

#import "WARPhotoQuickManger.h"
#import "TZImageManager.h"
#import "WARImagePickerController.h"
#import "TZAssetModel.h"
#import "WARPhotoModel.h"
#import "WARMacros.h"
dispatch_queue_t album_queue() {
    static dispatch_queue_t as_album_queue;
    static dispatch_once_t onceToken_album_queue;
    dispatch_once(&onceToken_album_queue, ^{
        as_album_queue = dispatch_queue_create("getAlbumVideo.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_album_queue;
}
@implementation WARPhotoQuickManger
+ (WARPhotoQuickManger*)shareManager
{
    static WARPhotoQuickManger *sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
        
    });
    
    return sharedSVC;
    
}
- (void)loadPhotoData{
    self.state = WARPhotoQuickMangerStateWait;
    WS(weakself);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        TZImagePickerConfig *conifig =  [TZImagePickerConfig sharedInstance];
        conifig.allowPickingImage = YES;
        conifig.allowPickingVideo = YES;
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *yuefengArr = [NSMutableArray array];
        [[TZImageManager manager] war_getCameraRollAlbumAssets:YES allowPickingImage:YES completion:^(NSMutableDictionary *mutDic) {
            // 排序
            
            NSArray *newArr  =  [mutDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *objOne = (NSString*)obj1;
                NSString *objTwo = (NSString*)obj2;
                
                NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow: [objOne doubleValue]];
                NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow: [objTwo doubleValue]];
                
                return [date1 compare:date2] == NSOrderedAscending;
            }];
            // 筛选月份
            NSMutableArray *filterArray = [NSMutableArray array];
            WARPhotoSegementControlModel *Segementmodel = [[WARPhotoSegementControlModel alloc] init];
            for (NSString *dateKey in newArr) {
                NSString *str =  [dateKey substringWithRange:NSMakeRange(0, 7)];
                [filterArray addObject:str];
            }
            NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
            NSSet *set = [NSSet setWithArray:filterArray];
            NSArray *newDateArray =  [set sortedArrayUsingDescriptors:sortDesc];
            
            
            for (NSString *dateStr in newDateArray) {
                WARPhotoModel *photoModel = [[WARPhotoModel alloc] init];
                photoModel.MothStr = dateStr;
                NSMutableArray *shuzu = [NSMutableArray array];
                [mutDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    NSString *str =  [key substringWithRange:NSMakeRange(0, 7)];
                    
                    
                    if ([dateStr isEqualToString:str]) {
                        [shuzu addObjectsFromArray:obj];
                    }
                }];
                photoModel.ModthArray  = shuzu.copy;
                [arr addObject:photoModel];
            }
            // 筛选年份
            NSMutableArray *filterYearArray = [NSMutableArray array];
            
            for (NSString *dateKey in newArr) {
                NSString *str =  [dateKey substringWithRange:NSMakeRange(0, 4)];
                [filterYearArray addObject:str];
            }
            
            NSArray *sortYearDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]];
            NSSet *setYear = [NSSet setWithArray:filterYearArray];
            NSArray *newYearDateArray =  [setYear sortedArrayUsingDescriptors:sortYearDesc];
            
            for (NSString *yearDate in newYearDateArray) {
                WARPhotoSegementControlModel *model = [[WARPhotoSegementControlModel alloc] init];
                NSMutableArray *shuzu = [NSMutableArray array];
                for (WARPhotoModel *photoModel in arr) {
                    NSString *str =  [photoModel.MothStr substringWithRange:NSMakeRange(0, 4)];
                    
                    if ([yearDate isEqualToString:str]) {
                        model.yearStr = str;
                        [shuzu addObject:photoModel];
                    }
                }
                model.ModthArray = shuzu.copy;
                [yuefengArr addObject:model];
            }

            
            weakself.state = WARPhotoQuickMangerStateLoading;
  
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i = 0; i < arr.count; i++) {
                WARPhotoModel *model = arr[i];
                model.ModthArray =  [model.ModthArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    TZAssetModel *asetModel1 = (TZAssetModel*)obj1;
                    TZAssetModel *asetModel2 = (TZAssetModel*)obj2;
                    PHAsset *asset1 = asetModel1.asset;
                    PHAsset *asset2 = asetModel2.asset;
                    return    [asset1.creationDate compare:asset2.creationDate];
                    
                }];
                [newArray addObject:model];
            }
             NSMutableArray *changeBigArr = [NSMutableArray arrayWithCapacity:yuefengArr.count];
            for (int i = 0; i < yuefengArr.count; i++) {

                WARPhotoSegementControlModel *model = yuefengArr[i];
                NSMutableArray *changeArr = [NSMutableArray arrayWithCapacity:arr.count];
                for (int i = 0; i < model.ModthArray.count; i++) {
                    WARPhotoModel *photomodel = model.ModthArray[i];
                    photomodel.ModthArray =  [photomodel.ModthArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        TZAssetModel *asetModel1 = (TZAssetModel*)obj1;
                        TZAssetModel *asetModel2 = (TZAssetModel*)obj2;
                        PHAsset *asset1 = asetModel1.asset;
                        PHAsset *asset2 = asetModel2.asset;
                        return    [asset2.creationDate compare:asset1.creationDate];
                        
                    }];
                    [changeArr addObject:photomodel];
                }
                [changeBigArr addObject:model];
            }
            weakself.state = WARPhotoQuickMangerStateComplete;
            self.segementArr = newArray;
            self.compareArr = changeBigArr;
        });
    });
    
}
- (NSDate*)transferOfDate:(NSString *)dateStr {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd";
    return   [dateFormater dateFromString:dateStr];
}
- (void)startManager { //注册相册的监听
    
    dispatch_async(album_queue(), ^{

        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
       
    });
}
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self loadPhotoData];
}
- (void)stopManager { //注销相册的监听
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    });
}
- (instancetype)init{
    if (self = [super init]) {
   
    }
    return self;
}
@end

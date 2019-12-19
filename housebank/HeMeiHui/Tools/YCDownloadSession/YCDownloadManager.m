//
//  YCDownloadManager.m
//  YCDownloadSession
//
//  Created by wz on 17/3/24.
//  Copyright © 2017年 onezen.cc. All rights reserved.
//  Contact me: http://www.onezen.cc
//  Github:     https://github.com/onezens/YCDownloadSession
//

#import "YCDownloadManager.h"
#import <UserNotifications/UserNotifications.h>

#define kCommonUtilsGigabyte (1024 * 1024 * 1024)
#define kCommonUtilsMegabyte (1024 * 1024)
#define kCommonUtilsKilobyte 1024

@interface YCDownloadManager ()

@property (nonatomic, strong) NSMutableDictionary *itemsDictM;
/**本地通知开关，默认关,一般用于测试。可以根据通知名称，自定义*/
@property (nonatomic, assign) BOOL localPushOn;

@end

@implementation YCDownloadManager

static id _instance;

#pragma mark - init

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self getDownloadItems];
        if(!self.itemsDictM) self.itemsDictM = [NSMutableDictionary dictionary];
        [self addNotification];
        __block BOOL isNeedSave = false;
        //waing async callback
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //get cached file size
            [self.itemsDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, YCDownloadItem *  _Nonnull item, BOOL * _Nonnull stop) {
                if (item.downloadStatus == YCDownloadStatusFailed || item.downloadStatus == YCDownloadStatusPaused) {
                    YCDownloadTask *task = [YCDownloadSession.downloadSession taskForTaskId:item.taskId];
                    item.downloadedSize = task.downloadedSize;
                    item.downloadStatus = task.downloadStatus;
                    item.readPercent = [self downloadWithtotalSize:task.fileSize andDownloadedSize:task.downloadedSize];
                    isNeedSave = true;
                }
            }];
            if(isNeedSave) [self saveDownloadItems];
        });
    }
    return self;
}

- (int64_t)downloadWithtotalSize:(int64_t)totalSize andDownloadedSize:(int64_t)downloadedSize{
    
    int64_t processStatus =0;
    float progress = 0.0;
    if (totalSize != 0) {
        progress = ((float)downloadedSize / totalSize);
    }
    // 注意 在点击下载的时候 processStatus字段设置为0
    if (progress > 0.0 && progress < 0.2){
        if (processStatus != 10) {
            processStatus = 10;
        }
    } else if (progress > 0.2 && progress < 0.3){
        if (processStatus != 20) {
            processStatus = 20;
        }
    } else if (progress > 0.3 && progress < 0.4){
        if (processStatus != 30) {
            processStatus = 30;
        }
    } else if (progress > 0.4 && progress < 0.5){
        if (processStatus != 40) {
            processStatus = 40;
        }
    } else if (progress > 0.5 && progress < 0.6){
        if (processStatus != 50) {
            processStatus = 50;
        }
    } else if (progress > 0.6 && progress < 0.7){
        if (processStatus != 60) {
            processStatus = 60;
        }
    } else if (progress > 0.7 && progress < 0.8){
        if (processStatus != 70) {
            processStatus = 70;
        }
    } else if (progress > 0.8 && progress < 0.9){
        if (processStatus != 80) {
            processStatus = 80;
        }
    } else if (progress > 0.9 && progress <1){
        if (processStatus != 90) {
            processStatus = 90;
        }
    } else if (progress == 1.0){
        if (processStatus != 100) {
            processStatus = 100;
        }
    }
    
    return processStatus;
}

- (void)saveDownloadItems {
    [NSKeyedArchiver archiveRootObject:self.itemsDictM toFile:[self downloadItemSavePath]];
}

- (void)getDownloadItems {
    NSMutableDictionary *items = [NSKeyedUnarchiver unarchiveObjectWithFile:[self downloadItemSavePath]];;
    
    //app闪退或者手动杀死app，会继续下载。APP再次启动默认暂停所有下载
    [items enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YCDownloadItem *item = obj;
        //app重新启动，将等待和下载的任务的状态变成暂停
        if (item.downloadStatus == YCDownloadStatusDownloading || item.downloadStatus == YCDownloadStatusWaiting) {
            item.downloadStatus = YCDownloadStatusPaused;
        }
    }];
    
    self.itemsDictM = items;
    
}

- (NSString *)downloadItemSavePath {
    NSString *saveDir = [YCDownloadTask saveDir];
    return [saveDir stringByAppendingPathComponent:@"items.data"];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDownloadItems) name:kDownloadStatusChangedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAllTaskFinished) name:kDownloadAllTaskFinishedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskFinishedNoti:) name:kDownloadTaskFinishedNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDownloadItems) name:kDownloadNeedSaveDataNoti object:nil];
}


#pragma mark - public


+ (void)setMaxTaskCount:(NSInteger)count {
    [[YCDownloadManager manager] setMaxTaskCount: count];
}


+ (void)startDownloadWithUrl:(NSString *)downloadURLString fileName:(NSString *)fileName imageUrl:(NSString *)imagUrl{
    [[YCDownloadManager manager] startDownloadWithUrl:downloadURLString fileName:fileName imageUrl:imagUrl];
}

+ (void)startDownloadWithUrl:(NSString *)downloadURLString fileName:(NSString *)fileName imageUrl:(NSString *)imagUrl fileId:(NSString *)fileId{
    [[YCDownloadManager manager] startDownloadWithUrl:downloadURLString fileName:fileName imageUrl:imagUrl fileId:fileId];
}

+ (void)pauseDownloadWithItem:(YCDownloadItem *)item {
    [[YCDownloadManager manager] pauseDownloadWithItem:item];
}


+ (void)resumeDownloadWithItem:(YCDownloadItem *)item {
    [[YCDownloadManager manager] resumeDownloadWithItem:item];
}

+ (void)stopDownloadWithItem:(YCDownloadItem *)item {
    [[YCDownloadManager manager] stopDownloadWithItem:item];
}

/**
 暂停所有的下载
 */
+ (void)pauseAllDownloadTask {
    [[YCDownloadManager manager] pauseAllDownloadTask];
}

+ (void)resumeAllDownloadTask {
    [[YCDownloadManager manager] resumeAllDownloadTask];
}

+ (void)removeAllCache {
    [[YCDownloadManager manager] removeAllCache];
}

+ (NSArray *)downloadList {
    return [[YCDownloadManager manager] downloadList];
}
+ (NSArray *)finishList {
    return [[YCDownloadManager manager] finishList];
}

+ (BOOL)isDownloadWithId:(NSString *)downloadId {
    return [[self manager] isDownloadWithId:downloadId];
}

+ (YCDownloadStatus)downloasStatusWithId:(NSString *)downloadId {
    return [[self manager] downloasStatusWithId:downloadId];
}

+ (YCDownloadItem *)downloadItemWithId:(NSString *)downloadId {
    return [[self manager] itemWithIdentifier:downloadId];
}

+(void)allowsCellularAccess:(BOOL)isAllow {
    [[YCDownloadManager manager] allowsCellularAccess:isAllow];
}

+(void)localPushOn:(BOOL)isOn {
    [[YCDownloadManager manager] localPushOn:isOn];
}

#pragma mark tools
+(BOOL)isAllowsCellularAccess{
    return [[YCDownloadManager manager] isAllowsCellularAccess];
}


+ (NSUInteger)videoCacheSize {
    NSUInteger size = 0;
    NSArray *downloadList = [self downloadList];
    NSArray *finishList = [self finishList];
    for (YCDownloadTask *task in downloadList) {
        size += task.downloadedSize;
    }
    for (YCDownloadTask *task in finishList) {
        size += task.fileSize;
    }
    return size;
    
}
+ (NSUInteger)fileSystemFreeSize {
    NSUInteger totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedIntegerValue];
    }
    return totalFreeSpace;
}

+ (void)saveDownloadStatus {
    [[YCDownloadManager manager] saveDownloadItems];
}
+ (NSString *)fileSizeStringFromBytes:(uint64_t)byteSize {
    if (kCommonUtilsGigabyte <= byteSize) {
        return [NSString stringWithFormat:@"%@GB", [self numberStringFromDouble:(double)byteSize / kCommonUtilsGigabyte]];
    }
    if (kCommonUtilsMegabyte <= byteSize) {
        return [NSString stringWithFormat:@"%@MB", [self numberStringFromDouble:(double)byteSize / kCommonUtilsMegabyte]];
    }
    if (kCommonUtilsKilobyte <= byteSize) {
        return [NSString stringWithFormat:@"%@KB", [self numberStringFromDouble:(double)byteSize / kCommonUtilsKilobyte]];
    }
    return [NSString stringWithFormat:@"%zdB", byteSize];
}


+ (NSString *)numberStringFromDouble:(const double)num {
    NSInteger section = round((num - (NSInteger)num) * 100);
    if (section % 10) {
        return [NSString stringWithFormat:@"%.2f", num];
    }
    if (section > 0) {
        return [NSString stringWithFormat:@"%.1f", num];
    }
    return [NSString stringWithFormat:@"%.0f", num];
}

#pragma mark - private

- (void)setMaxTaskCount:(NSInteger)count{
    [YCDownloadSession downloadSession].maxTaskCount = count;
}

- (void)startDownloadWithUrl:(NSString *)downloadURLString fileName:(NSString *)fileName imageUrl:(NSString *)imagUrl {
    
    [self startDownloadWithUrl:downloadURLString fileName:fileName imageUrl:imagUrl fileId:downloadURLString];
}

//下载文件时候的保存名称，如果没有fileid那么必须 savename = nil
- (NSString *)saveNameForItem:(YCDownloadItem *)item {
    
    NSString *saveName = [item.downloadUrl isEqualToString:item.fileId] ? nil : item.fileId;
    return saveName;
}


- (void)startDownloadWithUrl:(NSString *)downloadURLString fileName:(NSString *)fileName imageUrl:(NSString *)imagUrl fileId:(NSString *)fileId{
    
    if (downloadURLString.length == 0 && fileId.length == 0) return;
    NSString *taskId = [YCDownloadTask taskIdForUrl:downloadURLString fileId:fileId];
    YCDownloadItem *item = [self.itemsDictM valueForKey:taskId];
    if (item == nil) {
        
        item = [[YCDownloadItem alloc] initWithUrl:downloadURLString fileId:fileId];
        item.downloadStatus = YCDownloadStatusDownloading;
        item.fileName = fileName;
        item.thumbImageUrl = imagUrl;
        [self.itemsDictM setValue:item forKey:taskId];
    }
    [YCDownloadSession.downloadSession startDownloadWithUrl:downloadURLString fileId:fileId delegate:item];
}

- (void)resumeDownloadWithItem:(YCDownloadItem *)item{
    item.downloadStatus = YCDownloadStatusDownloading;

    if(item.compatibleKey.length>0){
        YCDownloadTask *task = [YCDownloadSession.downloadSession taskForTaskId:item.taskId];
        task.delegate = item;
        [YCDownloadSession.downloadSession resumeDownloadWithTaskId:item.taskId];
    }else{
        YCDownloadTask *task = [YCDownloadSession.downloadSession taskForTaskId:item.downloadUrl];
        task.delegate = item;
        //TODO: compatiable 1.0.0
        [YCDownloadSession.downloadSession resumeDownloadWithTaskId:item.taskId.length==0 ? item.downloadUrl : item.taskId];
    }
    [self saveDownloadItems];
}


- (void)pauseDownloadWithItem:(YCDownloadItem *)item {
    item.downloadStatus = YCDownloadStatusPaused;
    
    if(item.compatibleKey.length>0){
        [YCDownloadSession.downloadSession pauseDownloadWithTaskId:item.taskId];
    }else{
        //TODO: compatiable 1.0.0
        [YCDownloadSession.downloadSession pauseDownloadWithTaskId:item.taskId.length==0 ? item.downloadUrl : item.taskId];
    }
    [self saveDownloadItems];
}

- (void)stopDownloadWithItem:(YCDownloadItem *)item {
    if (item == nil )  return;
    [YCDownloadSession.downloadSession stopDownloadWithTaskId:item.taskId.length == 0 ? item.downloadUrl : item.taskId];
    //TODO: compatiable 1.0.0 [self.itemsDictM removeObjectForKey: item.taskId];
    [self.itemsDictM removeObjectForKey:item.taskId.length == 0 ? item.downloadUrl : item.taskId];
    [self saveDownloadItems];
}

- (void)pauseAllDownloadTask {
    [[YCDownloadSession downloadSession] pauseAllDownloadTask];
}

- (void)removeAllCache {
    [self.itemsDictM.copy enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, YCDownloadItem *  _Nonnull obj, BOOL * _Nonnull stop) {
        [self stopDownloadWithItem:obj];
    }];
}

- (void)resumeAllDownloadTask{
    [self.itemsDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YCDownloadItem *item = obj;
        if (item.downloadStatus == YCDownloadStatusPaused || item.downloadStatus == YCDownloadStatusFailed) {
            [self resumeDownloadWithItem:item];
        }
    }];
}

-(NSArray *)downloadList {
    NSMutableArray *arrM = [NSMutableArray array];
    
    [self.itemsDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YCDownloadItem *item = obj;
        if(item.downloadStatus != YCDownloadStatusFinished){
            [arrM addObject:item];
        }
    }];
    
    return arrM;
}
- (NSArray *)finishList {
    NSMutableArray *arrM = [NSMutableArray array];
    [self.itemsDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YCDownloadItem *item = obj;
        if(item.downloadStatus == YCDownloadStatusFinished){
            [arrM addObject:item];
        }
    }];
    return arrM;
}

/**id 可以是downloadUrl，也可以是fileId，首先从fileId开始找，然后downloadUrl*/

- (YCDownloadItem *)itemWithIdentifier:(NSString *)identifier {
    
    __block  YCDownloadItem *item = nil;
    [self.itemsDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YCDownloadItem *dItem = obj;
        if([dItem.fileId isEqualToString:identifier]){
            item = dItem;
            *stop = true;
        }
    }];
    
    if(item) return item;
    
    [self.itemsDictM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YCDownloadItem *dItem = obj;
        if([dItem.downloadUrl isEqualToString:identifier]){
            item = dItem;
            *stop = true;
        }
    }];
    
    return item;
}

-(void)allowsCellularAccess:(BOOL)isAllow {
    [[YCDownloadSession downloadSession] allowsCellularAccess:isAllow];
}

- (BOOL)isAllowsCellularAccess {
    return [[YCDownloadSession downloadSession] isAllowsCellularAccess];
}

- (BOOL)isDownloadWithId:(NSString *)downloadId {
    
    YCDownloadItem *item = [self itemWithIdentifier:downloadId];
    return item != nil;
}

- (YCDownloadStatus)downloasStatusWithId:(NSString *)downloadId {
    YCDownloadItem *item = [self itemWithIdentifier:downloadId];
    if (!item) {
        return -1;
    }
    return item.downloadStatus;
}

- (void)localPushOn:(BOOL)isOn {
    self.localPushOn = isOn;
}

#pragma mark notificaton

- (void)downloadAllTaskFinished{
//    [self localPushWithTitle:@"YCDownloadSession" detail:@"所有的下载任务已完成！"];
}

- (void)downloadTaskFinishedNoti:(NSNotification *)noti{
    
    YCDownloadItem *item = noti.object;
    if (item) {
        NSString *detail = [NSString stringWithFormat:@"%@ 视频，已经下载完成！", item.fileName];
        [self localPushWithTitle:@"合发" detail:detail withDownLoadItem:item];
    }
}


#pragma mark local push     以10.0为界限  本地推动分为10.0之前和10.0之后

- (void)localPushWithTitle:(NSString *)title detail:(NSString *)body withDownLoadItem:(YCDownloadItem *)item {
    
    if (!self.localPushOn) return;
    
    NSString *statusStr;
    switch (item.downloadStatus) {
        case YCDownloadStatusWaiting:
            statusStr = @"YCDownloadStatusWaiting";
            break;
        case YCDownloadStatusDownloading:
            statusStr = @"YCDownloadStatusDownloading";
            break;
        case YCDownloadStatusPaused:
            statusStr = @"YCDownloadStatusPaused";
            break;
        case YCDownloadStatusFinished:
            statusStr = @"YCDownloadStatusFinished";
            
            break;
        case YCDownloadStatusFailed:
            statusStr = @"YCDownloadStatusFailed";
            break;
            
        default:
            break;
    }
    
    // 使用 UNUserNotificationCenter 来管理通知
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"合发" arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:body arguments:nil];
        
        content.userInfo = @{@"fileName":item.fileName,@"savePath":item.savePath,@"fileId":item.fileId,@"downloadUrl":item.downloadUrl,@"taskId":item.taskId,@"thumbImageUrl":item.thumbImageUrl,@"fileSize":[NSNumber numberWithInteger:item.fileSize],@"downloadedSize":[NSNumber numberWithInteger:item.downloadedSize],@"downloadStatus":statusStr,@"compatibleKey":item.compatibleKey,@"saveName":item.saveName};
        content.sound = [UNNotificationSound defaultSound];
        
        // 在 设定时间 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:1.0 repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:item.fileId                                                                              content:content trigger:trigger];
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
            NSLog(@"添加推送成功");
        }];
        
    } else { // ios 10.0之前   8.0之后
        
        // 1.创建本地通知
        UILocalNotification *localNote = [[UILocalNotification alloc] init];
        
        // 2.设置本地通知的内容
        // 2.1.设置通知发出的时间
        localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
        // 2.2.设置通知的内容
        localNote.alertBody = body;
        // 2.3.设置滑块的文字（锁屏状态下：滑动来“解锁”）
        //    localNote.alertAction = @"滑动来“解锁”";
        // 2.4.决定alertAction是否生效
        localNote.hasAction = NO;
        // 2.5.设置点击通知的启动图片
        //    localNote.alertLaunchImage = @"123Abc";
        // 2.6.设置alertTitle
        localNote.alertTitle = title;
        // 2.7.设置有通知时的音效
        localNote.soundName = UILocalNotificationDefaultSoundName;
        // 2.8.设置应用程序图标右上角的数字
        localNote.applicationIconBadgeNumber = 0;
        
        // 2.9.设置额外信息
        //    localNote.userInfo = @{@"type" : @1};
        localNote.userInfo = @{@"fileName":item.fileName,@"savePath":item.savePath,@"fileId":item.fileId,@"downloadUrl":item.downloadUrl,@"taskId":item.taskId,@"thumbImageUrl":item.thumbImageUrl,@"fileSize":[NSNumber numberWithInteger:item.fileSize],@"downloadedSize":[NSNumber numberWithInteger:item.downloadedSize],@"downloadStatus":statusStr,@"compatibleKey":item.compatibleKey,@"saveName":item.saveName};
        // 3.调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

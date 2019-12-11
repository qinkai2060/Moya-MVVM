//
//  WARPhotosUploadManger.h
//  Pods
//
//  Created by 秦恺 on 2018/3/26.
//

#import <Foundation/Foundation.h>
#import "WARGroupModel.h"

typedef void(^CompleteFinshBlock)(NSArray *compleUrlArr);
@interface WARPhotosUploadManger : NSObject
{
     NSMutableArray* arryQueue;// 任务队列 一个任务包含着一组图片 
        BOOL isload;
}
@property (nonatomic,strong) NSArray *uploadUrlArr;

@property (nonatomic,strong) NSURLSession *session;
/**model*/
@property (nonatomic,copy) CompleteFinshBlock finshBlock;
- (NSMutableArray*)aryTasker;
+ (WARPhotosUploadManger*)sharedGolbalViewManager;
- (void)end;
- (void)start;
- (BOOL)isContainKey:(WARGroupModel*)model;

- (void)uploadData:(WARGroupModel*)upGroupModel upImages:(NSArray*)photos upPhaset:(NSArray*)assets loactions:(NSArray<NSString *> *)photoLocations isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
- (NSMutableArray*)uploadData:(NSArray*)phassets loacations:(NSArray<NSString *> *)photoLocations isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto atGroupModel:(WARGroupModel*)groupModel;
@end
typedef NS_ENUM(NSUInteger, WARPhotosUploaModelState) {
    /* 默认状态，不会下载 */
    WARPhotosUploaModelStateNormal,
    /* 等待下载 */
   WARPhotosUploaModelStateWait,
    /* 正在下载 */
    WARPhotosUploaModelStateLoading,
    /* 下载暂停 */
    WARPhotosUploaModelStatePaused,
    /* 下载完成 */
    WARPhotosUploaModelStateComplete,
    /* 下载失败 */
    WARPhotosUploaModelStateError,
};
@interface WARPhotosUploaModel : NSObject
/**groupModel*/
@property (nonatomic,strong) WARGroupModel *model;

/**url*/
@property (nonatomic,strong) NSMutableArray *uploadUrlArr;
//@property (nonatomic,strong) NSMutableDictionary *pictureParms;
//@property (nonatomic,strong) NSMutableDictionary *videoParms;
//@property (nonatomic,strong) NSArray *uploadLoactionArr;
@property (nonatomic,strong) NSArray *dateArr;
@property (nonatomic,strong) NSArray *widthArr;
@property (nonatomic,strong) NSArray *heightArr;
@property (nonatomic,strong) NSString *videopath;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,assign) PHAssetMediaType mediaType;
@property (nonatomic,strong) PHAsset *asset;
@property (nonatomic,assign) WARPhotosUploaModelState state;
@end

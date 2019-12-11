//
//  WARDownPhotoManger.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/8.
//

#import <Foundation/Foundation.h>
@class WARGroupModel;
typedef void(^CompleteDownFinshBlock)();
@interface WARDownPhotoManger : NSObject
{
    NSMutableArray* arryQueue;// 任务队列 一个任务包含着一组图片
    BOOL isload;
}
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,copy) CompleteDownFinshBlock finshBlock;
+ (WARDownPhotoManger*)sharedDownManager;
- (NSMutableArray*)aryTasker;
- (void)end;
- (void)start;
- (BOOL)isContainKey :(WARGroupModel*)model;

/**
 在浏览器中下载

 @param curretModel 当前页面的model
 @param sourceArr 数据源
 @param index 当前索引
 */
- (void)downDataCurrentGroupModel:(WARGroupModel*)curretModel Source:(NSArray*)sourceArr atIndex:(NSInteger)index;
// 批量管理下载
- (void)downDataSourceMore:(NSArray*)sourceArr atCurrentGroupModel:(WARGroupModel*)curretModel;
@end

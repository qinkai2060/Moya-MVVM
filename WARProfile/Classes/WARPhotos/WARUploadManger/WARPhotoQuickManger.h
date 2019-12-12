//
//  WARPhotoQuickManger.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/14.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
typedef NS_ENUM(NSUInteger, WARPhotoQuickMangerState) {

    WARPhotoQuickMangerStateWait,
    
    WARPhotoQuickMangerStateLoading,
    
    WARPhotoQuickMangerStateComplete,
};
@interface WARPhotoQuickManger : NSObject<PHPhotoLibraryChangeObserver>
@property(nonatomic,strong)NSArray *segementArr;
@property(nonatomic,strong)NSArray *compareArr;
@property(nonatomic,assign)WARPhotoQuickMangerState state;
+ (WARPhotoQuickManger*)shareManager;
// 获取数据
- (void)loadPhotoData;
- (void)startManager;
- (void)stopManager;
@end

//
//  WARPhotoVideoListModel.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import <Foundation/Foundation.h>

@interface WARPhotoVideoListModel : NSObject
/**最后拍摄时间*/
@property (nonatomic,copy) NSString *lastShootTime;
/**pictures*/
@property (nonatomic,strong) NSMutableArray *videos;

@property (nonatomic,copy) NSString *lastFindId;

- (void)prase:(id)obj;
+ (id)EmptyCheckobjnil:(id)obj;
+ (NSString*)dataStr:(NSString*)number;
@end
@interface WARPhotoVideoModel:NSObject
/**日期*/
@property (nonatomic,copy) NSString *date;
/**图片数组*/
@property (nonatomic,strong) NSMutableArray *dateData;

- (void)prase:(NSDictionary*)obj;
+ (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration;
@end
//@interface WARVideoModel:NSObject
///**id*/
//@property (nonatomic,copy) NSString *albumId;
///**描述*/
//@property (nonatomic,copy) NSString *desc;
///**pictureId*/
//@property (nonatomic,copy) NSString *pictureId;
//
//@property (nonatomic,copy) NSString *sortTime;
//
//@property (nonatomic,copy) NSString *duration;
//
//@property (nonatomic,copy) NSString *videoId;
///**video*/
//@property (nonatomic,copy) NSDictionary *video;
//- (void)prase:(NSDictionary*)obj;
//@end

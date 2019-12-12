//
//  WARPhotoListModel.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import <Foundation/Foundation.h>

@interface WARPhotoListModel : NSObject
/**最后拍摄时间*/
@property (nonatomic,copy) NSString *lastShootTime;
@property (nonatomic,copy) NSString *lastFindId;
/**pictures*/
@property (nonatomic,strong) NSMutableArray *pictures;

- (void)prase:(id)obj;
+ (id)EmptyCheckobjnil:(id)obj;
+ (NSString*)dataStr:(NSString*)number;
@end

@interface WARPhotoPictureModel:NSObject
/**日期*/
@property (nonatomic,copy) NSString *date;
/**图片数组*/
@property (nonatomic,strong) NSMutableArray *dateData;

- (void)prase:(NSDictionary*)obj;
@end

//@interface WARAlbumPictureModel:NSObject
///**id*/
//@property (nonatomic,copy) NSString *albumId;
///**描述*/
//@property (nonatomic,copy) NSString *desc;
///**pictureId*/
//@property (nonatomic,copy) NSString *pictureId;
//
//@property (nonatomic,assign) BOOL original;
//
//
//@property (nonatomic,copy) NSString *sortTime;
//- (void)prase:(NSDictionary*)obj;
//- (void)praseOther:(NSDictionary *)obj;
//@end

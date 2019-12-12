//
//  WARPhotoDetailsViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import "WARPhotoBaseViewController.h"
@class WARGroupModel;
@interface WARPhotoDetailsViewController : WARPhotoBaseViewController
@property(nonatomic,strong)WARGroupModel *DetailGroupModel;
@property(nonatomic,assign)BOOL isOtherEnterHome;
@property(nonatomic,assign)BOOL isFromeCreat;
@property (nonatomic,assign) NSInteger uploadCount;
- (instancetype)initWithModel:(WARGroupModel*)model atAccountID:(NSString*)accountID;
@end

//
//  WARProfileGatherViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/14.
//

#import <UIKit/UIKit.h>
#import "WARFavriteMineView.h"
@class WARFavoriteInfoModel;
typedef void (^creatVCFavriteBlock)();
typedef void (^editingVCFavriteBlock)(WARFavoriteInfoModel *model);
@interface WARProfileFavoriteViewController : UIViewController
@property (nonatomic,copy) creatVCFavriteBlock creatBlock;
@property (nonatomic,copy) editingVCFavriteBlock editingBlock;
@property (assign, nonatomic) BOOL canScroll;
- (void)actionSheetClick:(WARFavoriteInfoModel*)model;
@end

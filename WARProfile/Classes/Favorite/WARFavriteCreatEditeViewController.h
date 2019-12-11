//
//  WARFavriteCreatEditeViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import <UIKit/UIKit.h>
#import "WARNavgationCutsomBar.h"
#import "WARFavoriteModel.h"
@interface WARFavriteCreatEditeViewController : UIViewController
- (void)enterEditingFav:(WARFavoriteInfoModel*)model;
- (instancetype)initWithType:(NSInteger)type withlinkURL:(NSString*)url;
@end

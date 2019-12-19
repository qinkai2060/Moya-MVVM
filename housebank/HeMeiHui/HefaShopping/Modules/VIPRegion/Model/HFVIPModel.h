//
//  HFVIPModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFHomeBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFVIPModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *cashPrice;
@property(nonatomic,strong)NSString *stock;
@property(nonatomic,strong)NSString *saleCount;
@property(nonatomic,strong)NSString *imagUrl;
@property(nonatomic,strong)NSString *productId;
- (void)getData:(NSDictionary *)data;

@end
@interface HFSegementModel:HFHomeBaseModel
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)NSString *channelId;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,strong)NSArray<HFVIPModel*> *dataSource;
@end
@interface HFHotKeyModel : HFHomeBaseModel
@property(nonatomic,strong)NSString *mainTitle;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSArray<HFHotKeyModel*> *dataSource;
- (void)getVipData:(NSDictionary *)data;
@end


NS_ASSUME_NONNULL_END

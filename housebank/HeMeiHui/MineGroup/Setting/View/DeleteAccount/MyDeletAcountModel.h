//
//  MyDeletAcountModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDeletAcountModel : NSObject
@property(nonatomic,assign)NSInteger contentMode;
@property(nonatomic,copy)NSString *imageStr;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *subtitle;
@property(nonatomic,strong)NSString *subBoldtitle;
@property(nonatomic,assign)CGFloat rowHeight ;
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype;
- (void)getData:(NSDictionary *)data;
+ (Class)getRenderClassByMessageType:(NSInteger)mtype;
@end

NS_ASSUME_NONNULL_END

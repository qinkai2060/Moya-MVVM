//
//  VIPGiftSelectHeadView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/9/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^CallBlock)(NSInteger index,NSString * sectionString,NSInteger section);
@interface VIPGiftSelectHeadView : UIView
- (void)setUpHeadDataSource:(NSDictionary *)headDic index:(NSInteger)path heightBlock:(void(^)(CGFloat height))block;
@property (nonatomic, copy) CallBlock callHeadBlock;
- (void)changeSelectBtnImage:(NSMutableDictionary *)dic withDataSource:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END

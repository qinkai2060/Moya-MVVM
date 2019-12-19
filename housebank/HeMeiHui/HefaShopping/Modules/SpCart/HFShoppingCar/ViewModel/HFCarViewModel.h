//
//  HFCarViewModel.h
//  housebank
//
//  Created by usermac on 2018/11/6.
//  Copyright © 2018 hefa. All rights reserved.
//


#import "HFViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFCarViewModel : HFViewModel
@property(nonatomic,strong)RACSubject *resetSpecialsSubjc;
@property(nonatomic,strong)RACSubject *getCarInfo;
@property(nonatomic,strong)RACSubject *enterCommitPayMent;
@property(nonatomic,strong)RACSubject *enterStoreSubjc;
@property(nonatomic,strong)RACSubject *enterDetailSubjc;
@property(nonatomic,strong)RACSubject *allSelectSubjc;
@property(nonatomic,strong)RACSubject *plusSubjc;
@property(nonatomic,strong)RACSubject *minSubjc;
@property(nonatomic,strong)RACSubject *editingSelectSubjc;
@property(nonatomic,strong)RACSubject *favSubjc;
@property(nonatomic,strong)RACSubject *deleteSubjc;
@property(nonatomic,strong)RACSubject *endEditingSubjc;
@property(nonatomic,strong)RACSubject *quickDeleteSubjc;
@property(nonatomic,strong)RACSubject *goCategorySubjc;
@property(nonatomic,strong)RACSubject *deleteFavEndingSubjc;
@property(nonatomic,strong)RACSubject *resetNetworkSubjc;
@property(nonatomic,strong)RACCommand *getCardDetialCommand;
@property(nonatomic,strong)RACSubject  *editShopCountSubkjc;
@property(nonatomic,strong)RACCommand *editShopCountCommand;
@property(nonatomic,strong)RACCommand *editDeleteCommand;
@property(nonatomic,strong)RACCommand *editFavCommand;
@property(nonatomic,strong)RACCommand *resetSpecialCommand;
@property(nonatomic,strong)RACSubject *resetEditingButtonStateSubjc;
@property(nonatomic,strong)NSMutableArray *dataSource;
//@property(nonatomic,assign) NSInteger totalShoppingCount;
@property(nonatomic,strong)NSDictionary *resetSpecialPrams;
@property(nonatomic,assign) NSInteger count;
@property(nonatomic,copy) NSString *productId;
// 批量删除收藏参数
@property(nonatomic,copy) NSString *shopID;
@property(nonatomic,copy) NSString *cardID;
@property(nonatomic,copy) NSString *ProductID;
@end

NS_ASSUME_NONNULL_END

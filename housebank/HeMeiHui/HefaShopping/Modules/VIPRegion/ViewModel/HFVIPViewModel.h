//
//  HFVIPViewModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewModel.h"
#import "HFVIPModel.h"
#import "HFSectionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFVIPViewModel : HFViewModel
@property (nonatomic,strong)HFViewModel *model;

@property(nonatomic,strong)NSMutableDictionary *getAllKey;

@property (nonatomic,strong)NSString *keyWord;
@property (nonatomic,strong)NSString *classId;
@property (nonatomic,assign)NSInteger pageNo;


@property (nonatomic,strong)RACSubject *getHotkeySubjc;
@property (nonatomic,strong)RACCommand *getHotkeyCommand;

@property (nonatomic,strong)RACSubject *homeMainSubjc;
@property (nonatomic,strong)RACCommand *homeMainCommand;

@property (nonatomic,strong)RACSubject *VipSearchSubjc;
@property (nonatomic,strong)RACCommand *VipSearchCommand;

@property (nonatomic,strong)RACSubject *VipShareSubjc;
@property (nonatomic,strong)RACCommand *VipShareCommand;

@property (nonatomic,strong)HFSectionModel *classCategoryModel;

@property (nonatomic,strong)HFSectionModel *hotkeyModel;


/**
 跳转
 */
@property (nonatomic,strong)RACSubject *enterSearchSubjc;
@property (nonatomic,strong)RACSubject *didBrowserSubjc;
@property (nonatomic,strong)RACSubject *didFashionSubjc;
@property (nonatomic,strong)RACSubject *didVideoSubjc;
@property (nonatomic,strong)RACSubject *didGoodsSubjc;

+ (void)loadCategoryDataPageNo:(NSInteger)pageNo keyWord:(NSString*)keyWord classId:(NSString *)classId success:(void(^)(YTKBaseRequest *request))success error:(void(^)(YTKBaseRequest *request))error;
@end

NS_ASSUME_NONNULL_END

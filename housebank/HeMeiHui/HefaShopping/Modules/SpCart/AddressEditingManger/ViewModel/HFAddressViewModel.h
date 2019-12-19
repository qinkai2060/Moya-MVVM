//
//  HFAddressViewModel.h
//  housebank
//
//  Created by usermac on 2018/11/16.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFAddressViewModel : HFViewModel
@property (nonatomic,strong)RACSubject *sureTagSuj;
@property (nonatomic,strong)RACSubject *selectedEditingSuj;
@property (nonatomic,strong)RACSubject *contactsSubj;
@property (nonatomic,strong)RACSubject *selectAreaSubj;
@property (nonatomic,strong)RACSubject *PCCSelectorSubjc;
@property (nonatomic,strong)RACSubject *didSelectSubjc;
@property (nonatomic,strong) NSArray *addressArr; // 解析出来的最外层数组
@property (nonatomic,strong) NSArray *provinceArr; // 省
@property (nonatomic,strong) NSArray *countryArr; // 市
@property (nonatomic,strong) NSArray *districtArr; // 区
- (void)loadFirstData;
@end

NS_ASSUME_NONNULL_END

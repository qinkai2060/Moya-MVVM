//
//  HFPCCSelectorView.h
//  housebank
//
//  Created by usermac on 2018/11/19.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFAddressListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFPCCSelectorView : HFView
@property (nonatomic,strong)HFAddressListViewModel *viewModel;
@property (nonatomic,strong)NSArray *datasource;
@end

NS_ASSUME_NONNULL_END

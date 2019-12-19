//
//  HMHPBSearchResultViewController.h
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/9/5.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHPersonInfoModel;
typedef void(^searchViewSendMessageClick)(HMHPersonInfoModel *infoMmodel,BOOL isSearchView,BOOL isMember);

@interface HMHPBSearchResultViewController : UIViewController<UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, copy) searchViewSendMessageClick sendMessageClickBlock;

@end

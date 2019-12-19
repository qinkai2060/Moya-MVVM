
//
//  HFLoginH5WebViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/30.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewController.h"
#import "CloudBottomView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFLoginH5WebViewController: HFViewController
@property(nonatomic,strong)NSString *url;
@property (nonatomic, assign) BOOL isBottomButton; // 是否协议下增加按钮
@property (nonatomic, strong) CloudBottomView * bottomView;
@end

NS_ASSUME_NONNULL_END

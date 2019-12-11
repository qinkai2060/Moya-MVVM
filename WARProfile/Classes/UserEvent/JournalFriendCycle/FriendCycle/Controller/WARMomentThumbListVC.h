//
//  WARMomentThumbListVC.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/19.
//

#import "WARBaseViewController.h"

@interface WARMomentThumbListVC : WARBaseViewController

- (instancetype)initWithMomentId:(NSString *)momentId
                pThumbTotalCount:(NSInteger)pThumbTotalCount
                fThumbTotalCount:(NSInteger)fThumbTotalCount
                       nickname:(NSString *)nickname;

@end

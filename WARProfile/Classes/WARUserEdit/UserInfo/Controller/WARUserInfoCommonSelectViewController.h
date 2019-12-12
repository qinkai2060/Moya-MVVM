//
//  WARUserInfoCommonSelectViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/28.
//

#import <UIKit/UIKit.h>
#import "WARUserInfoBaseViewController.h"

typedef NS_ENUM(NSInteger,UserInfoCommonSelectType) {
    UserInfoCommonSelectTypeOfBook= 0,
    UserInfoCommonSelectTypeOfMovie,
    UserInfoCommonSelectTypeOfMusic,
    UserInfoCommonSelectTypeOfGame,
};


typedef void(^UserInfoCommonSelectDidFinishEditBlock)(NSArray *arr);

@interface WARUserInfoCommonSelectViewController : WARUserInfoBaseViewController

@property (nonatomic, copy)UserInfoCommonSelectDidFinishEditBlock didFinishEditBlock;

@property (nonatomic, strong)NSMutableArray *dataArr;


- (instancetype)initWithType:(UserInfoCommonSelectType)type;


@end

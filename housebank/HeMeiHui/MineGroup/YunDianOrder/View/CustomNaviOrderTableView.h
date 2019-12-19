//
//  CustomNaviOrderTableView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CustomNaviOrderTableViewClickType) {
    CustomNaviOrderTableViewClickClose,//点击空白关闭
    CustomNaviOrderTableViewClickTableSelect//tableviewcell点击
};

NS_ASSUME_NONNULL_BEGIN

@protocol CustomNaviOrderTableViewDelegate <NSObject>

-(void)customNaviOrderTableViewDelegateType:(CustomNaviOrderTableViewClickType)clickType index:(NSInteger)index;

@end

@interface CustomNaviOrderTableView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrDate;
@property (nonatomic, strong) NSString *selectStr;
@property (nonatomic, weak) id <CustomNaviOrderTableViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

//
//  HFSegmentView.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^didBlock)(NSInteger index);
typedef void (^didSeletBlock)(NSInteger index);
@interface HFSegmentView : UIView
@property(nonatomic,copy)didSeletBlock didSelect;
@property(nonatomic,assign)NSInteger selectIndex;
@end
@interface HFBageSegmentView:UIView
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,copy)NSString  *title;
@property(nonatomic,copy)didBlock didSelect;
@end
NS_ASSUME_NONNULL_END

//
//  HFYDTableView.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFYDTableView : UIScrollView
@property(nonatomic,strong)UIImageView *noContentView;
@property(nonatomic,strong)UILabel *noContentLb;
- (void)setErrorImage:(NSString *)imageStr text:(NSString*)textStr;
- (void)haveData;
@end

NS_ASSUME_NONNULL_END

//
//  AboutUsView.h
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AboutUsViewType) {
    
    AboutUsViewtTypeAboutHF, //关于合发
    AboutUsViewtTypeIdea, // 意见箱
    AboutUsViewtTypeBossEmail, // 董事长邮箱
    AboutUsViewtTypeCallUs // 联系我们
};

typedef void(^AboutUsViewClickBlock)(AboutUsViewType type);

@interface AboutUsView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrDateSoure;
@property (nonatomic, copy) AboutUsViewClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END

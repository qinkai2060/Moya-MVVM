//
//  PersonInformationBaseView.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PersonInformationBaseView : UIControl

@property (nonatomic,copy)NSString *content;

@property (nonatomic,copy)NSString *urlString;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,assign)PersonInformationType currentType;

- (void)setSubview;

@end

NS_ASSUME_NONNULL_END

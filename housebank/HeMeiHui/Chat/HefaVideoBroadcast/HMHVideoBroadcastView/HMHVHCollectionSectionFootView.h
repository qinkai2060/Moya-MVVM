//
//  CollectionSectionFootView.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHVHCollectionSectionFootView;
//协议
@protocol CollectionSectionFootViewDelegate <NSObject>
@optional

/**
 查看全部按钮的点击事件
 @param sectionIndex 分区index
 */
- (void)bottomToSeeAllVideoBtnClickWithSection:(NSInteger)sectionIndex;

@end

@interface HMHVHCollectionSectionFootView : UICollectionReusableView

@property (nonatomic, assign) NSInteger sectionIndex;

@property (nonatomic, strong) NSString *bottomStr;

@property (nonatomic, weak) id<CollectionSectionFootViewDelegate> delegate;

-(void)refreshTitle:(NSString *)titleStr;

@end

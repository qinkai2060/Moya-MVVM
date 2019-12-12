//
//  WARDiaryDetailHeaderView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/11.
//

#import <UIKit/UIKit.h>

@class WARCMessageModel,WARMoment,WARDiaryDetailHeaderView,WARFeedComponentContent,WARDBContactModel,WARFeedImageComponent;

@protocol WARDiaryDetailHeaderViewDelegate <NSObject>

@optional

-(void)headerView:(WARDiaryDetailHeaderView *)headerView didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents;

-(void)headerView:(WARDiaryDetailHeaderView *)headerView showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index;

-(void)headerViewShowPop:(WARDiaryDetailHeaderView *)headerView showFrame:(CGRect)frame;

-(void)headerViewDidUserHeader:(WARDiaryDetailHeaderView *)headerView model:(WARDBContactModel *)model;

-(void)headerViewDidNoInterest:(WARDiaryDetailHeaderView *)headerView ;

-(void)headerViewDidToFullText:(WARDiaryDetailHeaderView *)headerView ;
/** 点赞 */

-(void)headerView:(WARDiaryDetailHeaderView *)headerView didLink:(WARFeedComponentContent *)linkContent;
-(void)headerView:(WARDiaryDetailHeaderView *)headerView didGameLink:(WARFeedComponentContent *)linkContent;

-(void)headerView:(WARDiaryDetailHeaderView *)headerView didUser:(NSString *)accountId;

-(void)headerViewDidAllPraise:(WARDiaryDetailHeaderView *)headerView ;

@end

@interface WARDiaryDetailHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       moment:(WARMoment *)moment
                         type:(NSString *)type;

- (void)configMoment:(WARMoment *)moment; 

/** delegate */
@property (nonatomic, weak) id<WARDiaryDetailHeaderViewDelegate> delegate; 

@property (nonatomic, strong) WARCMessageModel *message;

@end

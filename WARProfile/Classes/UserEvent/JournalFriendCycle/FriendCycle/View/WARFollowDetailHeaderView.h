//
//  WARFollowDetailHeaderView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/8.
//

#import <UIKit/UIKit.h>

@class WARCMessageModel,WARMoment,WARFollowDetailHeaderView,WARFeedComponentContent,WARDBContactModel,WARFeedImageComponent,WARFeedLinkComponent,WARFeedGame;

@protocol WARFollowDetailHeaderViewDelegate <NSObject>

@optional

-(void)headerView:(WARFollowDetailHeaderView *)headerView didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView;

-(void)headerView:(WARFollowDetailHeaderView *)headerView showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index;

-(void)headerViewShowPop:(WARFollowDetailHeaderView *)headerView showFrame:(CGRect)frame;

-(void)headerViewDidUserHeader:(WARFollowDetailHeaderView *)headerView model:(WARDBContactModel *)model;

-(void)headerViewDidNoInterest:(WARFollowDetailHeaderView *)headerView ;

-(void)headerViewDidToFullText:(WARFollowDetailHeaderView *)headerView ;

/** 点赞 */

-(void)headerView:(WARFollowDetailHeaderView *)headerView didLink:(WARFeedLinkComponent *)linkContent;
-(void)headerView:(WARFollowDetailHeaderView *)headerView didGameLink:(WARFeedLinkComponent *)didGameLink;
-(void)headerViewDidAllRank:(WARFollowDetailHeaderView *)headerView game:(WARFeedGame *)game;

-(void)headerView:(WARFollowDetailHeaderView *)headerView didUser:(NSString *)accountId;

-(void)headerViewDidAllPraise:(WARFollowDetailHeaderView *)headerView ;

-(void)headerViewReloadData ;
@end

@interface WARFollowDetailHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       moment:(WARMoment *)moment
                         type:(NSString *)type;

- (void)configMoment:(WARMoment *)moment; 

/** delegate */
@property (nonatomic, weak) id<WARFollowDetailHeaderViewDelegate> delegate; 
/** bottomLine */
@property (nonatomic, strong) UIView *bottomLine; 

@property (nonatomic, strong) WARCMessageModel *message;

@end

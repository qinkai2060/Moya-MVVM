//
//  WARJournalBottomView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <UIKit/UIKit.h>
@class WARMoment,WARMineExplorationBottomView;

@protocol WARMineExplorationBottomViewDelegate <NSObject> 
-(void)mineExpBottomViewDidPriase:(WARMineExplorationBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)mineExpBottomViewDidComment:(WARMineExplorationBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
@end

@interface WARMineExplorationBottomView : UIView

@property (nonatomic, weak) id<WARMineExplorationBottomViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) WARMoment *moment;

@end

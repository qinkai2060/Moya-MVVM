//
//  WARUserDiaryBaseCellBottomView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import <UIKit/UIKit.h>
@class WARNewUserDiaryMoment,WARUserDiaryBaseCellBottomView;

@protocol WARUserDiaryBaseCellBottomViewDelegate <NSObject>
-(void)userDiaryBaseCellBottomViewShowPop:(WARUserDiaryBaseCellBottomView *)bottomView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame;
-(void)userDiaryBaseCellBottomViewDidPriase:(WARUserDiaryBaseCellBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
-(void)userDiaryBaseCellBottomViewDidComment:(WARUserDiaryBaseCellBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath;
@end

@interface WARUserDiaryBaseCellBottomView : UIView
/** delegate */
@property (nonatomic, weak) id<WARUserDiaryBaseCellBottomViewDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) WARNewUserDiaryMoment *moment;

@end

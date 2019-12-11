//
//  WARUserDiaryBaseCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

/**
 <#Description#>
 - <#value1#>: <#Description#>
 */
typedef NS_ENUM(NSUInteger, WARUserDiaryBaseCellActionType) {
    
    WARUserDiaryBaseCellActionTypeDidTopPop = 1,
    WARUserDiaryBaseCellActionTypeDidBottomPop = 2,
    WARUserDiaryBaseCellActionTypeDidPageContent = 3,
    WARUserDiaryBaseCellActionTypeScrollHorizontalPage = 4,
    WARUserDiaryBaseCellActionTypeFinishScrollHorizontalPage = 5,
    
    WARUserDiaryBaseCellActionTypeDidImage = 10
    
};

#import <UIKit/UIKit.h>

@class WARUserDiaryBaseCellTopView,WARUserDiaryBaseCellBottomView,WARNewUserDiaryMoment,WARUserDiaryBaseCell,WARFeedImageComponent,WARFeedComponentContent;

@protocol WARUserDiaryBaseCellDelegate <NSObject>
-(void)userDiaryBaseCell:(WARUserDiaryBaseCell *)userDiaryBaseCell actionType:(WARUserDiaryBaseCellActionType)actionType value:(id)value;
-(void)userDiaryBaseCell:(WARUserDiaryBaseCell *)userDiaryBaseCell didImageIndex:(NSInteger) index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents;
-(void)userDiaryBaseCellShowPop:(WARUserDiaryBaseCell *)userDiaryBaseCell actionType:(WARUserDiaryBaseCellActionType)actionType indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame;
-(void)userDiaryBaseCell:(WARUserDiaryBaseCell *)userDiaryBaseCell didLink:(WARFeedComponentContent *)linkContent;

-(void)userDiaryBaseCellDidPriase:(WARUserDiaryBaseCell *)userDiaryBaseCell  indexPath:(NSIndexPath *)indexPath;
-(void)userDiaryBaseCellDidComment:(WARUserDiaryBaseCell *)userDiaryBaseCell  indexPath:(NSIndexPath *)indexPath;

@end

@interface WARUserDiaryBaseCell : UITableViewCell

@property (nonatomic, weak) id<WARUserDiaryBaseCellDelegate> delegate;

@property (nonatomic, strong) WARNewUserDiaryMoment *moment;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) WARUserDiaryBaseCellTopView *topView;
@property (nonatomic, strong) WARUserDiaryBaseCellBottomView *bottomView;

- (void)setUpUI;

/** 辅助字段，分类(WARUserDiaryBaseCell+WebCache)要用 */
@property (nonatomic, strong) NSString *momentId;

@end

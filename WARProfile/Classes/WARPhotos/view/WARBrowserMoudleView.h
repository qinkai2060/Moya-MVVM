//
//  WARBrowserMoudleView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import <UIKit/UIKit.h>
#import "WARPhotoHeaderView.h"
@class WARBrowserMoudleView;
@class WARGroupModel;
@class WARDetailModel;
@class WARPictureModel;
@class WARPhotoDetailCollectionCell;
typedef void(^openClicKPicker)();
@protocol WARBrowserMoudleViewDelegate <NSObject>
- (void)WARBrowserMoudleView:(WARBrowserMoudleView*)detailV alpha:(CGFloat)alpha;
- (void)browserMoudleView:(WARBrowserMoudleView*)detailV atMondel:(WARPictureModel *)model atCell:( WARPhotoDetailCollectionCell*)cell atPictureArray:(NSArray*)pictureArray;
@end
@interface WARBrowserMoudleView : UIView
@property(nonatomic,weak)id<WARBrowserMoudleViewDelegate> delegate;
@property(nonatomic,strong)WARDetailModel  *detailmodel;
@property(nonatomic,copy)openClicKPicker pickerBlock;
@property(nonatomic,strong)WARPhotoHeaderView *headerView;
@property(nonatomic,copy)NSMutableArray *cellArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)WARGroupModel *groupPModel;
@property(nonatomic,strong)NSString *accountID;
- (instancetype)initWithFrame:(CGRect)frame atAcountID:(NSString*)accountId;
- (void)setGroupModel:(WARGroupModel*)model;
@end

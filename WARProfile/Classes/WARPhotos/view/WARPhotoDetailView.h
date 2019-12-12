//
//  WARPhotoDetailView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import <UIKit/UIKit.h>
@class WARPhotoDetailView;
@class WARGroupModel;
@class WARDetailModel;
@class WARPictureModel;
@class WARPhotoDetailCollectionCell;
#import "WARPhotoHeaderView.h"
typedef NS_ENUM(NSInteger, WARPhotoDetailViewType) {
    WARPhotoDetailViewTypeDefualt,
    WARPhotoDetailViewTypeCustom,
    WARPhotoDetailViewTypeManger,
     WARPhotoDetailViewTypeCover
    
};

typedef void(^openClicKPicker)();
@protocol WARPhotoDetailViewDelegate<NSObject>
- (void)WARPhotoDetailView:(WARPhotoDetailView*)detailV alpha:(CGFloat)alpha;
- (void)WARPhotoDetailView:(WARPhotoDetailView*)detailV atMondel:(WARPictureModel *)model atCell:( WARPhotoDetailCollectionCell*)cell atPictureArray:(NSArray*)pictureArray;
@end
@interface WARPhotoDetailView : UIView
@property(nonatomic,weak)id<WARPhotoDetailViewDelegate> delegate;
@property(nonatomic,strong)WARDetailModel  *detailmodel;
@property(nonatomic,copy)openClicKPicker pickerBlock;
@property(nonatomic,strong)WARPhotoHeaderView *headerView;
@property(nonatomic,copy)NSMutableArray *cellArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *accountId;
@property(nonatomic,strong)WARGroupModel *groupMModel;
@property(nonatomic,assign)BOOL isEndDecelerating;
- (void)setGroupModel:(WARGroupModel*)model;

- (instancetype)initWithFrame:(CGRect)frame type:(WARPhotoDetailViewType)type atAccounId:(NSString *)accoutId atModel:(WARGroupModel*)model;
@end

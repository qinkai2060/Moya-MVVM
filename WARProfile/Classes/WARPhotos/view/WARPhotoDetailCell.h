//
//  WARPhotoDetailCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/21.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"
#import "WARPhotoDetailView.h"
@class WARDetailDateDataModel;
@class WARPhotoDetailCell;
@class WARPhotoDetailCollectionCell;

@protocol WARPhotoDetailCellDelegate <NSObject>
- (void)PhotoDetailCell:(WARPhotoDetailCell*)cell;
- (void)photoDetailCell:(WARPhotoDetailCell*)cell atMondel:(WARDetailDateDataModel*)model atIndextPath:(NSIndexPath*)indexPath atCell:(WARPhotoDetailCollectionCell*)cell atPictureArr:(NSArray*)pictureArray;
@end
@interface WARPhotoDetailCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
@property(nonatomic,strong)UILabel *locationLb;
@property(nonatomic,strong)UIButton *allSelectBtn;
@property(nonatomic,assign)WARPhotoDetailViewType type;
@property(nonatomic,strong)WARDetailDateDataModel *model;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,strong)NSMutableArray *selectCellArray;
@property(nonatomic,weak) id<WARPhotoDetailCellDelegate> delegate;
@property(nonatomic,strong) NSString *accountId;
- (void)setCSSStyle:(WARPhotoDetailViewType)type;
@end

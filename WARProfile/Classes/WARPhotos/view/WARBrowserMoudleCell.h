//
//  WARBrowserMoudleCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import <UIKit/UIKit.h>
#import "WARPhotoListLayout.h"
#import "WARGroupModel.h"
@class WARBrowserMoudleCell;
@class WARDetailDateDataModel;
@class WARBrowserMoudleCollectionCell;
@protocol WARBrowserMoudleCellDelegate <NSObject>
- (void)photoBrowserMoudleCell:(WARBrowserMoudleCell*)cell atMondel:(WARDetailDateDataModel*)model atIndextPath:(NSIndexPath*)indexPath atCell:(WARBrowserMoudleCollectionCell*)cell atPictureArr:(NSArray*)pictureArray;
-(void)uodataTableViewCellHight:(WARBrowserMoudleCell*)cell andHight:(CGFloat)hight andIndexPath:(NSIndexPath *)indexPath;
@end


@class WARDetailDateDataModel;
@interface WARBrowserMoudleCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource, WARPhotoListLayoutDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *locationLb;
@property(nonatomic,strong)WARGroupModel *groupModel;
@property(nonatomic,strong)WARDetailDateDataModel *model;
@property(nonatomic,weak)id <WARBrowserMoudleCellDelegate> delegate;
@property(nonatomic,assign)CGFloat hightED;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSString *accountId;
@end

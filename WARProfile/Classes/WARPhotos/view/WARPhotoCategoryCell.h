//
//  WARPhotoCategoryCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import <UIKit/UIKit.h>
#import "WARPhotoListModel.h"

#import "WARPhotoVideoListModel.h"
typedef NS_ENUM(NSInteger,WARPhotoCategoryCellType) {
    WARPhotoCategoryCellTypeVideo,
    WARPhotoCategoryCellTypePhoto,
};
@interface WARPhotoCategoryCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)WARPhotoVideoModel *videoModel;
@property(nonatomic,strong)WARPhotoPictureModel *photoModel;
@property(nonatomic,assign)WARPhotoCategoryCellType type;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier atType:(WARPhotoCategoryCellType)type;
@end

//
//  WARPhotoVideoAndPhotoImgView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/24.
//

#import <UIKit/UIKit.h>
#import "WARPhotoListModel.h"
#import "WARPhotoVideoListModel.h"
#
typedef NS_ENUM(NSInteger,WARPhotoVideoAndPhotoImgViewType) {
    WARPhotoVideoAndPhotoImgViewTypeVideo,
    WARPhotoVideoAndPhotoImgViewTypePhoto,

    
};

@interface WARPhotoVideoAndPhotoImgView : UIView
/**tbview*/
//@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) WARPhotoListModel *photoModel;
@property (nonatomic,strong) WARPhotoVideoListModel *videoModel;
@property (nonatomic,assign) WARPhotoVideoAndPhotoImgViewType type;
- (instancetype)initWithFrame:(CGRect)frame atType:(WARPhotoVideoAndPhotoImgViewType)type;
@end

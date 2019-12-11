//
//  WARPhotoViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import <UIKit/UIKit.h>
#import "WARUSerCenterProfileCell.h"
#import "TZAssetModel.h"
@class WARGroupModel;

typedef void (^WARPhotohblock)(NSIndexPath *indexpath,WARGroupModel *model);
typedef void (^WARPhotoSorthblock)(NSMutableArray *dataArr);
typedef void (^WARPhotoTempBrowserblock)(NSArray *dataArr,NSInteger index);

@interface WARPhotoViewController : UIViewController
@property (assign, nonatomic) BOOL canScroll;
@property (nonatomic,copy)WARPhotohblock block;
@property (nonatomic,copy)WARPhotoSorthblock sortBlock;
@property (nonatomic,copy)WARPhotoTempBrowserblock tempBrowserBlock;
@property(nonatomic,assign)BOOL isRefreshing;
@property(nonatomic,assign)BOOL isMine;
@property(nonatomic,assign)CGPoint cellpoint;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataphotoGroupArray;
- (void)pareData:(NSArray *)dataArr;
- (void)coverpoin:(WARUSerCenterProfileCell*)cell drapPoint:(CGPoint)point photos:(TZAssetModel*)imagemodel;
- (void)coverpoinChange:(WARUSerCenterProfileCell *)cell drapPoint:(CGPoint)point photos:(TZAssetModel*)imagemodel;
- (void)outOfRang;
- (instancetype)initWithType:(BOOL)isMine atGuyID:(NSString*)guyID;
@end



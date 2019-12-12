//
//  WARBrowserMoudleCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/25.
//

#import "WARBrowserMoudleCell.h"
#import "WARPhotoDetailsViewController.h"
#import "WARPhotoBroswerViewController.h"
#import "WARPhotoDetailCollectionCell.h"
#import "WARBaseMacros.h"
#import "WARMacros.h"
#import "WARConfigurationMacros.h";
#import "UIImage+WARBundleImage.h"
#import "WARUIHelper.h"
#import "UIImageView+WebCache.h"
#import "WARPhotoBroswerViewController.h"
#import "WARGroupModel.h"
#import "Masonry.h"
#import "WARPhotoGroupMangerViewController.h"
#import "WARBrowserMoudleCollectionCell.h"
@implementation WARBrowserMoudleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.locationLb];
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.locationLb.mas_bottom);
            make.left.bottom.right.equalTo(self.contentView);
            
        }];
    }
    return self;
}
- (void)setModel:(WARDetailDateDataModel *)model{
    _model = model;
    self.locationLb.text = model.address.length==0?WARLocalizedString(@"未知"):WARLocalizedString(model.address);

    [self.collectionView reloadData];
}
- (CGFloat)waterfallLayout:(WARPhotoListLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    WARPictureModel *model = self.model.arrPictures[indexPath.row];
    
    return model.height / model.width * itemWidth;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.model.arrPictures.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
      [self updateCollectionViewHight:self.collectionView.collectionViewLayout.collectionViewContentSize.height];

    WARPictureModel *model = self.model.arrPictures[indexPath.item];
    
    WARBrowserMoudleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photodetails" forIndexPath:indexPath];
    
    cell.model = model;
    [self setlayerShadow:cell withWARPictureModel:model];
    return cell;
}
- (void)setlayerShadow:(UIView*)v withWARPictureModel:(WARPictureModel*)model{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, model.getwidth, model.getHeight)];
    
    v.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;//阴影颜色
    v.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
    v.layer.shadowOpacity = 0.5;//不透明度
    v.layer.shadowRadius = 2;//半径

    v.layer.shadowPath = shadowPath.CGPath;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        WARPictureModel *model = self.model.arrPictures[indexPath.item];
        WARPhotoDetailsViewController *detailVC = [self currentVC:self];
    
    WARPhotoBroswerViewController *goVC = [[WARPhotoBroswerViewController alloc] initWithModel:self.groupModel currentimgev:collectionView currentindex:indexPath.item pictureDescrtionModel:model atImagePictureArray:self.model.arrPictures atSuperView:nil atAccountID:self.accountId];
    [detailVC.navigationController pushViewController:goVC animated:YES];
}
-(void)updateCollectionViewHight:(CGFloat)hight{
    
    
    if (self.hightED != hight) { 
        self.hightED = hight;
        

        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(hight);
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(uodataTableViewCellHight:andHight:andIndexPath:)]) {
            [self.delegate uodataTableViewCellHight:self andHight:hight andIndexPath:self.indexPath];
        }
    }
}
- (UIViewController *)currentVC:(UIView*)v {
    id object = [v nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        
        object = [object nextResponder];
    }
    UIViewController* uc = (UIViewController*)object;
    return uc;
}

- (UILabel *)locationLb{
    if (!_locationLb) {
        _locationLb = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, kScreenWidth-11-70, 21)];
        _locationLb.font = kFont(15);
        _locationLb.text = @"法国-巴黎";
        _locationLb.textColor = DisabledTextColor;
    }
    return _locationLb;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        WARPhotoListLayout *flowLayout = [[WARPhotoListLayout alloc] init];
        flowLayout.delegate = self;
        [flowLayout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[WARBrowserMoudleCollectionCell class] forCellWithReuseIdentifier:@"photodetails"];
        
    }
    return _collectionView;
}
@end

//
//  WARNewUserDiaryTableHeaderPhotoView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import "WARNewUserDiaryTableHeaderPhotoView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "Masonry.h"
#import "WARUIHelper.h"

#define kWARNewUserDiaryTableHeaderPhotoViewCellId @"kWARNewUserDiaryTableHeaderPhotoViewCellId"

@interface WARNewUserDiaryTableHeaderPhotoView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *editButton;

@end

@implementation WARNewUserDiaryTableHeaderPhotoView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLable];
    [self addSubview:self.editButton];
    [self addSubview:self.collectionView];
}

#pragma mark - Event Response

- (void)edtiAction:(UIButton *)button {
}

#pragma mark - Delegate

#pragma mark - collection view delegate & data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARNewUserDiaryTableHeaderPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARNewUserDiaryTableHeaderPhotoViewCellId forIndexPath:indexPath];
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - Public

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat collectionViewW = kScreenWidth - 2 * AdaptedWidth(13);
        CGFloat itemW = (collectionViewW - 3 * 3) / 4;
        CGFloat collectionViewH = 2 * itemW + 3; 
        CGRect frame = CGRectMake(AdaptedWidth(13), 26, collectionViewW, collectionViewH);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize =CGSizeMake(itemW, itemW);
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 3;
//        layout.sectionInset = UIEdgeInsetsMake(0, AdaptedWidth(20), 0, AdaptedWidth(20));
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WARNewUserDiaryTableHeaderPhotoViewCell class] forCellWithReuseIdentifier:kWARNewUserDiaryTableHeaderPhotoViewCellId];
        _collectionView.backgroundColor = kColor(whiteColor);
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.frame = CGRectMake(AdaptedWidth(13), 0, 120, 14);
        _titleLable.text = @"记录的图片";
        _titleLable.font = [UIFont systemFontOfSize:14];
        _titleLable.textColor = HEXCOLOR(0x343C4F);
    }
    return _titleLable;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(kScreenWidth - AdaptedWidth(13) - 60, 0, 60, 14);
        _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_editButton setTitleColor:HEXCOLOR(0x386DB4) forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(edtiAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    return _editButton;
}

@end

#pragma mark - WARNewUserDiaryTableHeaderPhotoViewCell

@interface WARNewUserDiaryTableHeaderPhotoViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation  WARNewUserDiaryTableHeaderPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.bottom.right.mas_equalTo(self);
    }];
    
    
    self.imageView.image = [WARUIHelper war_defaultUserIcon];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end


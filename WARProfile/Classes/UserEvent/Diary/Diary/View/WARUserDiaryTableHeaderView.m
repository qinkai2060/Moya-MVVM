//
//  WARUserDiaryTableHeaderView.m
//  WARProfile
//
//  Created by HermioneHu on 2018/1/24.
//

#import "WARUserDiaryTableHeaderView.h"


#import "WARMacros.h"
#import "Masonry.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"

#import "WARDiaryWeatherCollectionViewCell.h"

#define kWARProfileBundle @"WARProfile.bundle"

#define kWARDiaryWeatherCollectionViewCellId @"kWARDiaryWeatherCollectionViewCellId"

#define kCollectionVHeight 100

#define kSmallIconSize CGSizeMake(15, 15)

@interface WARUserDiaryTableHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIView *containerV;

@property (nonatomic, copy)NSArray *dataArr;

@property (nonatomic, strong) UIView *todayContainerV;
@property (nonatomic, strong) UILabel *todayLab;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *inputPhotosBtn;
@property (nonatomic, strong) UIButton *sketchsBtn; // 草稿
//
//@property (nonatomic, assign) BOOL  isClickInput;
@end
@implementation WARUserDiaryTableHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(clearColor);
        [self addSubview:self.containerV];
        [self addSubview:self.todayContainerV];
        
        [self.containerV addSubview:self.collectionView];
        
        [self.todayContainerV addSubview:self.todayLab];
        [self.todayContainerV addSubview:self.textLab];
        [self.todayContainerV addSubview:self.addBtn];
        [self.todayContainerV addSubview:self.sketchsBtn];
        [self.todayContainerV addSubview:self.inputPhotosBtn];
        
        [self.containerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.width.mas_equalTo(self);
        }];
        
        [self.todayContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerV.mas_bottom);
            make.left.right.width.equalTo(self);
            make.bottom.mas_equalTo(0);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.containerV);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kCollectionVHeight));
        }];
        
        
        

        
        UIView *lineV = [[UIView alloc]init];
        lineV.backgroundColor = RGBA(0,216,183,0.3);
        [self.todayContainerV addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(30);
            make.size.mas_equalTo(CGSizeMake(2, 15));
        }];
        
        [self.todayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.equalTo(lineV.mas_bottom).offset(15);
            make.bottom.mas_equalTo(-15);
        }];
        
        [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.todayLab.mas_right).offset(13);
            make.centerY.equalTo(self.todayLab);
        }];
        
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.equalTo(self.textLab.mas_right).offset(17);
            make.centerY.equalTo(self.textLab);
        }];
        [self.sketchsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.equalTo(self.addBtn.mas_right).offset(17);
            make.centerY.equalTo(self.textLab);
        }];
        [self.inputPhotosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(kSmallIconSize);
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.addBtn);
        }];
        
    }
    return self;
}


- (void)setIsShowInputPhotoBtn:(BOOL)isShowInputPhotoBtn{
    _isShowInputPhotoBtn = isShowInputPhotoBtn;
    self.inputPhotosBtn.hidden = isShowInputPhotoBtn?NO:YES;
}



#pragma mark - collection view delegate & data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.weathers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WARDiaryWeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWARDiaryWeatherCollectionViewCellId forIndexPath:indexPath];
    //[cell configureWeather:self.weathers[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.isScrollIng = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

     self.isScrollIng = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.isScrollIng = NO;
}
- (void)addForTodayAction:(UIButton *)button{
    if (self.didClickReleaseNewDiaryBlock) {
        self.didClickReleaseNewDiaryBlock();
    }
}

- (void)inputPhotosBtnAction:(UIButton *)button{
    if (self.didClickInputPhotosBlock) {
        self.inputPhotosBtn.hidden = YES;
        self.didClickInputPhotosBlock();
    }
}


#pragma mark - getter methods

- (UIView *)containerV{
    if (!_containerV) {
        _containerV = [[UIView alloc]init];
        _containerV.backgroundColor = kColor(clearColor);
    }
    return _containerV;
}

- (UIView *)todayContainerV{
    if (!_todayContainerV) {
        _todayContainerV = [[UIView alloc]init];
    }
    return _todayContainerV;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize =CGSizeMake(70, 70);
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[WARDiaryWeatherCollectionViewCell class] forCellWithReuseIdentifier:kWARDiaryWeatherCollectionViewCellId];
        _collectionView.backgroundColor = kColor(clearColor);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.tag = -1000;
    }
    return _collectionView;
}

- (UILabel *)todayLab{
    if (!_todayLab) {
        _todayLab = [[UILabel alloc]init];
        _todayLab.font = kFont(18);
        _todayLab.textColor = RGB(153, 153, 153);
        _todayLab.text = WARLocalizedString(@"今天");
    }
    return _todayLab;
}

- (UILabel *)textLab{
    if (!_textLab) {
        _textLab = [[UILabel alloc]init];
        _textLab.font = kFont(12);
        _textLab.textColor = RGB(153, 153, 153);
        _textLab.text = WARLocalizedString(@"记录今天的生活");
    }
    return _textLab;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage war_imageName:@"personal_release" curClass:self curBundle:kWARProfileBundle] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addForTodayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)sketchsBtn{
    if (!_sketchsBtn) {
        _sketchsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sketchsBtn setImage:[UIImage war_imageName:@"personal_preservation" curClass:self curBundle:kWARProfileBundle] forState:UIControlStateNormal];
//        [_sketchsBtn addTarget:self action:@selector(addForTodayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sketchsBtn;
}

- (UIButton *)inputPhotosBtn{
    if (!_inputPhotosBtn) {
        _inputPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inputPhotosBtn setImage:[UIImage war_imageName:@"personal_import" curClass:self curBundle:kWARProfileBundle] forState:UIControlStateNormal];
        [_inputPhotosBtn addTarget:self action:@selector(inputPhotosBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputPhotosBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

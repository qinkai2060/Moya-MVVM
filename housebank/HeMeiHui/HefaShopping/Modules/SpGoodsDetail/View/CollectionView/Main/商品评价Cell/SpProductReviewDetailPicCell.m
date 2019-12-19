//
//  SpProductReviewDetailPicCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpProductReviewDetailPicCell.h"

// Categories

// Others

@interface SpProductReviewDetailPicCell ()

/* 昵称 */
@property (strong , nonatomic)UILabel *nickName;
/* 图片数量 */
@property (strong , nonatomic)UILabel *picNum;

/* imageArray */
@property (copy , nonatomic)NSArray *imagesArray;

@end

@implementation SpProductReviewDetailPicCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _pciImageView = [[UIImageView alloc] init];
    _pciImageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    [_pciImageView addGestureRecognizer:tap];
    _pciImageView.image=[UIImage imageNamed:@"icon_image"];
    [self addSubview:_pciImageView];
    
//    _nickName = [[UILabel alloc] init];
//    _nickName.font = PFR11Font;
//    [self addSubview:_nickName];
//
//    _picNum = [[UILabel alloc] init];
//    _picNum.textColor = [UIColor whiteColor];
//    _picNum.backgroundColor = RGB(60, 53, 44);
//    _picNum.textAlignment = NSTextAlignmentCenter;
//    _picNum.font = PFR10Font;
//    [self addSubview:_picNum];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_pciImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
//    [_picNum mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_pciImageView);
//        make.bottom.mas_equalTo(_pciImageView);
//        make.size.mas_equalTo(CGSizeMake(30, 18));
//    }];
//
//    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
//        [make.top.mas_equalTo(_pciImageView.mas_bottom)setOffset:2];
//        make.left.mas_equalTo(_pciImageView);
//    }];
}
-(void)reSetVDataValue:(CommentPictureListItem*)productInfo
{
    NSString *str=@"";
    if (productInfo.picPath.length > 0) {
        NSString *str3 = [productInfo.picPath substringToIndex:1];
        if ([str3 isEqualToString:@"/"]) {
            ManagerTools *manageTools =  [ManagerTools ManagerTools];
            if (manageTools.appInfoModel) {
                if ([productInfo.picPath containsString:@"!"]) {
                    str = [NSString stringWithFormat:@"%@%@",manageTools.appInfoModel.imageServerUrl,productInfo.picPath];
                } else {
                    str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,productInfo.picPath,@"!SQ250"];
                }
//                str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,productInfo.picPath,@"!SQ250"];
                //                            [self.iimageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
            }
        }else
        {
            str = [NSString stringWithFormat:@"%@%@",productInfo.picPath,@"!SQ250"];
        }
    }
      [_pciImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];

}
#pragma mark - 图片点击
- (void)tapImageView
{
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.currentImageIndex = 0;
//    browser.sourceImagesContainerView = self;
//    browser.isCascadingShow = YES; //层叠
//    browser.imageCount = _imagesArray.count;
//    browser.delegate = self;
//    [browser show];
}

//#pragma mark - SDPhotoBrowserDelegate
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
//{
//    NSURL *url = [NSURL new];
//    if (index < _imagesArray.count) {
//        url = [NSURL URLWithString:_imagesArray[index]];
//    }
//    return url;
//}
//
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
//{
//    return _pciImageView.image;
//}


@end

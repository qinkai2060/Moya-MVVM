//
//  SpProductReviewDetailCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//

//200
#import "SpProductReviewDetailCell.h"
#import "SpProductReviewDetailPicCell.h"
#import <MJExtension.h>
#import "CLPictureAmplifyViewController.h"
#import "CLPresent.h"
// Categories

// Others

@interface SpProductReviewDetailCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZPMyStarShowDelegate>

/* collectionView */
@property (strong , nonatomic)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *selectImageTap;
/* 图片数组 */
//@property (strong , nonatomic)NSMutableArray<DCCommentPicItem *> *picItem;
@end

static NSString *const SpProductReviewDetailPicCellID = @"SpProductReviewDetailPicCell";
//static const CGFloat kItemSpacing = 10;   //item之间的间距  --
//static const CGFloat kLineSpacing = 5.f;   //列间距 |
@implementation SpProductReviewDetailCell

#pragma mark - LoadLazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //注册
        [_collectionView registerClass:[SpProductReviewDetailPicCell class] forCellWithReuseIdentifier:SpProductReviewDetailPicCellID];
        [self addSubview:_collectionView];
    }
    return _collectionView;
    
}

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
    self.collectionView.backgroundColor = self.backgroundColor;
//    DCUserInfo *userInfo = UserInfoData;
    _iconImageView = [[UIImageView alloc] init];
    UIImage *image = (![[NSString stringWithFormat:@"isLogin"] isEqualToString:@"1"]) ? [[UIImage imageNamed:@"商品评论-头像"] dc_circleImage] : [[DCSpeedy Base64StrToUIImage:@"待数据填充"] dc_circleImage];
    _iconImageView.image = image;
    
    [self addSubview:_iconImageView];
    
     _starView=[[ZPMyStarShow alloc]init];
    _starView.bounds=CGRectMake(0, 0, 70, 10);
    _starView.centerY=_iconImageView.centerY;
    _starView.centerX=self.width-15-_starView.width;
    _starView.frame=CGRectMake(self.width-_starView.width-15, 20, 70, 10);
    _starView.starRating=5;
    _starView.isIndicator=YES;
    [_starView setImageDeselected:@"Shape" halfSelected:@"Shape1" fullSelected:@"Shape1" andDelegate:self];
    [_starView setStarRating:4.f];
     [self  addSubview:_starView];

    
//    [self ratingBar:_starView ratingChanged:4.f];
//    星星评级
//    GRStarsView *starsView = [[GRStarsView alloc] initWithStarSize:CGSizeMake(10, 10) margin:10 numberOfStars:5];
//    starsView.frame = CGRectMake(200, 20, starsView.frame.size.width, starsView.frame.size.height);
//    starsView.allowSelect = YES;  // 默认可点击
//    starsView.allowDecimal = YES;  //默认可显示小数
//    starsView.allowDragSelect = NO;//默认不可拖动评分，可拖动下需可点击才有效
//    starsView.score = 4.5;
//    starsView.touchedActionBlock = ^(CGFloat score) {
//        NSString *str = [NSString stringWithFormat:@" 分数: %.1f", score];
//    };
//    [self addSubview:starsView];
    
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.font = PFR15Font;
    NSString *nickName = (![[NSString stringWithFormat:@"isLogin"] isEqualToString:@"1"]) ? @"孙梦北" : @"待数据录入";
    _nickNameLabel.textColor=HEXCOLOR(0x333333);
    _nickNameLabel.text = [DCSpeedy dc_encryptionDisplayMessageWith:nickName WithFirstIndex:2];
    [self addSubview:_nickNameLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = PFR14Font;
    _contentLabel.textColor=HEXCOLOR(0x333333);
    _contentLabel.text = @"包装完美,物流快,物超所值,很愉快的一次购物";
    [self addSubview:_contentLabel];
    
    
    
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor lightGrayColor];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YY-MM-dd";
    NSString *currentDateStr = [fmt stringFromDate:[NSDate date]];
    _timeLabel.text = currentDateStr;
    _timeLabel.font = PFR12Font;
    _timeLabel.textColor=HEXCOLOR(0x999999);
    [self addSubview:_timeLabel];
    
    _showTypeLable = [[UILabel alloc] init];
    _showTypeLable.font = PFR12Font;
    _showTypeLable.textColor=HEXCOLOR(0x999999);
    _showTypeLable.text = @"颜色分类：橘红";
    [self addSubview:_showTypeLable];
 
   
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:10];
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_iconImageView.mas_right)setOffset:10];
        make.centerY.mas_equalTo(_iconImageView);
    }];
    

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImageView);
        [make.right.mas_equalTo(self.mas_right)setOffset:-DCMargin];
        [make.top.mas_equalTo(_iconImageView.mas_bottom)setOffset:10];
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_contentLabel.mas_bottom)setOffset:10];
        [make.left.mas_equalTo(self.mas_left)setOffset:DCMargin];
        [make.right.mas_equalTo(self.right)setOffset:-DCMargin];
        make.height.mas_equalTo(110);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(_iconImageView);
        [make.bottom.mas_equalTo(self.mas_bottom)setOffset:-10];
    }];
    
    [_showTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_timeLabel.mas_right)setOffset:10];
       [make.bottom.mas_equalTo(self.mas_bottom)setOffset:-10];
    }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.commentItem.commentPictureList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SpProductReviewDetailPicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SpProductReviewDetailPicCellID forIndexPath:indexPath];
    CommentPictureListItem *picItem=[self.commentItem.commentPictureList objectAtIndex:indexPath.row];
    [cell reSetVDataValue: picItem];
    return cell;
}


#pragma mark - <UICollectionViewDelegate>
#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(110, 110);

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *picUrlArray=[[NSMutableArray alloc]init];
    for (CommentPictureListItem *ListItem in self.commentItem.commentPictureList) {
        NSString *str=@"";
        if (ListItem.picPath.length > 0) {
            NSString *str3 = [ListItem.picPath substringToIndex:1];
            if ([str3 isEqualToString:@"/"]) {
                ManagerTools *manageTools =  [ManagerTools ManagerTools];
                if (manageTools.appInfoModel) {
                    if ([ListItem.picPath containsString:@"!"]) {
                        str = [NSString stringWithFormat:@"%@%@",manageTools.appInfoModel.imageServerUrl,ListItem.picPath];
                    } else {
                        str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,ListItem.picPath,@"!SQ250"];
                    }
//                    str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,ListItem.picPath,@"!SQ250"];
                    //                            [self.iimageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
                }
            }else
            {
                str = [NSString stringWithFormat:@"%@%@",ListItem.picPath,@"!SQ250"];
            }
        }
        [picUrlArray addObject:str];
    }
    NSArray *imgArr = picUrlArray;
    
    if (imgArr.count > indexPath.row) {
        self.selectImageTap = [NSMutableArray arrayWithCapacity:1];
        /*先从缓存中取图片  看有没有  如果没有 在根据url来转换data 获取到image
         如果有 则取出  存到数组中*/
        for (int i = 0; i < imgArr.count; i++) {
            [_selectImageTap addObject:[MyUtil getCacheImageWithImageUrl:imgArr[i]]];
        }
        
        if (_selectImageTap.count > 0) {
            CLPictureAmplifyViewController *pictureVC = [[CLPictureAmplifyViewController alloc] init];
            // 传入图片数组
            pictureVC.picArray = _selectImageTap;
            pictureVC.picUrlArray = imgArr;
            // 标记点击的是哪一张图片
            pictureVC.touchIndex = indexPath.row;
            //    pictureVC.hiddenTextLable = YES;  // 控制lable是否显示
            CLPresent *present = [CLPresent sharedCLPresent];
            pictureVC.modalPresentationStyle = UIModalPresentationCustom;
            pictureVC.transitioningDelegate = present;

              UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window.rootViewController presentViewController:pictureVC animated:YES completion:nil];
        }
    }
//     CommentPictureListItem *picItem=[self.commentItem.commentPictureList objectAtIndex:indexPath.row];
//     [[NSNotificationCenter defaultCenter]postNotificationName:SeaTheBigPicList object:nil userInfo:nil];
}
//赋值
-(void)reSetVDataValue:(ListItem*)productInfo
{
    self.commentItem=productInfo;
    NSString *str=@"";
    if (productInfo.icon.length > 0) {
        NSString *str3 = [productInfo.icon substringToIndex:1];
        if ([str3 isEqualToString:@"/"]) {
            ManagerTools *manageTools =  [ManagerTools ManagerTools];
            if (manageTools.appInfoModel) {
                str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,productInfo.icon,@"!SQ250"];
                //                            [self.iimageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
            }
        }else
        {
            str = [NSString stringWithFormat:@"%@%@",productInfo.icon,@"!SQ250"];
        }
    }
//    头像
     [_iconImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"Sp_goods_comment_defautIcon"]];
    _nickNameLabel.text=productInfo.commentUserName;
    _contentLabel.text=productInfo.commentContent;
  
    if (productInfo.integratedServiceScore) {
  
         [_starView setStarRating:productInfo.integratedServiceScore ];
    }
    NSString *timeDateStr = [NSString stringWithFormat:@"%@",productInfo.commentDatetime];
    NSString *timeAllStr=@"";
    if (timeDateStr.length > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[productInfo.commentDatetime doubleValue] / 1000];
        NSDate *deviceDate = [NSDate date];
        NSString *timeStr = [MyUtil getCompareTimeWithDate:date curDate:deviceDate];
        timeAllStr = timeStr;
    }
    _timeLabel.text=timeAllStr;
    if ([productInfo.specifications isEqualToString:@""]||productInfo.specifications==nil ) {
        _showTypeLable.text=@"";
    }else
    {
        _showTypeLable.text=[NSString stringWithFormat:@"颜色分类：%@",productInfo.specifications];
    }
   
}
//星级代理回调
- (void)ratingBar:(ZPMyStarShow *)ratingBar ratingChanged:(float)newRating{
    
}


@end

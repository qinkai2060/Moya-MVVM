//
//  SpProductCommentDetailTableViewCell.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpProductCommentDetailTableViewCell.h"
#import "ZPMyStarShow.h"
#import "SpCommentListImagesView.h"


//边距
#define Edge_width 10
//除了头像 剩下内容的宽度
#define Content_width (ScreenW - 2 * Edge_width)

@interface SpProductCommentDetailTableViewCell ()
/** 头像 */
@property (nonatomic,strong) UIImageView *iconImg;
/** 姓名 */
@property (nonatomic,strong) UILabel *nameLab;
/** 内容 */
@property (nonatomic,strong) UILabel *contentLab;
/** 时间 */
@property (nonatomic,strong) UILabel *timeLab;
/*评分*/
@property (strong , nonatomic)ZPMyStarShow *starView;
//中间内容部分(动态高度)
@property (nonatomic, strong) UIView *contentBgView;
// 图片view
@property (nonatomic, strong) UIView *cricleContent;

@end

@implementation SpProductCommentDetailTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //头像
    _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(Edge_width, 10, 40, 40)];
    _iconImg.layer.masksToBounds = YES;
    _iconImg.layer.cornerRadius = _iconImg.width / 2.0;
    [self addSubview:_iconImg];
    
    //姓名
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame)+10, _iconImg.frame.origin.y,self.frame.size.width - CGRectGetMaxX(_iconImg.frame) - 20 - 90, _iconImg.frame.size.height)];
    _nameLab.font = [UIFont systemFontOfSize:15.0f];
    _nameLab.textColor = RGBACOLOR(51, 51, 51, 1);
    [self addSubview:_nameLab];
    
    // 星级
    _starView=[[ZPMyStarShow alloc]init];
    _starView.frame=CGRectMake(ScreenW -70 - 15, 10 + _iconImg.frame.size.height / 2 - 5,70, 10);
    _starView.starRating=5;
    _starView.isIndicator=YES;
    [_starView setImageDeselected:@"Shape" halfSelected:@"Shape1" fullSelected:@"Shape1" andDelegate:self];
    [self  addSubview:_starView];
 
    
    //
    //中间内容部分(动态高度)
    _contentBgView = [[UIView alloc]initWithFrame:CGRectMake(Edge_width,CGRectGetMaxY(_iconImg.frame)+4,Content_width,50 + 20 + 10)];
    _contentBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentBgView];
    
    //内容b
    _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,_contentBgView.frame.size.width,40)];
    _contentLab.font = [UIFont systemFontOfSize:14.0f];
    _contentLab.numberOfLines = 0;
    _contentLab.backgroundColor = [UIColor whiteColor];
    _contentLab.textColor = RGBACOLOR(51, 51, 51, 1);
    [_contentBgView addSubview:_contentLab];
    
    _cricleContent = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_contentLab.frame),_contentBgView.frame.size.width,50)];
    [_contentBgView addSubview:_cricleContent];
    
    //时间 和 颜色
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(_iconImg.frame.origin.x,CGRectGetMaxY(_contentBgView.frame),ScreenW - _iconImg.frame.origin.x - 20,20)];
    _timeLab.font = [UIFont systemFontOfSize:12.0f];
    _timeLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self addSubview:_timeLab];
}

- (void)refreshDetailCellWithModel:(GetCommentListModel *)model{
    //头像 =======
    NSString *iconStr = model.icon;
    [_iconImg sd_setImageWithURL:[iconStr get_Image] placeholderImage:[UIImage imageNamed:@"Sp_goods_comment_defautIcon"]];
    
    //姓名 ======
    NSString *userNameStr;
    if ( model.commentUserName.length > 0) {
        userNameStr = model.commentUserName;
    } else {
        userNameStr = @"???";
    }
    _nameLab.text = userNameStr;
    
    //星级  ======
    [_starView setStarRating:[model.integratedServiceScore floatValue]];
    
    //时间 ======
    NSString *timeDateStr = [NSString stringWithFormat:@"%@",model.commentDatetime];
    NSString *timeAllStr;
    if (timeDateStr.length > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.commentDatetime doubleValue] / 1000];
        NSDate *deviceDate = [NSDate date];
        NSString *timeStr = [MyUtil getCompareTimeWithDate:date curDate:deviceDate];
        timeAllStr = timeStr;
    }
    if ([[MyUtil isNullToString:model.specifications] length] > 0) {
        NSString *cStr = [NSString stringWithFormat:@"颜色分类：%@",model.specifications];
        timeAllStr = [NSString stringWithFormat:@"%@   %@",timeAllStr,cStr];
    }
    
    _timeLab.text = timeAllStr;
    
#pragma mark --- 内容 和 图片 ----
    //内容
    NSString *contentStr;
    if (model.commentContent.length > 0) {
        contentStr = model.commentContent;
    } else {
        contentStr = @"此用户没有填写评价";
    }
    _contentLab.text = contentStr;
    
    //中间部分 (动态高度)
    _contentBgView.height = [[self class] getCommentContentHeightWithModel:model];
    
    for (UIView *v in _contentBgView.subviews) {
        [v removeFromSuperview];
    }
    [_contentBgView addSubview:_contentLab];
    
    CGFloat content_H = 0.0;
    if (contentStr.length > 0) {
        content_H = [MyUtil getHeightWithFontSize:14 with:Content_width text:contentStr];
        content_H = content_H +10;
    }
    _contentLab.height = content_H;
    
    // 需要传model  图片测试
    _cricleContent = [[SpCommentListImagesView alloc] initWithFrame:CGRectMake(0, content_H, Content_width, _contentBgView.height-content_H) withCircleInfo:model];
    __weak typeof(self) weakSelf = self;
    // 图片的点击事件
    [(SpCommentListImagesView *)_cricleContent setImageTap:^(NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(CommentListUserTapImageViewWithCellImageViewsIndex:)]) {
            [weakSelf.delegate CommentListUserTapImageViewWithCellImageViewsIndex:index];
        }
    }];
    [_contentBgView addSubview:_cricleContent];
    
    _timeLab.y = CGRectGetMaxY(_contentBgView.frame)+15;
}

//中间可变内容高度 (内容+图片)
+(CGFloat)getCommentContentHeightWithModel:(GetCommentListModel *)model{
    //内容高度
    CGFloat content_H=0.0;
    NSString *contentStr;
    if (model.commentContent.length > 0) {
        contentStr = model.commentContent;
    } else {
        contentStr = @"此用户没有填写评价";
    }
    
    if (contentStr.length > 0) {
        //
        if (!contentStr || contentStr.length == 0) {
            content_H = 0;
        }
        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(Content_width, MAXFLOAT)
                                                  options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attr
                                                  context:nil].size.height;
        content_H = height +7;
    }
    
    // 需要改
    content_H +=[SpCommentListImagesView getPhotosHeightWithModel:model] + 5;

    model.contentHeight = content_H;
    
    return content_H;
}

#pragma mark------------ cell高度 ----------------
+(CGFloat)cellHeightWithModel:(GetCommentListModel *)model{
    
    CGFloat h = 50+10+[self getCommentContentHeightWithModel:model]+5+20+10+10;
    
    return h;
}

@end

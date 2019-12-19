//
//  SpProductCommentListTableViewCell.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpProductCommentListTableViewCell.h"
#import "ZPMyStarShow.h"
#import "HMHDGYHomePhotosView.h"


//边距
#define Edge_width 10
//除了头像 剩下内容的宽度
#define Content_width (ScreenW - 2 * Edge_width)

@interface SpProductCommentListTableViewCell ()

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
//cell对应索引号
@property (nonatomic,assign) NSInteger cellIndex;

@end

@implementation SpProductCommentListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCommentView];
    }
    return self;
}

- (void)createCommentView{
    //头像
    _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(Edge_width, 10, 40, 40)];
    _iconImg.layer.masksToBounds = YES;
    _iconImg.layer.cornerRadius = _iconImg.width / 2.0;
    [self.contentView addSubview:_iconImg];
    
    //姓名
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame)+10, _iconImg.frame.origin.y,self.contentView.frame.size.width - CGRectGetMaxX(_iconImg.frame) - 20 - 90, _iconImg.frame.size.height)];
    _nameLab.font = [UIFont systemFontOfSize:15.0f];
    _nameLab.textColor = RGBACOLOR(51, 51, 51, 1);
    [self.contentView addSubview:_nameLab];

    // 星级
    _starView=[[ZPMyStarShow alloc]init];
    _starView.frame=CGRectMake(ScreenW -70 - 15, 10 + _iconImg.frame.size.height / 2 - 5,70, 10);
    _starView.starRating=5;
    _starView.isIndicator=YES;
    [_starView setImageDeselected:@"Shape" halfSelected:@"Shape1" fullSelected:@"Shape1" andDelegate:self];
    [self.contentView  addSubview:_starView];
    
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

    //
    //中间内容部分(动态高度)
    _contentBgView = [[UIView alloc]initWithFrame:CGRectMake(Edge_width,CGRectGetMaxY(_iconImg.frame)+4,Content_width,50 + 20 + 10)];
    _contentBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentBgView];

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
    _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(_iconImg.frame.origin.x,CGRectGetMaxY(_contentBgView.frame),ScreenW - _iconImg.frame.origin.x - 110,20)];
    _timeLab.font = [UIFont systemFontOfSize:12.0f];
    _timeLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self.contentView addSubview:_timeLab];
    
    // 点赞
    _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zanBtn.frame = CGRectMake(ScreenW - 100 , _timeLab.frame.origin.y, 40, 20);
    [_zanBtn setImage:[UIImage imageNamed:@"appreciate_light"] forState:UIControlStateNormal];
    [_zanBtn setImage:[UIImage imageNamed:@"appreciate_fill_light"] forState:UIControlStateSelected];
    [_zanBtn setTitle:@" 0" forState:UIControlStateNormal];
    [_zanBtn setTitle:@" 0" forState:UIControlStateSelected];
    _zanBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [_zanBtn setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
    [_zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_zanBtn];

    // 评论
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(CGRectGetMaxX(_zanBtn.frame) + 10, _zanBtn.frame.origin.y, 40, 20);
    [_commentBtn setImage:[UIImage imageNamed:@"circle_comment"] forState:UIControlStateNormal];
    [_commentBtn setTitle:@" 0" forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [_commentBtn setTitleColor: RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentBtn];
}

// 赞 按钮的点击事件
- (void)zanBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(CommentListZanBtnClickWithIndex:andCircleCell:)]) {
        [self.delegate CommentListZanBtnClickWithIndex:self.cellIndex andCircleCell:self];
    }
}

// 评论按钮的点击事件
- (void)commentBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(CommentListCommentBtnClickWithIndex:andCircleCell:)]) {
        [self.delegate CommentListCommentBtnClickWithIndex:self.cellIndex andCircleCell:self];
    }
}

#pragma mark ---------- 刷新 ---------
-(void)refreshCellWithModel:(GetCommentListModel *)model{
    //cell对应索引号
    _cellIndex = model.cellIndex;
    //头像 =======
    NSString *iconStr = model.icon;
    [self.iconImg sd_setImageWithURL:[iconStr get_Image] placeholderImage:[UIImage imageNamed:@"Sp_goods_comment_defautIcon"]];
    
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
        content_H = content_H +7;
    }
    _contentLab.height = content_H;

    // 需要传model  图片测试
    _cricleContent = [[HMHDGYHomePhotosView alloc] initWithFrame:CGRectMake(0, content_H + 3, Content_width, _contentBgView.height-content_H) withHeFaShoppingCommentInfo:model];
    
    __weak typeof(self) weakSelf = self;
    // 点击看大图
    [(HMHDGYHomePhotosView *)_cricleContent setImageTap:^(NSInteger index) {
        if ([weakSelf.delegate respondsToSelector:@selector(CommentListUserTapImageViewWithIndex:withCellImageViewsIndex:)]) {
            [weakSelf.delegate CommentListUserTapImageViewWithIndex:weakSelf.cellIndex withCellImageViewsIndex:index];
        }
    }];
    [_contentBgView addSubview:_cricleContent];
    
    //    
    _zanBtn.y =  CGRectGetMaxY(_contentBgView.frame)+15;
    _commentBtn.y =  CGRectGetMaxY(_contentBgView.frame)+15;
    _timeLab.y = CGRectGetMaxY(_contentBgView.frame)+15;
    
    // 点赞的状态
    NSString *isLikeStr = [NSString stringWithFormat:@"%@",model.isLike];
    if ([isLikeStr isEqualToString:@"1"]) {
        _zanBtn.selected = YES;
    } else if([isLikeStr isEqualToString:@"0"]){
        _zanBtn.selected = NO;
    }
    // 点赞
    NSString *likeCountStr = [NSString stringWithFormat:@"%@",model.commentLikeCount];
    if ([model.commentLikeCount longLongValue] > 99 || [likeCountStr isEqualToString:@" 99+"]) {
        [_zanBtn setTitle:[NSString stringWithFormat:@" 99+"] forState:UIControlStateNormal];
        [_zanBtn setTitle:[NSString stringWithFormat:@" 99+"] forState:UIControlStateSelected];
    } else {
        [_zanBtn setTitle:[NSString stringWithFormat:@" %lld",[model.commentLikeCount longLongValue]] forState:UIControlStateNormal];
        [_zanBtn setTitle:[NSString stringWithFormat:@" %lld",[model.commentLikeCount longLongValue]] forState:UIControlStateSelected];
    }

    // 按钮上的数字显示
    if ([model.commentReplyCount longLongValue] > 99) {
        [_commentBtn setTitle:[NSString stringWithFormat:@" 99+"] forState:UIControlStateNormal];
    } else {
        [_commentBtn setTitle:[NSString stringWithFormat:@" %lld",[model.commentReplyCount longLongValue]] forState:UIControlStateNormal];
    }
}

#pragma mark------------ cell高度 ----------------
+(CGFloat)cellHeightWithModel:(GetCommentListModel *)model{
    //头部间距＋name高度＋7间距+content高度＋5间距+几个按钮高度+7间距
    CGFloat h = 50+10+[self getCommentContentHeightWithModel:model]+5+20+10;
    return h;
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
    
    //
    content_H = content_H + [HMHDGYHomePhotosView getHeFaShoppingCommentPhotosHeightWithModel:model];
    
    model.contentHeight = content_H;
    
    return content_H;
}
@end

//
//  WARJournalBottomView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARMineExplorationBottomView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "WARLayoutButton.h"
#import "WARMoment.h"

@interface WARMineExplorationBottomView()

/** 地理信息 */
@property (nonatomic, strong) UIButton *addressButton;
/** 点赞数 */
@property (nonatomic, strong) WARLayoutButton *praiseButton;
/** 评论数 */
@property (nonatomic, strong) WARLayoutButton *commentButton;

@end

@implementation WARMineExplorationBottomView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.addressButton];
    [self addSubview:self.praiseButton];
    [self addSubview:self.commentButton]; 
}

#pragma mark - Event Response

- (void)commentAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(mineExpBottomViewDidComment:indexPath:)]) {
        [self.delegate mineExpBottomViewDidComment:self indexPath:self.indexPath];
    }
}

- (void)praiseAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(mineExpBottomViewDidPriase:indexPath:)]) {
        [self.delegate mineExpBottomViewDidPriase:self indexPath:self.indexPath];
    }
}

- (void)moreAction:(UIButton *)button {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGRect toSelfFrame = [button convertRect:button.frame fromView:self];//获取button在contentView的位置
    CGRect toWindowFrame = [button convertRect:toSelfFrame toView:window];
    
    //    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCellBottomViewShowPop:indexPath:showFrame:)]) {
    //        [self.delegate userDiaryBaseCellBottomViewShowPop:self indexPath:self.indexPath showFrame:toWindowFrame];
    //    }
}

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMoment:(WARMoment *)moment {
    _moment = moment;
    
    self.praiseButton.selected = moment.commentWapper.thumbUp;
    
    NSString *address = [NSString stringWithFormat:@"%@",moment.location];
    NSString *praise = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount];
    NSString *comment = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount];//[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount];
    
    [self.addressButton setTitle:address forState:UIControlStateNormal];
    [self.praiseButton setTitle:praise forState:UIControlStateNormal];
    [self.commentButton setTitle:comment forState:UIControlStateNormal];
    
    self.addressButton.hidden = (moment.location == nil || moment.location.length <= 0);
    
    self.addressButton.frame = moment.journalListLayout.addressButtonFrame;
    self.commentButton.frame = moment.journalListLayout.commentButtonFrame;
    self.praiseButton.frame = moment.journalListLayout.praiseButtonFrame;
}

- (UIButton *)addressButton {
    if (!_addressButton) {
//        UIImage *image = [UIImage war_imageName:@"person_home_location" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressButton.adjustsImageWhenHighlighted = NO;
//        _addressButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _addressButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [_addressButton setImage:image forState:UIControlStateNormal];
        _addressButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        [_addressButton setTitleColor:HEXCOLOR(0x576B95) forState:UIControlStateNormal];
    }
    return _addressButton;
}

- (WARLayoutButton *)praiseButton {
    if (!_praiseButton) { 
        UIImage *image = [UIImage war_imageName:@"wechatzan_nor" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"wechatzan_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _praiseButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        _praiseButton.adjustsImageWhenHighlighted = NO;
        _praiseButton.midSpacing = 3.5;
        _praiseButton.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _praiseButton.imageSize = CGSizeMake(17, 17);
//        _praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
        _praiseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_praiseButton setImage:image forState:UIControlStateNormal];
        [_praiseButton setImage:selectedImage forState:UIControlStateSelected];
        _praiseButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_praiseButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseButton;
}

- (WARLayoutButton *)commentButton {
    if (!_commentButton) {
        //chat_more
        UIImage *image = [UIImage war_imageName:@"wechatcomment" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"wechatcomment_sel" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _commentButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        _commentButton.adjustsImageWhenHighlighted = NO;
        _commentButton.midSpacing = 3.5;
        _commentButton.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _commentButton.imageSize = CGSizeMake(17, 17);
//        _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
        _commentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_commentButton setImage:image forState:UIControlStateNormal];
        _commentButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_commentButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        //        _commentButton.backgroundColor = kRandomColor;
    }
    return _commentButton;
}

@end

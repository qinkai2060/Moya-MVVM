//
//  WARUserDiaryBaseCellBottomView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import "WARUserDiaryBaseCellBottomView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "WARNewUserDiaryModel.h"
#import "WARNewUserDiaryMomentLayout.h"

@interface WARUserDiaryBaseCellBottomView()

/** 地理信息 */
@property (nonatomic, strong) UIButton *addressButton;
/** 点赞数 */
@property (nonatomic, strong) UIButton *praiseButton;
/** 评论数 */
@property (nonatomic, strong) UIButton *commentButton;
/** 步数 */
@property (nonatomic, strong) UIButton *stepCountButton;

@end

@implementation WARUserDiaryBaseCellBottomView

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
    [self addSubview:self.stepCountButton];
}

#pragma mark - Event Response

- (void)commentAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCellBottomViewDidComment:indexPath:)]) {
        [self.delegate userDiaryBaseCellBottomViewDidComment:self indexPath:self.indexPath];
    }
}

- (void)praiseAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCellBottomViewDidPriase:indexPath:)]) {
        [self.delegate userDiaryBaseCellBottomViewDidPriase:self indexPath:self.indexPath];
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

- (void)setMoment:(WARNewUserDiaryMoment *)moment {
    _moment = moment;
    
    self.praiseButton.selected = moment.thumbUp;
    
    NSString *address = [NSString stringWithFormat:@"%@",moment.location];
    NSString *praise = [NSString stringWithFormat:@"%ld",moment.praiseCount];
    NSString *comment = [NSString stringWithFormat:@"%ld",moment.commentCount];
    NSString *step = [NSString stringWithFormat:@"今天共走了%ld步，排名第%ld",moment.stepNum,moment.stepRank];
    
    
    [self.addressButton setTitle:address forState:UIControlStateNormal];
    [self.praiseButton setTitle:praise forState:UIControlStateNormal];
    [self.commentButton setTitle:comment forState:UIControlStateNormal];
    [self.stepCountButton setTitle:step forState:UIControlStateNormal];
    
    self.addressButton.hidden = (moment.location == nil || moment.location.length <= 0);
    self.stepCountButton.hidden = (moment.stepNum <= 0);
    
    self.addressButton.frame = moment.momentLayout.addressButtonFrame;
    self.stepCountButton.frame = moment.momentLayout.stepCountButtonFrame;
    self.commentButton.frame = moment.momentLayout.commentButtonFrame;
    self.praiseButton.frame = moment.momentLayout.praiseButtonFrame; 
}

- (UIButton *)addressButton {
    if (!_addressButton) {
        UIImage *image = [UIImage war_imageName:@"person_home_location" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressButton.adjustsImageWhenHighlighted = NO;
        _addressButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _addressButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addressButton setImage:image forState:UIControlStateNormal];
        _addressButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_addressButton setTitleColor:HEXCOLOR(0x386DB4) forState:UIControlStateNormal];
//        _addressButton.backgroundColor = kRandomColor;
    }
    return _addressButton;
}

- (UIButton *)praiseButton {
    if (!_praiseButton) {
        UIImage *image = [UIImage war_imageName:@"great_nor" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"great" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _praiseButton.adjustsImageWhenHighlighted = NO;
        _praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
        _praiseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_praiseButton setImage:image forState:UIControlStateNormal];
        [_praiseButton setImage:selectedImage forState:UIControlStateSelected];
        _praiseButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_praiseButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //        _praiseButton.backgroundColor = kRandomColor;
    }
    return _praiseButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        //chat_more
        UIImage *image = [UIImage war_imageName:@"wechat_message_nor" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"wechat_message" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.adjustsImageWhenHighlighted = NO;
        _commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
        _commentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_commentButton setImage:image forState:UIControlStateNormal];
        _commentButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_commentButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        //        _commentButton.backgroundColor = kRandomColor;
    }
    return _commentButton;
}
//
//- (UIButton *)moreButton {
//    if (!_moreButton) {
//        UIImage *image = [UIImage war_imageName:@"daily_more" curClass:[self class] curBundle:@"WARProfile.bundle"];
//
//        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
//        _moreButton.adjustsImageWhenHighlighted = NO;
//        _moreButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_moreButton setImage:image forState:UIControlStateNormal];
//        _moreButton.titleLabel.font = [UIFont systemFontOfSize:11];
//        [_moreButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
//    }
//    return _moreButton;
//}

- (UIButton *)stepCountButton {
    if (!_stepCountButton) {
        UIImage *image = [UIImage war_imageName:@"walk" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _stepCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _stepCountButton.adjustsImageWhenHighlighted = NO;
        _stepCountButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _stepCountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _stepCountButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_stepCountButton setImage:image forState:UIControlStateNormal];
        _stepCountButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_stepCountButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
//        _stepCountButton.backgroundColor = kRandomColor;
    }
    return _stepCountButton;
}

@end

//
//  WARFriendBaseCellBottomView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/3.
//

#import "WARFriendBottomView.h"
#import "WARBaseMacros.h"
#import "UIView+Frame.h"
#import "UIImage+WARBundleImage.h"
#import "WARMoment.h"
#import "WARFriendMomentLayout.h"
#import "WARRewordView.h"
#import "WARLayoutButton.h"

#define kSeparatorH 6

@interface WARFriendBottomView()

@property (nonatomic, strong) UILabel *timeLable;
/** 地理信息 */
@property (nonatomic, strong) UIButton *addressButton;
/** 全文 */
@property (nonatomic, strong) UIButton *allContextButton;
/** 点赞数 */
@property (nonatomic, strong) WARLayoutButton *praiseButton;
/** 评论数 */
@property (nonatomic, strong) WARLayoutButton *commentButton;
/** 去评论 */
@property (nonatomic, strong) UIButton *toCommentButton;

@property (nonatomic, strong) UIView * separatorView;


@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIButton *publicButton;
@property (nonatomic, strong) UIButton *doublePersonButton;

@property (nonatomic, strong) UIImageView *deleteImageView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *updateImageView;
@property (nonatomic, strong) UIImageView *publicImageView;
@property (nonatomic, strong) UIImageView *doubleImageView;

@property (nonatomic, strong) UIView *mineContainerView;
@end

@implementation WARFriendBottomView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.timeLable];
    [self addSubview:self.addressButton];
    [self addSubview:self.allContextButton];
    [self addSubview:self.praiseButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.toCommentButton];
//    [self addSubview:self.stepCountButton];
//    [self addSubview:self.closeButton];
//    [self addSubview:self.moreButton];
    [self addSubview:self.separatorView];
    [self addSubview:self.mineContainerView];
    [self addSubview:self.rewordView];
    
    
    [self.mineContainerView addSubview:self.deleteImageView];
    [self.mineContainerView addSubview:self.updateImageView];
    [self.mineContainerView addSubview:self.lockImageView];
//    [self.mineContainerView addSubview:self.publicImageView];
//    [self.mineContainerView addSubview:self.doubleImageView];
    
    [self.mineContainerView addSubview:self.deleteButton];
    [self.mineContainerView addSubview:self.updateButton];
    [self.mineContainerView addSubview:self.lockButton];
//    [self.mineContainerView addSubview:self.publicButton];
//    [self.mineContainerView addSubview:self.doublePersonButton];
    
    
}

#pragma mark - Event Response


- (void)deleteAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(friendBottomViewDidDelete:moment:)]) {
        [self.delegate friendBottomViewDidDelete:self moment:self.moment];
    }
}
- (void)updateAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(friendBottomViewDidEdit:moment:)]) {
        [self.delegate friendBottomViewDidEdit:self moment:self.moment];
    }
}
- (void)lockAction:(UIButton *)button {
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(friendBottomViewDidLock:moment:lock:)]) {
        [self.delegate friendBottomViewDidLock:self moment:self.moment lock:button.selected];
    }
}


- (void)closeAction:(UIButton *)button {
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    CGRect toSelfFrame = [button convertRect:button.frame fromView:self];//获取button在contentView的位置
//    CGRect toWindowFrame = [button convertRect:toSelfFrame toView:window];
//
//    if ([self.delegate respondsToSelector:@selector(friendBaseCellBottomViewShowPop:indexPath:showFrame:)]) {
//        [self.delegate friendBaseCellBottomViewShowPop:self indexPath:self.indexPath showFrame:toWindowFrame];
//    }
}

- (void)allContextAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(friendBottomViewDidAllContext:indexPath:)]) {
        [self.delegate friendBottomViewDidAllContext:self indexPath:self.indexPath];
    }
}

- (void)moreAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(friendBottomViewDidNoInterest:indexPath:)]) {
        [self.delegate friendBottomViewDidNoInterest:self indexPath:self.indexPath];
    }
}

- (void)praiseAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(friendBottomViewDidPriase:indexPath:)]) {
        [self.delegate friendBottomViewDidPriase:self indexPath:self.indexPath];
    }
}

- (void)commentAction:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(friendBottomViewDidComment:indexPath:)]) {
        [self.delegate friendBottomViewDidComment:self indexPath:self.indexPath];
    }
}

- (void)toCommentAction:(UIButton *)button {
//    if ([self.delegate respondsToSelector:@selector(friendBaseCellBottomViewDidComment:indexPath:)]) {
//        [self.delegate friendBaseCellBottomViewDidComment:self indexPath:self.indexPath];
//    }
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    CGRect toSelfFrame = [button convertRect:button.frame fromView:self];//获取button在contentView的位置
    CGRect toWindowFrame = [button convertRect:toSelfFrame toView:window];
    
    if ([self.delegate respondsToSelector:@selector(friendBottomViewShowPop:indexPath:showFrame:)]) {
        [self.delegate friendBottomViewShowPop:self indexPath:self.indexPath showFrame:toWindowFrame];
    }
}

#pragma mark - Delegate

#pragma mark - Public

- (void)showSeparatorView:(BOOL)show {
    self.separatorView.hidden = !show;
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setMoment:(WARMoment *)moment {
    _moment = moment;
    
    self.praiseButton.selected = moment.commentWapper.thumbUp;
    
//    self.moreButton.hidden = !moment.isMine;
//    self.closeButton.hidden = moment.isMine;
    
    if (moment.momentShowType == WARMomentShowTypeFriend) {
        self.toCommentButton.hidden = NO;
        self.commentButton.hidden = YES;
        self.praiseButton.hidden = YES;
    } else {
        self.toCommentButton.hidden = YES;
        self.commentButton.hidden = NO;
        self.praiseButton.hidden = NO;
    }
    
    NSString *address = [NSString stringWithFormat:@"%@",moment.location];
    NSString *praise = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount]; 
    NSString *comment = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount];//[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount];
    
    self.timeLable.text = moment.publishTimeString;
    [self.addressButton setTitle:address forState:UIControlStateNormal];
    [self.praiseButton setTitle:praise forState:UIControlStateNormal];
    [self.commentButton setTitle:comment forState:UIControlStateNormal];
    self.addressButton.hidden = (moment.location == nil || moment.location.length <= 0);
    [self.rewordView configReword:moment.reword];
    
    self.timeLable.frame = moment.friendMomentLayout.timeLableFrame;
    self.addressButton.frame = moment.friendMomentLayout.addressButtonFrame;
    self.allContextButton.frame = moment.friendMomentLayout.allContextButtonFrame;
    self.toCommentButton.frame = moment.friendMomentLayout.toCommentButtonFrame;
    self.commentButton.frame = moment.friendMomentLayout.commentButtonFrame;
    self.praiseButton.frame = moment.friendMomentLayout.praiseButtonFrame;
    if ((moment.momentShowType == WARMomentShowTypeFriendFollowDetail || moment.momentShowType == WARMomentShowTypeFriendDetail) && (moment.commentWapper.commentCount > 0 || moment.commentWapper.praiseCount > 0)) {
        self.separatorView.frame = moment.friendMomentLayout.bottomSeparatorFrame;
        self.separatorView.hidden = NO;
    } else {
        self.separatorView.hidden = YES;
    }
    
    if (self.moment.fromMineJournalList || (self.moment.fromFriendList && self.moment.isMine )) {
        self.mineContainerView.hidden = NO;
        self.mineContainerView.frame = moment.friendMomentLayout.mineContainerFrame;
    } else {
        self.mineContainerView.hidden = YES;
        self.mineContainerView.frame = moment.friendMomentLayout.mineContainerFrame;
    }
    
    if (moment.reword) {
        self.rewordView.frame = moment.friendMomentLayout.rewordViewFrame;
        self.rewordView.valueLable.frame = moment.friendMomentLayout.rewordValueLableFrame;
        self.rewordView.hidden = NO;
    } else {
        self.rewordView.hidden = YES;
    }
    
}
//
//- (WARMomentCellOperationMenu *)operationMenu {
//    if (!_operationMenu) {
//        _operationMenu = [[WARMomentCellOperationMenu alloc] init];
//        _operationMenu.frame = CGRectMake(kScreenWidth - 34.5, -7, 0, 39);//CGRectMake(kScreenWidth - 34.5 - 180, 8, 180, 39);
//        __weak typeof(self) weakSelf = self;
//        _operationMenu.likeButtonClickedOperation = ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [UIView animateWithDuration:0.25 animations:^{
//                strongSelf.operationMenu.frame = CGRectMake(kScreenWidth - 34.5, -7, 0, 39);
//                strongSelf.showingOperationMenu = NO;
//            }];
//        };
//        _operationMenu.commentButtonClickedOperation = ^{
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [UIView animateWithDuration:0.25 animations:^{
//                strongSelf.operationMenu.frame = CGRectMake(kScreenWidth - 34.5, -7, 0, 39);
//                strongSelf.showingOperationMenu = NO;
//            }];
//        };
//    }
//    return _operationMenu;
//}

- (WARRewordView *)rewordView {
    if (!_rewordView) {
        _rewordView = [[WARRewordView alloc]init];
//        _rewordView.backgroundColor = [UIColor whiteColor];
    }
    return _rewordView;
}

- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLable.textAlignment = NSTextAlignmentLeft;
        _timeLable.textColor = HEXCOLOR(0xADB1BE);
    }
    return _timeLable;
}

- (UIButton *)addressButton {
    if (!_addressButton) {
//        UIImage *image = [UIImage war_imageName:@"person_home_location" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressButton.adjustsImageWhenHighlighted = NO;
//        _addressButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _addressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _addressButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [_addressButton setImage:image forState:UIControlStateNormal];
        _addressButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_addressButton setTitleColor:HEXCOLOR(0x576B95) forState:UIControlStateNormal];
        //        _addressButton.backgroundColor = kRandomColor;
    }
    return _addressButton;
}

- (UIButton *)allContextButton {
    if (!_allContextButton) {
        _allContextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allContextButton.adjustsImageWhenHighlighted = NO;
        [_allContextButton setTitle:WARLocalizedString(@"全文>>") forState:UIControlStateNormal];
        [_allContextButton setTitleColor:HEXCOLOR(0x576B95) forState:UIControlStateNormal];
        _allContextButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.5];
        [_allContextButton setTitleColor:HEXCOLOR(0x576B95) forState:UIControlStateNormal];
        [_allContextButton addTarget:self action:@selector(allContextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allContextButton;
}

- (WARLayoutButton *)praiseButton {
    if (!_praiseButton) {
        UIImage *image = [UIImage war_imageName:@"wechatzan_nor" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"wechatzan_pre" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _praiseButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        _praiseButton.midSpacing = 3.5;
        _praiseButton.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _praiseButton.imageSize = CGSizeMake(17, 17);
        _praiseButton.adjustsImageWhenHighlighted = NO;
//        _praiseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
        _praiseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_praiseButton setImage:image forState:UIControlStateNormal];
        [_praiseButton setImage:selectedImage forState:UIControlStateSelected];
        _praiseButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];;
        [_praiseButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
        [_praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //        _praiseButton.backgroundColor = kRandomColor;
    }
    return _praiseButton;
}

- (WARLayoutButton *)commentButton {
    if (!_commentButton) {
        //chat_more
        UIImage *image = [UIImage war_imageName:@"wechatcomment" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"wechatcomment_sel" curClass:[self class] curBundle:@"WARProfile.bundle"];
//
//        UIImage *image = [UIImage war_imageName:@"222" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        UIImage *selectedImage = [UIImage war_imageName:@"2" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _commentButton = [WARLayoutButton buttonWithType:UIButtonTypeCustom];
        _commentButton.midSpacing = 3.5;
        _commentButton.layoutStyle = LayoutButtonStyleLeftImageRightTitle;
        _commentButton.imageSize = CGSizeMake(17, 17);
        _commentButton.adjustsImageWhenHighlighted = NO;
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

- (UIButton *)toCommentButton {
    if (!_toCommentButton) {
        UIImage *image = [UIImage war_imageName:@"chat_more" curClass:[self class] curBundle:@"WARProfile.bundle"];
        UIImage *selectedImage = [UIImage war_imageName:@"chat_more" curClass:[self class] curBundle:@"WARProfile.bundle"];
        
        _toCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _toCommentButton.adjustsImageWhenHighlighted = NO;
//        _toCommentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        _toCommentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_toCommentButton setImage:image forState:UIControlStateNormal];
//        _toCommentButton.titleLabel.font = [UIFont systemFontOfSize:11];
//        [_toCommentButton setTitleColor:HEXCOLOR(0x8D93A4) forState:UIControlStateNormal];
        [_toCommentButton addTarget:self action:@selector(toCommentAction:) forControlEvents:UIControlEventTouchUpInside];
        //        _commentButton.backgroundColor = kRandomColor;
    }
    return _toCommentButton;
}
 
- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = HEXCOLOR(0xF4F4F4);
    }
    return _separatorView;
}

- (UIView *)mineContainerView {
    if (!_mineContainerView) {
        _mineContainerView = [[UIView alloc] init];
        _mineContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _mineContainerView;
}

- (UIImageView *)deleteImageView {
    if (!_deleteImageView) {
        UIImage *image = [UIImage war_imageName:@"newfriend_delete" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 15, 15)];
        _deleteImageView.image = image;
        _deleteImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _deleteImageView;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        UIImage *image = [UIImage war_imageName:@"newfriend_delete" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, 0, 25, 25);
        _deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _deleteButton.adjustsImageWhenHighlighted = NO;
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIImageView *)updateImageView {
    if (!_updateImageView) {
        UIImage *image = [UIImage war_imageName:@"newfriend_edit" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _updateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 3, 15, 15)];
        _updateImageView.image = image;
        _updateImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _updateImageView;
}
- (UIButton *)updateButton {
    if (!_updateButton) {
        UIImage *image = [UIImage war_imageName:@"newfriend_edit" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _updateButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _updateButton.frame = CGRectMake(25, 0, 25, 25);
        _updateButton.adjustsImageWhenHighlighted = NO;
        [_updateButton addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        UIImage *image = [UIImage war_imageName:@"daily_lock" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 3, 15, 15)];
        _lockImageView.image = image;
        _lockImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _lockImageView;
}
- (UIButton *)lockButton {
    if (!_lockButton) {
        UIImage *image = [UIImage war_imageName:@"daily_lock" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lockButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _lockButton.frame = CGRectMake(50, 0, 25, 25);
        _lockButton.adjustsImageWhenHighlighted = NO;
        [_lockButton addTarget:self action:@selector(lockAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockButton;
}

//- (UIImageView *)publicImageView {
//    if (!_publicImageView) {
//        UIImage *image = [UIImage war_imageName:@"daily_public" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        _publicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 20, 15, 15)];
//        _publicImageView.image = image;
//        _publicImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _publicImageView;
//}
//- (UIButton *)publicButton {
//    if (!_publicButton) {
//        UIImage *image = [UIImage war_imageName:@"daily_public" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        _publicButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _publicButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _publicButton.frame = CGRectMake(63, 0, 15, 15);
//        _publicButton.adjustsImageWhenHighlighted = NO;
////        [_publicButton setImage:image forState:UIControlStateNormal];
////        [_publicButton addTarget:self action:@selector(lockAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _publicButton;
//}

//- (UIImageView *)doubleImageView {
//    if (!_doubleImageView) {
//        UIImage *image = [UIImage war_imageName:@"daily_public2" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        _doubleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(84, 20, 15, 15)];
//        _doubleImageView.image = image;
//        _doubleImageView.contentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _doubleImageView;
//}
//- (UIButton *)doublePersonButton {
//    if (!_doublePersonButton) {
//        UIImage *image = [UIImage war_imageName:@"daily_public2" curClass:[self class] curBundle:@"WARProfile.bundle"];
//        _doublePersonButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _doublePersonButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _doublePersonButton.frame = CGRectMake(84, 0, 15, 15);
//        _doublePersonButton.adjustsImageWhenHighlighted = NO;
////        [_doublePersonButton setImage:image forState:UIControlStateNormal];
//        //        [_publicButton addTarget:self action:@selector(lockAction:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _doublePersonButton;
//}

@end
 

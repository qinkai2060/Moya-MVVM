//
//  WARFriendMessageCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARFriendMessageCell.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"
#import "WARFriendCommentView.h"
#import "UIImageView+WebCache.h"
#import "WARUIHelper.h"
#import "WARPhotoBrowser.h"

@interface WARFriendMessageCell()<WARFriendCommentViewDelegate>

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UIImageView *userIconView;
@property (nonatomic, strong) WARFriendCommentView *commentView;
@property (nonatomic, strong) UILabel *subContentLable;
@property (nonatomic, strong) UILabel *commentContentLable;
@property (nonatomic, strong) UIImageView *commentContentIconView;
@property (nonatomic, strong) UIImageView *subContentIconView;
@property (nonatomic, strong) UIImageView *subContentVideoIconView;
@property (nonatomic, strong) UIImageView *praiseIconView;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIView * separatorView;

@end

@implementation WARFriendMessageCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFriendMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFriendMessageCell"];
    if (!cell) {
        cell = [[[WARFriendMessageCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFriendMessageCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.userIconView];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.commentView];
    [self.contentView addSubview:self.subContentLable];
    [self.contentView addSubview:self.subContentIconView];
//    [self.contentView addSubview:self.commentContentLable];
//    [self.contentView addSubview:self.commentContentIconView];
    [self.subContentIconView addSubview:self.subContentVideoIconView];
    [self.contentView addSubview:self.praiseIconView];
    [self.contentView addSubview:self.timeLable];
    [self.contentView addSubview:self.separatorView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserAction:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserAction:)];
    [self.userIconView addGestureRecognizer:tap1];
    [self.nameLable addGestureRecognizer:tap2];
}

#pragma mark - Event Response

- (void)tapUserAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(friendMessageCell:didUser:)]) {
        [self.delegate friendMessageCell:self didUser:self.layout.remind.replyorInfo];
    }
}

#pragma mark - Delegate

#pragma mark - WARFriendCommentViewDelegate 
/// 图片浏览
- (void)friendCommentView:(WARFriendCommentView *)friendCommentView showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
    NSMutableArray *tempArray = [NSMutableArray array];
    [photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSURL class]]) {
            urlString = ((NSURL *)obj).absoluteString;
        } else {
            urlString = obj;
        }
        WARPhotoBrowserModel *photoBrowserModel = [[WARPhotoBrowserModel alloc]init];
        photoBrowserModel.picUrl = [kCMPRPhotoUrl(urlString) absoluteString];
        [tempArray addObject:photoBrowserModel];
    }];
    WARPhotoBrowser *photoBrowser = [[WARPhotoBrowser alloc]init];
    photoBrowser.placeholderImage = DefaultPlaceholderImageForFullScreen;;
    photoBrowser.photoArray = tempArray;
    photoBrowser.currentIndex = index;
    [photoBrowser show];
}

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFriendMessageLayout *)layout {
    _layout = layout;
    
    WARMomentRemind *remind = layout.remind;
    
    _subContentVideoIconView.hidden = YES;
    _commentView.hidden = NO;
    _praiseIconView.hidden = YES; 
    _subContentIconView.hidden = YES;
    _subContentLable.hidden = YES;
    
    [_userIconView sd_setImageWithURL:kOriginMediaUrl(remind.replyorInfo.headId) placeholderImage:[WARUIHelper war_defaultUserIcon]];
    _nameLable.attributedText = remind.nameAttributeString;
    _timeLable.text = remind.commentTimeDesc;
    _commentView.comments = remind.commentsLayoutArr;
    
//    _commentContentLable.text = remind.commentBody.title;
//    WARMomentMedia *media;
//    if (remind.commentBody.medias.count > 0) {
//        media = remind.commentBody.medias.firstObject;
//        [_commentContentIconView sd_setImageWithURL:media.imageURL placeholderImage:[WARUIHelper war_defaultUserIcon]];
//    }
    
    switch (remind.moment.bodyTypeEnum) {
        case WARMomentRemindBodyTypeText:
        {
            _subContentLable.hidden = NO;
            _subContentLable.attributedText = remind.moment.bodyAttributeString;
        }
            break;
        case WARMomentRemindBodyTypeVideo:
        {
            _subContentVideoIconView.hidden = NO;
            _subContentIconView.hidden = NO;
            [_subContentIconView sd_setImageWithURL:kOriginMediaUrl(remind.moment.body) placeholderImage:[WARUIHelper war_defaultUserIcon]];
        }
            break;
        case WARMomentRemindBodyTypePicture:
        {
            _subContentIconView.hidden = NO;
            [_subContentIconView sd_setImageWithURL:kOriginMediaUrl(remind.moment.body) placeholderImage:[WARUIHelper war_defaultUserIcon]];
        }
            break;
        case WARMomentRemindBodyTypeLink:
        {
            _subContentLable.hidden = NO;
            _subContentLable.attributedText = remind.moment.linkBodyAttributeString;
        }
            break;
    }
    
    switch (remind.remindTypeEnum) {
        case WARMomentRemindTypeDefault:
        {
            _commentView.hidden = NO;
        }
            break;
        case WARMomentRemindTypeComment:
        {
            _praiseIconView.hidden = YES;
            _commentView.hidden = NO;
        }
            break;
        case WARMomentRemindTypeThumb:
        {
            _praiseIconView.hidden = NO;
            _commentView.hidden = YES;
        }
            break;
    }
    
    _userIconView.frame = layout.userIconF;
    _nameLable.frame = layout.nameLabelF;
    _commentView.frame = layout.commentViewF;
    _subContentIconView.frame = layout.subContentIconF;
    _subContentVideoIconView.frame = layout.subContentVideoIconF;
    _subContentLable.frame = layout.subContentLableF;
    _timeLable.frame = layout.timeLableF;
    _praiseIconView.frame = layout.praiseIconF;
    _separatorView.frame = layout.lineF;
//    _commentContentLable.frame = layout.commentContentLableF;
//    _commentContentIconView.frame = layout.commentContentMediaF;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.textColor = HEXCOLOR(0x576B95);
        _nameLable.numberOfLines = 0;
        _nameLable.userInteractionEnabled = YES;
    }
    return _nameLable;
}

- (UIImageView *)userIconView {
    if (!_userIconView) {
        _userIconView = [[UIImageView alloc]init];
        _userIconView.contentMode = UIViewContentModeScaleAspectFill;
        _userIconView.layer.cornerRadius = 4.0;
        _userIconView.layer.masksToBounds = YES;
        _userIconView.userInteractionEnabled = YES;
    }
    return _userIconView;
}

- (WARFriendCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[WARFriendCommentView alloc]init];
        _commentView.isWhiteBackgroundColor = YES;
        _commentView.delegate = self;
    }
    return _commentView;
}

- (UILabel *)subContentLable {
    if (!_subContentLable) {
        _subContentLable = [[UILabel alloc]init];
        _subContentLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _subContentLable.textAlignment = NSTextAlignmentLeft;
        _subContentLable.textColor = HEXCOLOR(0x575C68);
        _subContentLable.numberOfLines = 0;
    }
    return _subContentLable;
}

- (UILabel *)commentContentLable {
    if (!_commentContentLable) {
        _commentContentLable = [[UILabel alloc]init];
        _commentContentLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _commentContentLable.textAlignment = NSTextAlignmentLeft;
        _commentContentLable.textColor = HEXCOLOR(0x343C4F);
        _commentContentLable.numberOfLines = 0;
    }
    return _commentContentLable;
}
- (UIImageView *)commentContentIconView {
    if (!_commentContentIconView) {
        _commentContentIconView = [[UIImageView alloc]init];
        _commentContentIconView.contentMode = UIViewContentModeScaleAspectFill;
        _commentContentIconView.layer.masksToBounds = YES;
        _commentContentIconView.userInteractionEnabled = YES;
    }
    return _commentContentIconView;
}
- (UILabel *)timeLable {
    if (!_timeLable) {
        _timeLable = [[UILabel alloc]init];
        _timeLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _timeLable.textAlignment = NSTextAlignmentLeft;
        _timeLable.textColor = HEXCOLOR(0xADB1BE);
        _timeLable.numberOfLines = 0;
    }
    return _timeLable;
}

- (UIImageView *)praiseIconView {
    if (!_praiseIconView) {
        UIImage *image = [UIImage war_imageName:@"great_click" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _praiseIconView = [[UIImageView alloc]init];
        _praiseIconView.image = image;
        _praiseIconView.contentMode = UIViewContentModeScaleAspectFill;
        _praiseIconView.layer.masksToBounds = YES;
    }
    return _praiseIconView;
}

- (UIImageView *)subContentIconView {
    if (!_subContentIconView) {
        _subContentIconView = [[UIImageView alloc]init];
        _subContentIconView.contentMode = UIViewContentModeScaleAspectFill;
        _subContentIconView.layer.masksToBounds = YES;
    }
    return _subContentIconView;
}
- (UIImageView *)subContentVideoIconView {
    if (!_subContentVideoIconView) {
        UIImage *image = [UIImage war_imageName:@"video" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _subContentVideoIconView = [[UIImageView alloc]init];
        _subContentVideoIconView.image = image;
        _subContentVideoIconView.contentMode = UIViewContentModeScaleAspectFill;
        _subContentVideoIconView.layer.masksToBounds = YES;
    }
    return _subContentVideoIconView;
}
- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = HEXCOLOR(0xEEEEEE);//[UIColor redColor];//HEXCOLOR(0xDCDEE6);
    }
    return _separatorView;
}

@end

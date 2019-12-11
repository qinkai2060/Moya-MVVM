//
//  WARFriendCommentMediaCCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import "WARFriendCommentMediaCCell.h"
#import "ReactiveObjC.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "WARMacros.h"
#import "WARTweetVideoTool.h"
#import "WARUIHelper.h"
#import "WARCommentsTool.h"


@interface WARFriendCommentMediaCCell()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation WARFriendCommentMediaCCell
 
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = HEXCOLOR(0xF4F4F6);
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.playVideoButton];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        [self.playVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setMedia:(WARMomentMedia *)media{
    
    _media = media;
    
    [self.imageView sd_setImageWithURL:kPhotoUrlWithImageSize(CGSizeMake(kCommentCollectionCellWH, kCommentCollectionCellWH), media.imgId) placeholderImage:DefaultUserIcon];
    if(kStringIsEmpty(media.videoId)){
        self.playVideoButton.hidden = YES;
    }else{
        self.playVideoButton.hidden = NO;
    }
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)playVideoButton{
    if (!_playVideoButton) {
        _playVideoButton = [[UIButton alloc] initWithFrame:CGRectZero];
        UIImage *defultImage = [WARCommentsTool commentsGetImg:@"comment_video"];
        [_playVideoButton setImage:defultImage forState:UIControlStateNormal];
        [_playVideoButton setImage:defultImage forState:UIControlStateSelected];
    }
    return _playVideoButton;
}

@end

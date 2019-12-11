//
//  WARGameCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import "WARGameRankCell.h"
#import "WARFeedMagicImageView.h"
#import "WARGameRankView.h"
#import "WARFeedGame.h"
#import "WARFeedModel.h"

@interface WARGameRankCell()
/** 游戏封面、截图 */
@property (nonatomic, strong) WARFeedMagicImageView *contentImgView;
/** 排名视图 */
@property (nonatomic, strong) WARGameRankView *rankView;
@end

@implementation WARGameRankCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARGameRankCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARGameRankCell"];
    if (!cell) {
        cell = [[[WARGameRankCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARGameRankCell"];
    }
    return cell;
}

- (void)setupSubViews{
    [super setupSubViews];
    
    [self.contentView addSubview:self.contentImgView];
    [self.contentView addSubview:self.rankView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didImage:)];
    [self.contentImgView addGestureRecognizer:tap];
}

#pragma mark - Event Response

- (void)didImage:(UITapGestureRecognizer *)tap {
    WARFeedImageComponent *didImageComponent = self.contentImgView.didImageComponent;
    
    if (didImageComponent == nil || didImageComponent.url == nil) {
        return ;
    }
    
    NDLog(@"didImageComponent:%@",didImageComponent.url);
    
    NSInteger index = [self.contentImgView.images indexOfObject:didImageComponent];
    if (didImageComponent == nil) {//容错处理
        if (self.contentImgView.images.count > 0) {
            index = 0;
        } else {
            return ;
        }
    }
    
//    if ([self.delegate respondsToSelector:@selector(didIndex:imageComponents:)]) {
//        [self.delegate didIndex:index imageComponents:self.contentImgView.images];
//    }

    if ([self.delegate respondsToSelector:@selector(gameRankCell:didLink:)]) {
        WARFeedLinkComponent *link = [[WARFeedLinkComponent alloc]init];
        link.url = self.layout.component.content.game.gameUrl;
        [self.delegate gameRankCell:self didLink:link];
    }
}


#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

- (void)setLayout:(WARFeedComponentLayout *)layout{
    [super setLayout:layout];
    
    WARFeedGame *game = layout.component.content.game;
    WARFeedGameLayout *gameLayout = layout.gameLayout;
    
    CGSize imgSize = game.media.pintu.viewSizeSize;
    CGFloat imgW = layout.contentScale * imgSize.width ;
    CGFloat imgH = layout.contentScale * imgSize.height ;
    
    self.contentImgView.frame = CGRectMake(5, 5, imgW, imgH);
    self.contentImgView.contentScale = layout.contentScale ;
    self.contentImgView.images = game.media.images;
    [self.contentImgView sd_setImageWithURL:game.media.pintu.url placeholderImage:DefaultPlaceholderImageWtihSize(CGSizeMake(imgW, imgH))];
    
    self.rankView.frame = gameLayout.rankViewFrame;
    self.rankView.game = game;
}

- (WARFeedMagicImageView *)contentImgView{
    if (!_contentImgView) {
        _contentImgView = [[WARFeedMagicImageView alloc] init];
        _contentImgView.layer.masksToBounds = YES;
        _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgView.tag = 100;
        _contentImgView.userInteractionEnabled = YES;
    }
    return _contentImgView;
}

- (WARGameRankView *)rankView {
    if (!_rankView) {
        _rankView = [[WARGameRankView alloc]init];
        __weak typeof(self) weakSelf = self;
        _rankView.allRankBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([self.delegate respondsToSelector:@selector(gameRankCellDidAllRank:game:)]) {
                [self.delegate gameRankCellDidAllRank:self game:self.layout.component.content.game];
            }
        };
    }
    return _rankView;
}

@end

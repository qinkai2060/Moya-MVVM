//
//  WARMineExplorationBaseCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARMineExplorationBaseCell.h"

#import "WARMacros.h"
#import "WARLocalizedHelper.h"

#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Frame.h"

#import "WARMineExplorationTopView.h"
#import "WARMineExplorationBottomView.h"

@interface WARMineExplorationBaseCell()<WARMineExplorationBottomViewDelegate>

@end

@implementation WARMineExplorationBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(whiteColor);
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.bottomView];
}

#pragma mark - WARMineExplorationBottomViewDelegate

-(void)mineExpBottomViewDidPriase:(WARMineExplorationBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(mineExpBaseCellDidPriase:indexPath:)]) {
        [self.delegate mineExpBaseCellDidPriase:self indexPath:indexPath];
    }
}

-(void)mineExpBottomViewDidComment:(WARMineExplorationBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(mineExpBaseCellDidComment:indexPath:)]) {
        [self.delegate mineExpBaseCellDidComment:self indexPath:indexPath];
    }
}

#pragma mark - getter methods

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.bottomView.indexPath = indexPath;
}

- (WARMineExplorationTopView *)topView {
    if (!_topView) {
        _topView = [[WARMineExplorationTopView alloc]init];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, 62);
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (WARMineExplorationBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[WARMineExplorationBottomView alloc]init];
        _bottomView.delegate = self;
        _bottomView.frame = CGRectMake(0, 0, kScreenWidth, 60); 
    }
    return _bottomView;
}

@end

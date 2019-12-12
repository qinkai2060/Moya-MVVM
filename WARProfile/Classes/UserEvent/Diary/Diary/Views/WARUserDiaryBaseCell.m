//
//  WARUserDiaryBaseCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

#import "WARUserDiaryBaseCell.h"
#import "WARMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Frame.h"
#import "WARUserDiaryBaseCellTopView.h"
#import "WARUserDiaryBaseCellBottomView.h"

@interface WARUserDiaryBaseCell()<WARUserDiaryBaseCellBottomViewDelegate>
 
@end

@implementation WARUserDiaryBaseCell

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

#pragma mark - WARUserDiaryBaseCellBottomViewDelegate

- (void)userDiaryBaseCellBottomViewShowPop:(WARUserDiaryBaseCellBottomView *)bottomView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCellShowPop:actionType:indexPath:showFrame:)]) {
        [self.delegate userDiaryBaseCellShowPop:self actionType:(WARUserDiaryBaseCellActionTypeDidBottomPop) indexPath:indexPath showFrame:frame];
    }
}

-(void)userDiaryBaseCellBottomViewDidPriase:(WARUserDiaryBaseCellBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCellDidPriase:indexPath:)]) {
        [self.delegate userDiaryBaseCellDidPriase:self indexPath:indexPath];
    }
}

-(void)userDiaryBaseCellBottomViewDidComment:(WARUserDiaryBaseCellBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(userDiaryBaseCellDidComment:indexPath:)]) {
        [self.delegate userDiaryBaseCellDidComment:self indexPath:indexPath];
    }
}
 
#pragma mark - getter methods

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.bottomView.indexPath = indexPath;
}

- (WARUserDiaryBaseCellTopView *)topView {
    if (!_topView) {
        _topView = [[WARUserDiaryBaseCellTopView alloc]init];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, 62);
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (WARUserDiaryBaseCellBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[WARUserDiaryBaseCellBottomView alloc]init];
        _bottomView.delegate = self; 
        _bottomView.frame = CGRectMake(0, 0, kScreenWidth, 60);
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

@end

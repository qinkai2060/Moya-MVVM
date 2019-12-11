//
//  WARJournalBaseCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARJournalBaseCell.h"
#import "WARMacros.h"
#import "WARLocalizedHelper.h"
#import "UIImage+WARBundleImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Frame.h"
#import "WARJournalTopView.h"
#import "WARJournalBottomView.h"

@interface WARJournalBaseCell()<WARJournalBottomViewDelegate>

@end

@implementation WARJournalBaseCell


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

#pragma mark - WARJournalBottomViewDelegate

-(void)journalBottomViewShowPop:(WARJournalBottomView *)bottomView indexPath:(NSIndexPath *)indexPath showFrame:(CGRect)frame {
    if ([self.delegate respondsToSelector:@selector(journalBaseCellShowPop:actionType:indexPath:showFrame:)]) {
        [self.delegate journalBaseCellShowPop:self actionType:(WARJournalBaseCellActionTypeDidBottomPop) indexPath:indexPath showFrame:frame];
    }
}

-(void)journalBottomViewDidPriase:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(journalBaseCellDidPriase:indexPath:)]) {
        [self.delegate journalBaseCellDidPriase:self indexPath:indexPath];
    }
}

-(void)journalBottomViewDidComment:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(journalBaseCellDidComment:indexPath:)]) {
        [self.delegate journalBaseCellDidComment:self indexPath:indexPath];
    }
}

-(void)journalBottomViewDidDelete:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(journalBaseCellDidDelete:indexPath:)]) {
        [self.delegate journalBaseCellDidDelete:self indexPath:indexPath];
    }
}

-(void)journalBottomViewDidPublish:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(journalBaseCellDidPublish:indexPath:)]) {
        [self.delegate journalBaseCellDidPublish:self indexPath:indexPath];
    }
}

-(void)journalBottomViewDidAllContext:(WARJournalBottomView *)bottomView  indexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(journalBaseCellDidAllContext:indexPath:)]) {
        [self.delegate journalBaseCellDidAllContext:self indexPath:indexPath];
    }
}

#pragma mark - getter methods

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.bottomView.indexPath = indexPath;
}

- (WARJournalTopView *)topView {
    if (!_topView) {
        _topView = [[WARJournalTopView alloc]init];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, 62);
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (WARJournalBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[WARJournalBottomView alloc]init];
        _bottomView.delegate = self;
        _bottomView.frame = CGRectMake(0, 0, kScreenWidth, 60);
//        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

@end

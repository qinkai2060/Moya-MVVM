//
//  WARFriendCommentView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/4.
//

#import "WARFriendCommentView.h"
#import "UIView+SDAutoLayout.h"
#import "MLLinkLabel.h"
#import "WARMacros.h"
#import "WARMoment.h"
#import "WARDBContactModel.h"
#import "UIImage+WARBundleImage.h"
#import "UIScrollView+WARRefresh.h"
#import "WARNetwork.h"
#import "WARCommentsTool.h"
#import "WARCommentModel.h"
#import "MJExtension.h"
#import "WARCommentLayout.h"
#import "WARCommentsHeaderView.h"
#import "WARFriendCommentCell.h"
#import "WARFriendCommentMoreCell.h"
#import "Masonry.h"

#define TimeLineCellHighlightedColor HEXCOLOR(0x576B95)
#define kShowCommentCount 60

@interface WARFriendCommentView() <UITableViewDelegate, UITableViewDataSource, WARFriendCommentCellDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, copy) NSString *lastId;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *commentID;

@end

@implementation WARFriendCommentView

#pragma mark - System

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.left.top.bottom.right.mas_equalTo(0);
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
}

#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL moreComments = (self.comments.count > kShowCommentCount);
    return moreComments ? (kShowCommentCount + 1) : self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARFriendCommentLayout* layout = self.comments[indexPath.row];
    NSInteger commentCount = self.comments.count;
    BOOL moreComments = (commentCount > kShowCommentCount);
    if (moreComments) {
        commentCount = kShowCommentCount;
    }
    if (indexPath.row == commentCount){
        WARFriendCommentMoreCell* cell = [WARFriendCommentMoreCell cellWithTableView:tableView];
//        cell.layout = layout;
//        __weak typeof(self) weakSelf = self;
//        cell.showMoreComments = ^(WARShowMoreCommentsCell *cell, WARCommentModel *comment) {
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//
//            [strongSelf enterMoreListView:layout.comment];
//            [strongSelf enterMoreListViewWithLayout:layout];
//        };
        return cell;
    }else{
        WARFriendCommentCell* cell = [WARFriendCommentCell cellWithTableView:tableView];
        cell.contentView.backgroundColor = self.isWhiteBackgroundColor ? [UIColor whiteColor] : HEXCOLOR(0xF4F4F6);
        cell.delegate = self;
        cell.commentLayout = layout;
        return cell;
    }
}


- (void)replyComment:(WARCommentModel *)comment {
    
}

- (void)enterMoreListView:(WARCommentModel *)comment {
    
}

- (void)enterMoreListViewWithLayout:(WARCommentLayout *)comment {
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WARFriendCommentLayout* layout = self.comments[indexPath.row];
    NSInteger commentCount = self.comments.count;
    BOOL moreComments = (commentCount > kShowCommentCount);
    if (moreComments) {
        commentCount = kShowCommentCount;
    }
    if (indexPath.row == commentCount){
        return moreComments ? 35 : 10;
    }else{
        return layout.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WARFriendCommentLayout* layout = self.comments[indexPath.row];
    NSInteger commentCount = self.comments.count;
    BOOL moreComments = (commentCount > kShowCommentCount);
    if (moreComments) {
        commentCount = kShowCommentCount;
    }
    if (indexPath.row != commentCount){
        if ([self.delegate respondsToSelector:@selector(friendCommentView:didComment:)]) {
            [self.delegate friendCommentView:self didComment:layout.comment];
        }
    }
}

#pragma mark - WARFriendCommentCellDelegate


/// 图片浏览
- (void)showPhotoBrower:(NSArray *)photos currentIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(friendCommentView:showPhotoBrower:currentIndex:)]) {
        [self.delegate friendCommentView:self showPhotoBrower:photos currentIndex:index];
    }
}

/// 视频播放
- (void)playVideoWithUrl:(NSString *)videoUrl {
    if ([self.delegate respondsToSelector:@selector(friendCommentView:playVideoWithUrl:)]) {
        [self.delegate friendCommentView:self playVideoWithUrl:videoUrl];
    }
}

/// 头像点击
- (void)tapIconWithAccountId:(NSString*)accountId {
    
}

/// 点击了 Label 的链接
- (void)cell:(UIView *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    if ([self.delegate respondsToSelector:@selector(friendCommentView:didClickInLabel:textRange:)]) {
        [self.delegate friendCommentView:self didClickInLabel:label textRange:textRange];
    }
}

/// 播放音频
- (void)audioPlay:(WARMomentVoice*)audio playBtn:(UIButton *)sender voiceView:(WARFriendCommentVoiceView *)voiceView {
    if ([self.delegate respondsToSelector:@selector(friendCommentView:audioPlay:playBtn:voiceView:)]) {
        [self.delegate friendCommentView:self audioPlay:audio playBtn:sender voiceView:voiceView];
    }
}
 
#pragma mark - Private

- (void)loadMoreComments:(BOOL)isLoadMore {
    NSString* urlString = nil;
    
//    if (self.isMoreList) {
//        urlString = [WARCommentsTool commentsUrl:self.itemId commentID:self.commentID lastID:self.lastId];
//    }else {
//        urlString = [WARCommentsTool commentsUrl:self.itemId lastID:self.lastId];
//    }
//    
//    __weak typeof(self) weakSelf = self;
//    [WARNetwork getDataFromURI:urlString params:@{} completion:^(id responseObj, NSError *err) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        
//        NDLog(@"responseObj = %@", responseObj);
//        if (!err && !kObjectIsEmpty(responseObj)) {
//            NSArray* comments = [WARCommentModel mj_objectArrayWithKeyValuesArray:responseObj];
//            NSMutableArray* commentsArr = [NSMutableArray arrayWithCapacity:comments.count];
//            [comments enumerateObjectsUsingBlock:^(WARCommentModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                WARCommentLayout* layout = [[WARCommentLayout alloc] init];
//                layout.useSectionHeaderCalculate = YES;
//                layout.comment = obj;
//                [commentsArr addObject:layout];
//            }];
//            if (strongSelf.lastId.length == 0) {
//                strongSelf.comments = commentsArr;
//            }else{
//                [[strongSelf mutableArrayValueForKey:@"comments"] addObjectsFromArray:commentsArr];
//            }
//            
//            WARCommentModel *model = [comments lastObject];
//            if (strongSelf.lastId.length) {
//                strongSelf.lastId = model.lastId;
//            }
//        }
//        [strongSelf.tableView war_endRefresh];
//    }];
}

- (void)tableViewDidRefreshed{
    // 子类重写
}

- (void)tableViewwDidScroll:(UIScrollView *)scrollView{
    // 子类重写
}

#pragma mark - Setter And Getter


- (void)setIsWhiteBackgroundColor:(BOOL)isWhiteBackgroundColor {
    _isWhiteBackgroundColor = isWhiteBackgroundColor;
    self.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)setComments:(NSMutableArray<WARFriendCommentLayout *> *)comments {
    _comments = comments; 
    
    [self.tableView reloadData];
}


- (void)hideLineView:(BOOL)hide {
    self.lineView.hidden = hide;
}

//- (void)setMoment:(WARMoment *)moment {
//    _moment = moment;
//    
//    self.comments = moment.commentsLayoutArr;
//    
//    [self.tableView reloadData];
//}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xDCDEE6);
        _lineView.alpha = 0.6;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0xF4F4F6); 
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        } 
    }
    return _tableView;
}

@end

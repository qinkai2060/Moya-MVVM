//
//  SpCommentListDetailMainView.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpCommentListDetailMainView.h"
#import "SpProductCommentDetailTableViewCell.h"
#import "SpReplyCommentListTableViewCell.h"

@interface SpCommentListDetailMainView ()<UITableViewDelegate,UITableViewDataSource,SpProductCommentDetailTableViewCellDelegate,SpCommentDetailToolBarDelegate,SpReplyCommentListTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UILabel *NumLab;

@property (nonatomic, strong) NSMutableArray *commentDataSourceArr;

@property (nonatomic, assign) NSInteger currrentPage;

@property (nonatomic, assign) NSInteger replyTotalNum;

@end

@implementation SpCommentListDetailMainView
- (instancetype)initWithFrame:(CGRect)frame WithModel:(GetCommentListModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.commentListModel = model;
        [self createView];
        [self createToolBar];
    }
    return self;
}
- (void)createView{
    CGFloat buttomH = 0;
    if (IS_iPhoneX) {
        buttomH = 34;
    }
    //
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 46 - buttomH) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [self createTableViewTopView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:self.tableView];
}

// 刷新数据
- (void)refreshViewWithData:(NSMutableArray *)dataSource replyTotalNum:(NSInteger)replyTotalNum{
    self.commentDataSourceArr = [NSMutableArray arrayWithCapacity:1];
    self.commentDataSourceArr = dataSource;
    self.replyTotalNum = replyTotalNum;
    [self.tableView reloadData];
}

- (void)createToolBar{
    CGFloat buttomH = 0;
    if (IS_iPhoneX) {
        buttomH = 34;
    }
    //_commentToolBar
    _commentToolBar = [[SpCommentDetailToolBar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-[SpCommentDetailToolBar defaultHeight] - buttomH, ScreenW, [SpCommentDetailToolBar defaultHeight])];

    _commentToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _commentToolBar.delegate = self;

    __weak  typeof (self)weakSelf = self;
    _commentToolBar.sendBtnClick = ^(NSString * _Nonnull sendStr) {
        NSLog(@"%@",sendStr);
        if ([weakSelf.delegate respondsToSelector:@selector(sendReplyContentWithText:)]) {
            [weakSelf.delegate sendReplyContentWithText:sendStr];
        }        
    };
    
    [self addSubview:_commentToolBar];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + self.commentDataSourceArr.count;
}

// 创建tableview的headerView
- (UIView *)createTableViewTopView{
    SpProductCommentDetailTableViewCell *view = [[SpProductCommentDetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [SpProductCommentDetailTableViewCell cellHeightWithModel:self.commentListModel])];
    view.delegate = self;
    [view refreshDetailCellWithModel:self.commentListModel];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){ // 显示几条回复
        UITableViewCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        if (topCell == nil) {
            topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
        }
        topCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [topCell.contentView addSubview:[self createTopView]];
        self.NumLab.text = [NSString stringWithFormat:@"%ld条回复",self.replyTotalNum];
        return topCell;

    } else { // 回复列表
        SpReplyCommentListTableViewCell *replyCell = [tableView dequeueReusableCellWithIdentifier:@"replyCell"];
        if (replyCell == nil) {
            replyCell = [[SpReplyCommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"replyCell"];
            replyCell.delegate = self;
        }
        replyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.commentDataSourceArr.count > indexPath.row - 1) {
            GetCommentListModel *model = self.commentDataSourceArr[indexPath.row - 1];
            model.cellIndex = indexPath.row;
            [replyCell refreshCellWithModel:model];
        }
        return replyCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 40;
    } else {
        if (_commentDataSourceArr.count > indexPath.row - 1) {
            GetCommentListModel  *listModel = _commentDataSourceArr[indexPath.row - 1];
            return [SpReplyCommentListTableViewCell cellHeightWithModel:listModel];
        } else {
            return 0.0;
        }
    }
}

/**
 点击图片预览
 @param imageIndex cell中图片下标
 */
-(void)CommentListUserTapImageViewWithCellImageViewsIndex:(NSInteger)imageIndex{
    if ([self.delegate respondsToSelector:@selector(CommentListMainUserTapImageViewWithCellImageViewsIndex:commentListModel:)]) {
        [self.delegate CommentListMainUserTapImageViewWithCellImageViewsIndex:imageIndex commentListModel:self.commentListModel];
    }
}

- (UIView *)createTopView{
    //
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    topView.backgroundColor= [UIColor whiteColor];
    
    //
    self.NumLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 39)];
    self.NumLab.font = [UIFont boldSystemFontOfSize:14.0];
    self.NumLab.text = [NSString stringWithFormat:@"%ld条回复",self.commentDataSourceArr.count];
    [topView addSubview:self.NumLab];
    
    return topView;
}

/**
 点赞
 @param index 点击行数
 */
- (void)CommentListZanBtnClickWithIndex:(NSInteger)index andCircleCell:(SpReplyCommentListTableViewCell *)circleCell{
    if (_commentDataSourceArr.count > index - 1) {
        GetCommentListModel  *model = _commentDataSourceArr[index - 1];
        NSString *zanNum ;
        
        if ([[NSString stringWithFormat:@"%@",model.isLike] isEqualToString:@"0"]) {
            zanNum = @"1";
            circleCell.zanBtn.selected = YES;
            
            [circleCell.zanBtn setImage:[UIImage imageNamed:@"appreciate_fill_light"] forState:UIControlStateSelected];
            long zanCount = [model.commentLikeCount longLongValue];
            if (zanCount > 99) {
                model.likesNum = @" 99+";
            } else {
                if (zanCount + 1 > 99) {
                    model.likesNum = @" 99+";
                } else {
                    model.likesNum = [NSString stringWithFormat:@" %lld",[model.likesNum longLongValue] + 1];
                }
            }
            [circleCell.zanBtn setTitle:model.likesNum forState:UIControlStateSelected];
            model.isLike = @"1";
        } else if ([[NSString stringWithFormat:@"%@",model.isLike] isEqualToString:@"1"]){
            zanNum = @"-1";
            circleCell.zanBtn.selected = NO;
            [circleCell.zanBtn setImage:[UIImage imageNamed:@"appreciate_light"] forState:UIControlStateNormal];
            long zanCount = [model.commentLikeCount longLongValue];
            if (zanCount > 99) {
                model.likesNum = @" 99+";
            } else {
                if (zanCount - 1 > 99){
                    model.likesNum = @" 99+";
                } else {
                    model.likesNum = [NSString stringWithFormat:@" %lld",[model.likesNum longLongValue] - 1];
                }
            }
            [circleCell.zanBtn setTitle:model.likesNum forState:UIControlStateNormal];
            model.isLike = @"0";
        }
        
        if ([self.delegate respondsToSelector:@selector(CommentListZanBtnClickWithIndex:zanNum:model:)]) {
            [self.delegate CommentListZanBtnClickWithIndex:index zanNum:zanNum model:model];
        }
    }
}

@end

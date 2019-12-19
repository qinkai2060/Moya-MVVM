//
//  SpProductCommentListMainView.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpProductCommentListMainView.h"
#import "SpProductCommentListTableViewCell.h"

@interface SpProductCommentListMainView()<UITableViewDelegate,UITableViewDataSource,SpProductCommentListTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SpProductCommentListMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.tableView];
}

// 刷新数据
- (void)refreshViewWithData:(NSMutableArray *)dataSource{
    self.dataSource = [NSMutableArray arrayWithCapacity:1];
    self.dataSource = dataSource;
    [self.tableView reloadData];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SpProductCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (cell == nil) {
        cell = [[SpProductCommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (_dataSource.count > indexPath.row) {
        GetCommentListModel *model = _dataSource[indexPath.row];
        model.cellIndex = indexPath.row;
        [cell refreshCellWithModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(commentListMainTabelViewDidSelectedWithIndexRow:)]) {
        [self.delegate commentListMainTabelViewDidSelectedWithIndexRow:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource.count > indexPath.row) {
        GetCommentListModel *model = _dataSource[indexPath.row];
        return [SpProductCommentListTableViewCell cellHeightWithModel:model];
    }
    return 0.0;
}

#pragma mark cell代理方法
/**
 点击图片预览
 @param indexRow   cell下标
 @param imageIndex cell中图片下标
 */
-(void)CommentListUserTapImageViewWithIndex:(NSInteger)indexRow withCellImageViewsIndex:(NSInteger)imageIndex{
    if ([self.delegate respondsToSelector:@selector(CommentListMainUserTapImageViewWithIndex:withCellImageViewsIndex:)]) {
        [self.delegate CommentListMainUserTapImageViewWithIndex:indexRow withCellImageViewsIndex:imageIndex];
    }
}

/**
 评论
 @param index 点击行数
 */
- (void)CommentListCommentBtnClickWithIndex:(NSInteger)index andCircleCell:(SpProductCommentListTableViewCell *)circleCell{
    if ([self.delegate respondsToSelector:@selector(CommentListMainCommentBtnClickWithIndex:)]) {
        [self.delegate CommentListMainCommentBtnClickWithIndex:index];
    }
}

/**
 点赞
 @param index 点击行数
 */
- (void)CommentListZanBtnClickWithIndex:(NSInteger)index andCircleCell:(SpProductCommentListTableViewCell *)circleCell{    
    if (_dataSource.count > index) {
        GetCommentListModel *model = _dataSource[index];
        NSString *zanNum = @"";
        
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
        
        if ([self.delegate respondsToSelector:@selector(commentListZanBtnClickWithIndex:zanNum:model:)]) {
            [self.delegate commentListZanBtnClickWithIndex:index zanNum:zanNum model:model];
        }
    }
}

@end


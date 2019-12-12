//
//  WARFriendCommentMoreCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import "WARFriendCommentMoreCell.h"
#import "WARMacros.h"

@interface WARFriendCommentMoreCell()
@property (nonatomic, strong) UIButton* showMore;

@end

@implementation WARFriendCommentMoreCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.showMore];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.showMore.frame = self.bounds;
}

- (UIButton *)showMore{
    if (!_showMore) {
        _showMore = [UIButton buttonWithType:UIButtonTypeCustom];
        _showMore.titleLabel.font = [UIFont systemFontOfSize:14];
        _showMore.titleLabel.textColor = RGB(83, 125, 195);
        [_showMore setTitleColor:RGB(83, 125, 195) forState:UIControlStateNormal];
        _showMore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _showMore
        //        [_showMore setImage:[WARCommentsTool commentsGetImg:@"tweet_comment_more"] forState:UIControlStateNormal];
        _showMore.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        @weakify(self)
//        [[_showMore rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//            @strongify(self)
//            if(self.showMoreComments){
//                self.showMoreComments(self, self.layout.comment);
//            }
//        }];
    }
    return _showMore;
}
@end

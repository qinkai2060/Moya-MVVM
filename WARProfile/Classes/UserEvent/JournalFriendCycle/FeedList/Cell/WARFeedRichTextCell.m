//
//  WARFeedRichTextCell.m
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import "WARFeedRichTextCell.h"

@interface WARFeedRichTextCell ()
/** 文本 */
@property (nonatomic, strong) YYLabel *contentLabel;
@end

@implementation WARFeedRichTextCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedRichTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedRichTextCell"];
    if (!cell) {
        cell = [[[WARFeedRichTextCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedRichTextCell"];
    }
    return cell;
}


- (void)setupSubViews{
    
    [super setupSubViews];

    [self.contentView addSubview:self.contentLabel];
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(1, 5, 0, 0));
//    }];
}


- (void)setLayout:(WARFeedComponentLayout *)layout{
    
    [super setLayout:layout];
    
    self.contentLabel.textLayout = nil;
    self.contentLabel.textLayout = layout.textLayout;
    
    CGFloat contentLabelY = 1;
    if (layout.isMultilPage || self.hasTopMargin) {
        contentLabelY = 5;
    } else {
        contentLabelY = 1;
    }
    
    self.contentLabel.frame = CGRectMake(5, contentLabelY, layout.textLayout.textBoundingSize.width, layout.textLayout.textBoundingSize.height);
}

- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.left = 5;
        _contentLabel.width = kScreenWidth - 30;
        _contentLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _contentLabel.displaysAsynchronously = YES;
        _contentLabel.ignoreCommonProperties = YES;
        _contentLabel.fadeOnAsynchronouslyDisplay = NO;
        _contentLabel.fadeOnHighlight = NO;
        _contentLabel.textColor = [UIColor colorWithHexString:@"141414"];
        _contentLabel.font = [UIFont systemFontOfSize:14];
//        _contentLabel.backgroundColor = [UIColor redColor];
        @weakify(self)
        _contentLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            @strongify(self)
//            if ([self.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
//                [self.delegate cell:self didClickInLabel:(YYLabel *)containerView textRange:range];
//            }
        };
    }
    return _contentLabel;
}

@end

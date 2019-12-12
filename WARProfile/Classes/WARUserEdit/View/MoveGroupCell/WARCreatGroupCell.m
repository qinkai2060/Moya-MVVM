//
//  WARCreatGroupCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/16.
//

#import "WARCreatGroupCell.h"
#import "Masonry.h"
@implementation WARCreatGroupCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.groupView];
        [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (WARGroupView *)groupView{
    if (!_groupView) {
        _groupView = [[WARGroupView alloc] initWithType:WARGroupViewTypeNewCreatGroup];
    }
    return _groupView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

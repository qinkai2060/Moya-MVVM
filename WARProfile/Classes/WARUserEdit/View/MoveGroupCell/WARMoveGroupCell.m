//
//  WARMoveGroupCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/14.
//

#import "WARMoveGroupCell.h"
#import "Masonry.h"
#import "WARMacros.h"

@implementation WARMoveGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview: self.groupView];
        [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)setUI{
    
}
- (WARGroupView *)groupView{
    if (!_groupView) {
        _groupView = [[WARGroupView alloc] initWithType:WARGroupViewTypeMove];
    }
    return _groupView;
}
@end

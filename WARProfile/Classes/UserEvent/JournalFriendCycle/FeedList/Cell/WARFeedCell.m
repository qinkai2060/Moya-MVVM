//
//  WARFeedCell.m
//  WARControl
//
//  Created by helaf on 2018/4/25.
//

#import "WARFeedCell.h"

@implementation WARFeedCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedCell"];
    if (!cell) {
        cell = [[[WARFeedCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedCell"];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupSubViews];
        
    }
    return self;
}


- (void)setLayout:(WARFeedComponentLayout *)layout{
    
    _layout = layout;
    
    
}


/**
 子类重写
 */
- (void)setupSubViews {
    
    
    
}

@end

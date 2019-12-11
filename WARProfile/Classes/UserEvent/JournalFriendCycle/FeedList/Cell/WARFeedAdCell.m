//
//  WARFeedAdCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/26.
//

#import "WARFeedAdCell.h"

@interface WARFeedAdCell()

@end

@implementation WARFeedAdCell

#pragma mark - System

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WARFeedAdCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WARFeedAdCell"];
    if (!cell) {
        cell = [[[WARFeedAdCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WARFeedAdCell"];
    }
    return cell;
}

- (void)setupSubViews{
    [super setupSubViews];
    
}
  
#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Setter And Getter

@end

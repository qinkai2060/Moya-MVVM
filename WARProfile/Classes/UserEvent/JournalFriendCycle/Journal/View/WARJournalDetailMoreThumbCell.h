//
//  WARFriendDetailMoreThumbCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/15.
//

#import <UIKit/UIKit.h>


#define kWARJournalDetailMoreThumbCellHeight 36
 
@interface WARJournalDetailMoreThumbCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configPraiseCount:(NSInteger)count;

@end

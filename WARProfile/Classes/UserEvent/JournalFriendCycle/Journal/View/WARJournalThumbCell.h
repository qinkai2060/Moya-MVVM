//
//  WARJournalThumbCell.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/13.
//

#import <UIKit/UIKit.h>
@class WARJournalThumbCell,WARThumbModel;

@protocol WARJournalThumbCellDelegate <NSObject>
-(void)journalThumbCell:(WARJournalThumbCell *)journalThumbCell  didThumber:(NSString *)accountId;
-(void)journalThumbCell:(WARJournalThumbCell *)journalThumbCell  didOpenThumber:(BOOL)openThumber;
@end


@interface WARJournalThumbCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)hideBottomLine:(BOOL)hide;

/** delegate */
@property (nonatomic, weak) id<WARJournalThumbCellDelegate> delegate;

@property (nonatomic, strong) WARThumbModel *thumbModel;

@end

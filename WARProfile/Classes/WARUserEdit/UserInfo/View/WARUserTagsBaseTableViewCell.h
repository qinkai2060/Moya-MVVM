//
//  WARUserTagsTableViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import <UIKit/UIKit.h>

@interface WARUserTagsBaseTableViewCell : UITableViewCell

- (void)initUI;

@end


@interface WARUserTagsTableViewCell : WARUserTagsBaseTableViewCell

- (void)configureDataArr:(NSArray *)dataArr title:(NSString *)title;

@end


@interface WARUserNoTagsTableViewCell : WARUserTagsBaseTableViewCell

- (void)configureTitle:(NSString *)title describeText:(NSString *)describeText;

@end

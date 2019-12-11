//
//  WARIgnoreUserLiseCell.h
//  Pods
//
//  Created by huange on 2017/8/10.
//
//

#import <UIKit/UIKit.h>

#import "MGSwipeTableCell.h"

@protocol WARIgnoreUserListCellDelegate;

@interface WARIgnoreUserListCell : MGSwipeTableCell

@property (nonatomic, strong) UIButton *deleteActionButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *solarImageView;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, weak) id <WARIgnoreUserListCellDelegate> ignoreListCellDelegate;

- (void)setEditingWidthAnimation:(BOOL)isEditing animation:(BOOL)animation ;

@end


@protocol WARIgnoreUserListCellDelegate <NSObject>

- (void)rightDeleteButtonAction:(NSIndexPath *)indexPath;
- (void)leftDeleteButtonAction:(NSIndexPath *)indexPath;

@end

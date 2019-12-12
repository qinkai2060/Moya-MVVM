//
//  WARUserDiaryForTopRankCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import <UIKit/UIKit.h>

@class WARUserDiaryModel;

typedef void(^WARUserDiaryHeaderViewDidClickInputPhotosBlock)(NSArray *photos);

@interface WARUserDiaryHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy)WARUserDiaryHeaderViewDidClickInputPhotosBlock didClickInputPhotosBlock;


- (void)configureModel:(WARUserDiaryModel *)model;
@end

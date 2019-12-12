//
//  WARUserDiaryPhotosTableViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/25.
//

#import <UIKit/UIKit.h>

@class WARUserDiaryEventModel;

@interface WARUserDiaryPhotosTableViewCell : UITableViewCell

- (void)configureModel:(WARUserDiaryEventModel *)model;

@end

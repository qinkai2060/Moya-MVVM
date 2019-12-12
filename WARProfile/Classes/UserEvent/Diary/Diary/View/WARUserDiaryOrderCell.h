//
//  WARUserDiaryOrderCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import <UIKit/UIKit.h>
#import "WARUserDiaryBaseTableViewCell.h"


@class WARUserDiaryEventModel;

@interface WARUserDiaryOrderCell : WARUserDiaryBaseTableViewCell

- (void)configureModel:(WARUserDiaryEventModel *)model;

@end

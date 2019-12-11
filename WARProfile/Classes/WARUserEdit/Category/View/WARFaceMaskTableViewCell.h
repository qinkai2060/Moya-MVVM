//
//  WARFaceMaskTableViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/26.
//

#import <UIKit/UIKit.h>

@class WARFaceMaskModel;

@interface WARFaceMaskTableViewCell : UITableViewCell
- (void)configureFaceMaskModel:(WARFaceMaskModel *)faceMaskModel;

@end


@interface WARNoFaceMaskTableViewCell : UITableViewCell

@end

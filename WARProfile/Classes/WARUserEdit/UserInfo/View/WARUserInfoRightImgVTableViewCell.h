//
//  WARUserInfoRightImgVTableViewCell.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/29.
//

#import <UIKit/UIKit.h>

@interface WARUserInfoRightImgVTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *rightMoreImgV;
- (void)configureContentStr:(NSString *)contentStr;
@end

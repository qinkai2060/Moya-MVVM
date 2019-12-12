//
//  WARProfileDataCenterView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/6/21.
//

#import <UIKit/UIKit.h>

@interface WARProfileDataTagCenterView : UIView
@property(nonatomic,assign)CGFloat maxY;
-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array;
@end

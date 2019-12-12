//
//  WARTagView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/19.
//

#import <UIKit/UIKit.h>
#import "LGAlertView.h"
typedef NS_ENUM(NSInteger, WARTagViewViewType) {
    WARTagViewViewTypeDefualt,
    WARTagViewViewTypeTag,

    
};
@interface WARTagView : UIView<LGAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,assign)CGFloat maxY;
-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array atType:(WARTagViewViewType)type;
- (void)settingTagStr:(NSString *)type;
@end

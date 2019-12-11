//
//  WARProfileDataCenterView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/21.
//

#import "WARProfileDataTagCenterView.h"
#import "WARConfigurationMacros.h"
#import "WARMacros.h"
#import "WARAlertView.h"
#import "LGAlertViewTextField.h"
#import "UIImage+WARBundleImage.h"
#import "WARProgressHUD.h"
#import "UIView+BlockGesture.h"

@implementation WARProfileDataTagCenterView

-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array {
    if (self = [super initWithFrame:frame]) {
        self.maxY = 0;
        UIButton *recordBtn =nil;
        if (array.count > 0) {
            for (int i = 0; i < array.count; i ++)
            {
                NSString *name = array[i];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width , 14) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
                CGFloat BtnW = rect.size.width + 12;
                CGFloat BtnH = rect.size.height + 6;
                btn.layer.borderColor = [ThreeLevelTextColor CGColor];
                btn.layer.cornerRadius = 3;
                btn.layer.masksToBounds = YES;
                //设置边框宽度
                btn.layer.borderWidth = 1.0f;
                btn.layer.masksToBounds = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                
                if (BtnW >= self.frame.size.width) {
                    BtnW = self.frame.size.width;
                }
                if (i == 0) {
                    btn.frame =CGRectMake(0, 0, BtnW, BtnH);
                }else {
                    CGFloat yuWidth = self.frame.size.width  -recordBtn.frame.origin.x -recordBtn.frame.size.width;
                    if (yuWidth >= BtnW) {
                        btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 8, recordBtn.frame.origin.y, BtnW, BtnH);
                    }else{
                        btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+8, BtnW, BtnH);
                    }
                }
                [btn setTitle:name forState:UIControlStateNormal];
                [btn setTitleColor:ThemeColor forState:UIControlStateSelected];
                [btn setTitleColor:ThreeLevelTextColor forState:UIControlStateNormal];
                
                [self addSubview:btn];
                self.maxY = CGRectGetMaxY(btn.frame);
                recordBtn = btn;
                btn.tag = 100 + i;
            }
        }
    }
    return self;
    
}
@end

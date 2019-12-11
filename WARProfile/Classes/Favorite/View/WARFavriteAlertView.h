//
//  WARFavriteAlertView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import <UIKit/UIKit.h>

@interface WARFavriteAlertView : UIView
/**centerV*/
@property (nonatomic,strong) UIView *centerV;
/**title*/
@property (nonatomic,strong) UILabel *titlelb;
/**textfied*/
@property (nonatomic,strong) UITextField *textFiled;
/**line*/
@property (nonatomic,strong) UIView *lineHerV;
/**line*/
@property (nonatomic,strong) UIView *lineVerV;
/**cancelBtn*/
@property (nonatomic,strong) UIButton *cancelBtn;
/**sureBtn*/
@property (nonatomic,strong) UIButton *sureBtn;
@end

//
//  WARPhotoMiaoshuKeyView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/12.
//

#import "WARPhotoMiaoshuKeyView.h"
#import "WARMacros.h"
#import "UIColor+WARCategory.h"
@implementation WARPhotoMiaoshuKeyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        
        [self addSubview:self.textFiedView];
        self.textFiedView.frame = CGRectMake(5, 5, kScreenWidth-10,36);
    }
    return self;
}

- (UITextField *)textFiedView{
    if (!_textFiedView) {
        _textFiedView = [[UITextField alloc]init];
        _textFiedView.font = [UIFont systemFontOfSize:16];
     
 
       // _textFiedView.hidden = YES;
        _textFiedView.returnKeyType =  UIReturnKeySend;
        _textFiedView.backgroundColor=[UIColor whiteColor];
        _textFiedView.layer.cornerRadius = 3;
        _textFiedView.layer.masksToBounds = YES;
        
    }
    return _textFiedView;
}
@end

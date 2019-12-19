//
//  HFCollectionView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFTableViewnView.h"

@implementation HFTableViewnView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (otherGestureRecognizer.view.tag == 10000 ||otherGestureRecognizer.view.tag == -1000 || otherGestureRecognizer.view.tag == -10002 ) {
        return NO;
    }else {
        return YES;
    }
    
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
       
        self.noContentLb.frame = CGRectMake(0,self.centerY+10, ScreenW, 30);
        self.noContentView.frame = CGRectMake((ScreenW-300)*0.5, self.centerY-200-10, 300, 200);
        [self addSubview:self.noContentLb];
        [self addSubview:self.noContentView];
    }
    return self;
}
- (void)setErrorImage:(NSString *)imageStr text:(NSString*)textStr {
    self.noContentView.image = [UIImage imageNamed:erroImageStr];
    self.noContentLb.text = textStr;
    self.noContentLb.hidden = NO;
    self.noContentView.hidden = NO;
}
- (void)haveData {
    self.noContentLb.hidden = YES;
    self.noContentView.hidden = YES;
}

- (UIImageView *)noContentView {
    if (!_noContentView) {
        _noContentView = [[UIImageView alloc] init];
        _noContentView.image = [UIImage imageNamed:@"SpType_search_noContent"];
        _noContentView.hidden = YES;
        _noContentView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noContentView;
}
- (UILabel *)noContentLb {
    if (!_noContentLb) {
        _noContentLb = [[UILabel alloc] init];
        _noContentLb.textAlignment = NSTextAlignmentCenter;
        _noContentLb.textColor = [UIColor colorWithHexString:@"999999"];
        _noContentLb.font = [UIFont systemFontOfSize:16];
        _noContentLb.hidden = YES;
        _noContentLb.text = @"抱歉,这个星球暂时找不到";
    }
    return _noContentLb;
}
@end

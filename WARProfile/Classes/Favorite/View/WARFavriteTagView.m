//
//  WARFavriteTagView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/4.
//

#import "WARFavriteTagView.h"
#import "WARConfigurationMacros.h"
#import "WARMacros.h"
#import "WARAlertView.h"
#import "LGAlertViewTextField.h"
#import "UIImage+WARBundleImage.h"
#import "WARProgressHUD.h"
#import "UIView+BlockGesture.h"
@implementation WARFavriteTagView

-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array {
    
    if (self = [super initWithFrame:frame]) {
        for (UIView *v in self.scroller.subviews) {
            [v removeFromSuperview];
        }
        
        [self.array addObjectsFromArray:array];
        self.maxY = 0;
        [self addSubview:self.scroller];
        UIButton *recordBtn =nil;
        if (self.array.count > 0) {
            
            
            for (int i = 0; i < self.array.count; i ++)
            {

                
                NSString *name = self.array[i];
                
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width , 14) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
                
                CGFloat BtnW = rect.size.width + 14;
                CGFloat BtnH = rect.size.height + 6;
                btn.layer.borderColor = [DisabledTextColor CGColor];
                btn.layer.cornerRadius =3;
                btn.layer.masksToBounds = YES;
                //设置边框宽度
                btn.layer.borderWidth = 1.0f;
                btn.layer.masksToBounds = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                
                if (BtnW >= self.frame.size.width) {
                    BtnW = self.frame.size.width;
                }
                if (i == 0) {
                    
                    btn.frame =CGRectMake(0, 0, 50, BtnH);
                    [btn setTitle:@"" forState:UIControlStateNormal];
                    [btn setImage:[UIImage war_imageName:@"personal_collect_set_add" curClass:[self class] curBundle:@"WARProfile.bundle"] forState:UIControlStateNormal];
         
                }else {
                    CGFloat yuWidth = self.frame.size.width  -recordBtn.frame.origin.x -recordBtn.frame.size.width;
                    
                    
                    if (yuWidth >= BtnW) {
                        
                        btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 13, recordBtn.frame.origin.y, BtnW, BtnH);
                    }else{
                        
                        btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+13, BtnW, BtnH);
                    }
                    [btn setTitle:name forState:UIControlStateNormal];
             
                }
                
                [btn setTitleColor:ThemeColor forState:UIControlStateSelected];
                [btn setTitleColor:DisabledTextColor forState:UIControlStateNormal];
           
                [self.scroller addSubview:btn];
                
                if (btn.frame.origin.y>30) {
                    btn.hidden= NO;
                }
                self.maxY = CGRectGetMaxY(btn.frame);
                recordBtn = btn;
                
                btn.tag = 100 + i;
                [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
                WS(weakself);
                [btn addLongPressActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                    if (i != 0) {
                        UIButton *btn = gestureRecoginzer.view;
                        [weakself.array removeObject:btn.currentTitle];
                        [weakself reloadData];
                    }
      
                }];
                
                if (i == 1) {
                    btn.selected = YES;
                    self.selectBtn = btn;
                    self.selectBtn.layer.borderColor = [ThemeColor CGColor];
                }
                
                
            }
            self.scroller.frame = CGRectMake(0, 0, kScreenWidth, 240);

            self.scroller.contentSize = CGSizeMake(self.frame.size.width, self.maxY);
            
        }
    }
    
    
    return self;
    
}

-(void) BtnClick:(UIButton *)sender{
    
    WS(weakSelf);
    
    
    if ([sender.currentTitle isEqualToString:@""]) {
        
        [[LGAlertView alertViewWithTextFieldsAndTitle:@"编辑书签" message:nil numberOfTextFields:1 textFieldsSetupHandler:^(UITextField * _Nonnull textField, NSUInteger index) {

        } buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {

            NDLog(@"");
        } cancelHandler:^(LGAlertView * _Nonnull alertView) {

            NDLog(@"");
        } destructiveHandler:^(LGAlertView * _Nonnull alertView) {
            LGAlertViewTextField *textField  =  [alertView.textFieldsArray firstObject];
            if (textField.text.length == 0) {
                [WARProgressHUD showAutoMessage:@"不能为空"];
            }else{
                [weakSelf.array insertObject:textField.text atIndex:1];
                [weakSelf reloadData];
            }
//            [weakSelf.array removeObjectAtIndex:weakSelf.array.count-1];
          
            NDLog(@"");
        }] show];
        
    }else {
        if([self.selectBtn isEqual:sender]) {
            return;
        }
        
        sender.selected = !sender.selected;
        NDLog(@"%s",__func__);
        if (self.selectBtn) {
            self.selectBtn.selected = NO;
            self.selectBtn.layer.borderColor = [DisabledTextColor CGColor];
            self.selectBtn = nil;
            
        }
        if (sender.selected) {
            
            self.selectBtn = sender;
            self.selectBtn.layer.borderColor = [ThemeColor CGColor];
            
        }
    }
}
- (void)reloadData {
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.array];
    [self.array removeAllObjects];
    [self initWithFrame:self.frame  dataArr:newArray];
}
- (void)settingTagStr:(NSString *)type{
    for (UIButton *btn in self.scroller.subviews) {
        if ([btn.currentTitle isEqualToString:type]) {
            if (self.selectBtn) {
                self.selectBtn.selected = NO;
                self.selectBtn.layer.borderColor = [DisabledTextColor CGColor];
                self.selectBtn = nil;
                
            }
            btn.selected = YES;
            self.selectBtn = btn;
            self.selectBtn.layer.borderColor = [ThemeColor CGColor];
            break;
        }else {
            self.selectBtn.selected = NO;
            self.selectBtn.layer.borderColor = [DisabledTextColor CGColor];
            self.selectBtn = nil;
            
        }
    }
}
- (NSMutableArray *)array {
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] init];
        
    }
    return _scroller;
}
@end

//
//  PersonInformationInputView.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "PersonInformationInputView.h"

@interface PersonInformationInputView()

@property (nonatomic,strong)UITextField *inputTextFiled;

@property (nonatomic,strong)UIButton *deleteBtn;

@end

@implementation PersonInformationInputView {
    
    NSString *_textMessage;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubView];
    }
    return self;
}

- (void)setSubView {
    
    UITextField *inputTextField = [UITextField new];
    self.inputTextFiled = inputTextField;
    [self addSubview:inputTextField];
    
    //设置光标
    UIView *cursorView = [UIView new];
    cursorView.frame = CGRectMake(0, 0, WScale(15), 2);
    self.inputTextFiled.leftView = cursorView;
    self.inputTextFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.inputTextFiled setTintColor:[UIColor colorWithHexString:@"#F3344A"]];
    self.inputTextFiled.textColor = [UIColor colorWithHexString:@"#333333"];
    
    UIButton *deleteBtn = [UIButton buttonWithType:0];
    self.deleteBtn = deleteBtn;
    [self addSubview:deleteBtn];
    [deleteBtn setImage:ImageLive(@"deleteBtn") forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(actionDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(WScale(45));
    }];
    
    [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.mas_equalTo(self);
        make.height.mas_equalTo(WScale(45));
        make.trailing.mas_equalTo(self.deleteBtn.mas_leading);
    }];
    
}

- (void)cancelKeyboard {
    
    [self.inputTextFiled resignFirstResponder];
}

- (UITextField *)inputFiled {
    return self.inputTextFiled;
}

- (NSString *)textMessage {
    
    if (self.inputTextFiled.text.length > 0) {
        return [self.inputTextFiled.text removingSapceString:self.inputTextFiled.text];
    }
    return @"";
}

- (void)setTextMessage:(NSString *)textMessage {
    _textMessage = textMessage;
    
    switch (self.currentType) {
        case PersonInformationType_Head:
        {
            
            break;
        }
        case PersonInformationType_Name:
        {
            
            break;
        }
        case PersonInformationType_Sex:
        {
            
            break;
        }
        case PersonInformationType_ContactPhone:
        {
            
            break;
        }
        case PersonInformationType_RefillPhone:
        {
            
            break;
        }
        case PersonInformationType_Email:
        {
            
            break;
        }
        case PersonInformationType_Address:
        {
            
            break;
        }
        case PersonInformationType_IDNumber:
        {
            
            break;
        }
        case PersonInformationType_IDPicture:
        {
            
            break;
        }
        case PersonInformationType_BankNubmer:
        {
            self.inputTextFiled.text = [textMessage groupedString:textMessage];
            
            break;
        }
            
        default:
            break;
    }
    
}

- (void)actionDeleteBtn:(UIButton *)sender {
    self.inputTextFiled.text = @"";
}

- (void)setKeyboardType:(UIKeyboardType )keyboardType {
    _keyboardType = keyboardType;
    self.inputTextFiled.keyboardType = keyboardType;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

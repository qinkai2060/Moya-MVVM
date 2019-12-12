//
//  WARGroupMangerCell.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/15.
//

#import "WARGroupMangerCell.h"
#import "Masonry.h"
#import "UIColor+WARCategory.h"
@implementation WARGroupMangerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview: self.groupView];
        [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.groupView.clearBtn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (self.model.canChangeName) {
        if (selected) {
            self.groupView.groupNamelb.textColor = [UIColor blackColor];
            self.groupView.clearBtn. hidden = NO;
            self.groupView.textfield.hidden = NO;
            self.groupView.groupNamelb.hidden = YES;
            [self.groupView.textfield becomeFirstResponder];
            
        }else{
            self.groupView.groupNamelb.textColor = [UIColor colorWithHexString:@"999999"];
            self.groupView.clearBtn. hidden = YES;
            self.groupView.textfield.hidden = YES;
            self.groupView.groupNamelb.hidden = NO;
            
        }
    }

    
}
- (void)clearClick:(UIButton*)btn{
    
}

- (void)setModel:(WARContactCategoryModel *)model{
    _model = model;
    if (model.defaultCategoryShowName.length) {
        self.groupView.groupNamelb.text = [NSString stringWithFormat:@"%@ (%zd)",model.defaultCategoryShowName,model.categoryNum];//;

    }else{
        self.groupView.groupNamelb.text = [NSString stringWithFormat:@"%@ (%zd)",model.categoryName,model.categoryNum];
  }
    self.groupView.textfield.text = self.groupView.groupNamelb.text;
}
- (WARGroupView *)groupView{
    if (!_groupView) {
        _groupView = [[WARGroupView alloc] initWithType:WARGroupViewTypeSort];
        _groupView.textfield.delegate = self;
    }
    return _groupView;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = self.model.categoryName;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *str = @"";
    if (self.model.defaultCategoryShowName.length) {
        str = self.model.defaultCategoryShowName;//;

    }else{
       str = self.model.categoryName;
   }
        self.groupView.textfield.text = str;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    BOOL isOriginal = YES;
    NSString *str =   [[self.groupView.groupNamelb.text componentsSeparatedByString:@" "] firstObject];
    if (![textField.text isEqualToString:str]) {
        isOriginal = NO;
        self.model.categoryName = textField.text;
        
    }else{
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(saveEditingGroupMangerCell:withModel:withOriginal:)]) {
        [self.delegate saveEditingGroupMangerCell:self withModel:self.model withOriginal:isOriginal];
    }
}
@end

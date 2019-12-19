//
//  ManageLogticsTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageLogticsTableViewCell.h"
#import "ManageLogticsListModel.h"
@interface ManageLogticsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView  *dotView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) ManageLogticsListModel * itemModel;

@end
@implementation ManageLogticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dotView.layer.masksToBounds = YES;
    self.dotView.layer.cornerRadius  = 2.5;
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    if(path.row == 0) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#F3344A"];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#F3344A"];
        self.dotView.backgroundColor = [UIColor colorWithHexString:@"#F3344A"];
    }else {
        self.dotView.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    self.itemModel = (ManageLogticsListModel  *)data;
    self.titleLabel.text = objectOrEmptyStr(self.itemModel.context);
    self.timeLabel.text = objectOrEmptyStr(self.itemModel.time);
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

+ (id)loadFromXib {
    ManageLogticsTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                 owner:self
                                                               options:nil][0];
    return cell;
}

- (ManageLogticsListModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[ManageLogticsListModel alloc]init];
    }
    return _itemModel;
}
@end

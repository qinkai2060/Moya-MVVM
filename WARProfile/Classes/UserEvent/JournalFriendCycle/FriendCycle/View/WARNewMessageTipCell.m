//
//  WARNewMessageTipCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/7.
//

#import "WARNewMessageTipCell.h"
#import "WARNewMessageTipView.h"
#import "WARMacros.h"

@interface WARNewMessageTipCell()
@property (nonatomic, strong) WARNewMessageTipView *messageTipView;
@end

@implementation WARNewMessageTipCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self.contentView addSubview:self.messageTipView];
}

- (void)configData:(NSDictionary *)dict {
    self.messageTipView.messageCount = [dict[@"messageCount"] integerValue];
    self.messageTipView.imageUrl = dict[@"imageUrl"];
}

- (WARNewMessageTipView *)messageTipView {
    if (!_messageTipView) {
        _messageTipView = [[WARNewMessageTipView alloc]init];
        _messageTipView.backgroundColor = [UIColor clearColor]; 
        _messageTipView.frame = CGRectMake(0, 0, kScreenWidth, 49);
    }
    return _messageTipView;
}

@end

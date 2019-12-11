//
//  WARJournalArrowCell.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/26.
//

#import "WARJournalArrowCell.h"
#import "WARMacros.h"
#import "WARThumbModel.h"
#import "UIImage+WARBundleImage.h"

@interface WARJournalArrowCell()
/** 箭头 */
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation WARJournalArrowCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        self.backgroundColor = kColor(whiteColor);
        
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI{
    
    [self.contentView addSubview:self.arrowImageView];
    
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        UIImage *image = [UIImage war_imageName:@"group_arrow" curClass:[self class] curBundle:@"WARProfile.bundle"];
        _arrowImageView = [[UIImageView alloc]init];
        _arrowImageView.frame = CGRectMake(20.5, 10, 11, 5.5);
        _arrowImageView.image = image;
    }
    return _arrowImageView;
}


@end

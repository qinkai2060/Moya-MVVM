//
//  STAddressLocationView.m
//  housebank
//
//  Created by liqianhong on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STAddressLocationView.h"

@interface STAddressLocationView ()

@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *addressLab;
@property (nonatomic, strong) UILabel *gpsLab;

@end

@implementation STAddressLocationView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        if (type == 1) {
            self.locationImageView.image = [UIImage imageNamed:@"location-icon"];
        }else {
           self.locationImageView.image = [UIImage imageNamed:@"SpTypes_search_addressMap"];
        }
    }
    return self;
}
- (void)createView{
    self.backgroundColor = [UIColor whiteColor];
    //
    self.locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height / 2 - 7.5, 11, 15)];
    self.locationImageView.image = [UIImage imageNamed:@"SpTypes_search_addressMap"];
    [self addSubview:self.locationImageView];
    
    //
    self.addressLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.locationImageView.frame) + 5, 0, 100, self.frame.size.height - 1)];
    self.addressLab.font = [UIFont systemFontOfSize:20.0];
    self.addressLab.textColor = RGBACOLOR(51, 51, 51, 1);
    [self addSubview:self.addressLab];
    
    //
    self.gpsLab =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.addressLab.frame) + 5, self.addressLab.frame.origin.y, 100, self.addressLab.frame.size.height)];
    self.gpsLab.textColor = RGBACOLOR(153, 153, 153, 1);
    self.gpsLab.font = [UIFont systemFontOfSize:13.0];
    self.gpsLab.text = @"GPS定位";
    [self addSubview:self.gpsLab];
    
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(13, CGRectGetMaxY(self.addressLab.frame), self.frame.size.width - 13, 1)];
    lineLab.backgroundColor = RGBACOLOR(229, 229, 229, 1);
    [self addSubview:lineLab];
}

- (void)refreshViewWithAddress:(NSString *)address{
    //
    CGFloat w = [MyUtil getWidthWithFont:[UIFont systemFontOfSize:20.0] height:40 text:address];
    CGRect adRect = self.addressLab.frame;
    adRect.size.width = w + 5;
    self.addressLab.frame = adRect;
    
    //
    CGRect gpsRect = self.gpsLab.frame;
    gpsRect.origin.x = CGRectGetMaxX(self.addressLab.frame)+ 5;
    self.gpsLab.frame = gpsRect;
    
    self.addressLab.text = address;
}


@end

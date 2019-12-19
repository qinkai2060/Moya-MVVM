//
//  WARGroupHomeTagView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/10.
//

#import "HFSPecialView.h"

@implementation HFSPecialView

- (instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array {
    array = @[@"绿色",@"红色",@"黄色"];
    if (self = [super initWithFrame:frame]) {
         UIButton *recordBtn = nil;
        for (int i = 0; i < array.count; i ++) {
            NSString *name = array[i];
         
            UIButton *btn = [[UIButton alloc] init];
           btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
            CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width, 11) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];

            CGFloat BtnW = rect.size.width + 15;
            CGFloat BtnH = rect.size.height + 6;
            btn.layer.cornerRadius = 10;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
            btn.layer.borderWidth = 1;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];

            if (BtnW >= self.frame.size.width) {
                BtnW = self.frame.size.width;
            }
            if (i == 0) {

                btn.frame =CGRectMake(0, 0, BtnW, BtnH);
            }else {
                CGFloat yuWidth = self.frame.size.width  -recordBtn.frame.origin.x -recordBtn.frame.size.width;
                if (yuWidth >= BtnW) {

                    btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 5, recordBtn.frame.origin.y, BtnW, BtnH);
                }else{

                    btn.frame =CGRectMake(0, recordBtn.frame.origin.y+recordBtn.frame.size.height+5, BtnW, BtnH);
                }
            }

            [btn setTitle:name forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [self addSubview:btn];


            recordBtn = btn;

            btn.tag = 100 + i;
            btn.selected = YES;
            self.maxY = CGRectGetMaxY(recordBtn.frame);
    
          

          //  [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];

        }
    }
    return self;
}

@end

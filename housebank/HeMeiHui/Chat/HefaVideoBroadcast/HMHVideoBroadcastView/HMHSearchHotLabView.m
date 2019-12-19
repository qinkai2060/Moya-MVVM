//
//  HMHSearchHotLabView.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/17.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHSearchHotLabView.h"
#import "HMHVideoTagsModel.h"
@interface HMHSearchHotLabView ()

@property (nonatomic, strong) NSMutableArray *HMH_dataSource;

@end

@implementation HMHSearchHotLabView

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)datasource{
    self = [super initWithFrame:frame];
    if (self) {
        self.HMH_dataSource = [[NSMutableArray alloc] initWithCapacity:1];
        self.HMH_dataSource = datasource;
        if (self.HMH_dataSource.count > 0) {
            [self createUI];
        }
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = RGBACOLOR(240, 241, 242, 1);
    //
    UILabel *hotLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200,40)];
    hotLab.font = [UIFont systemFontOfSize:16.0];
    hotLab.textColor = RGBACOLOR(70, 76, 78, 1);
    hotLab.text = @"热门标签";
    [self addSubview:hotLab];
    
    //
    CGFloat space = 10;
    int m = 3;//单行3列
    CGFloat imgvW = (ScreenW - 20 -space*(m-1))/m;
    for (int i=0; i<self.HMH_dataSource.count; i++) {
        HMHVideoTagsModel *model = _HMH_dataSource[i];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(space + (imgvW+space)*(i%m),40 + (imgvW / 2 - 10 +space)*(i/m), imgvW, imgvW / 2 - 10)];
        imgv.backgroundColor = RGBACOLOR(112, 112, 112, 1);
        imgv.clipsToBounds = YES;
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.layer.masksToBounds = YES;
        imgv.layer.cornerRadius = 5.0;
        
        [imgv sd_setImageWithURL:[model.tagIcon get_Image]];
        
       

        [self addSubview:imgv];
        
        //
        UILabel *plachLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imgv.frame.size.width, imgv.frame.size.height)];
        plachLab.backgroundColor = [UIColor blackColor];
        plachLab.alpha = 0.4;
        plachLab.userInteractionEnabled = YES;
        [imgv addSubview:plachLab];
        
        //
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, imgv.frame.size.width - 10, imgv.frame.size.height)];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14.0];
        lab.backgroundColor = [UIColor clearColor];
        lab.userInteractionEnabled = YES;
        lab.text = model.tagName;
        [imgv addSubview:lab];
        
        imgv.tag = 1000+i;
        imgv.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [imgv addGestureRecognizer:tap];
    }
}

//中间可变标签高度
+(CGFloat)getLabsHeightWithModel:(NSMutableArray *)dataSourceArr
{
    //内容高度
    CGFloat content_H=0.0;
    if(dataSourceArr.count > 0){
        CGFloat space = 5;
        int m = 3;//单行3列
        CGFloat imgvW = (ScreenW - 20 -space*(m-1))/m;
        //行数
        NSInteger lineCount = (dataSourceArr.count+2)/3;
        content_H = (imgvW / 2 - 10)*lineCount+space*(lineCount-1);
        
        return content_H + 45;
    }
    return 0.0;
}

//标签点击事件
-(void)imageTapAction:(UITapGestureRecognizer *)tap{
    NSInteger tapIndex = tap.view.tag - 1000;
    if ([self.delegate respondsToSelector:@selector(hotLabClickWithLabIndex:)]) {
        [self.delegate hotLabClickWithLabIndex:tapIndex];
    }
}


@end

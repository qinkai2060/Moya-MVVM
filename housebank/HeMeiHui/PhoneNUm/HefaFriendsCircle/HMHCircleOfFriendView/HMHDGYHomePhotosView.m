//
//  HMHDGYHomePhotosView.m
//  SalesCircle
//
//  Created by QianDeng on 16/12/30.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "HMHDGYHomePhotosView.h"



#define SelfMaxWidth  (ScreenW - 24)
#define oneimageWidth (ScreenW - 24 - 10 - 20)

@implementation HMHDGYHomePhotosView

- (id)initWithFrame:(CGRect)frame withCircleInfo:(HMHHeFaCircleOfFriendModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *imgArr = [model.pubMedia componentsSeparatedByString:@","];
        self.imageDataArray = imgArr;
        if (imgArr.count > 0) {
            if (imgArr.count == 1 && [imgArr[0] length] > 0) {//单张图
                
                UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,(SelfMaxWidth-5*(3-1))/3,(SelfMaxWidth-5*(3-1))/3)];
                imgv.clipsToBounds = YES;
                imgv.contentMode = UIViewContentModeScaleAspectFill;
                imgv.tag = 1000;
                imgv.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                [imgv addGestureRecognizer:tap];
                [imgv sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:@"circle_default_loading_error"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    imgv.width = (SelfMaxWidth-5*(3-1))/3;;
//                    imgv.width = self.frame.size.width;;
                }];
                [self addSubview:imgv];
                
            } else if(imgArr.count >1){///多张图片
                CGFloat space = 5;
                int m = 3;//单行3列
                CGFloat imgvW = (SelfMaxWidth-space*(m-1))/m;
                if (imgArr.count == 4) {
                    m = 2;//单行2列
                }
                for (int i=0; i<imgArr.count; i++) {
                    if (i==9) {//最多9张图
                        break;
                    }
                    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((imgvW+space)*(i%m),(imgvW+space)*(i/m), imgvW, imgvW)];
                    imgv.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                    imgv.clipsToBounds = YES;
                    imgv.contentMode = UIViewContentModeScaleAspectFill;
                    [imgv sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] placeholderImage:[UIImage imageNamed:@"circle_default_loading_error"]];
                    [self addSubview:imgv];
                    imgv.tag = 1000+i;
                    imgv.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                    [imgv addGestureRecognizer:tap];
                }
                
            }
        }
    }
    return self;
}

// 合发购  评论
- (id)initWithFrame:(CGRect)frame withHeFaShoppingCommentInfo:(GetCommentListModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < model.commentPictureList.count; i++) {
            NSDictionary *imageDic = model.commentPictureList[i];
            NSString *imageUrl = [imageDic[@"picPath"] get_sharImage];
            [imgArr addObject:imageUrl];
        }
        self.imageDataArray = imgArr;
        if (imgArr.count > 0) {
            if (imgArr.count == 1 && [imgArr[0] length] > 0) {//单张图
                
                UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,(SelfMaxWidth-5*(3-1))/3,(SelfMaxWidth-5*(3-1))/3)];
                imgv.clipsToBounds = YES;
                imgv.contentMode = UIViewContentModeScaleAspectFill;
                imgv.tag = 1000;
                imgv.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                [imgv addGestureRecognizer:tap];
                [imgv sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    imgv.width = (SelfMaxWidth-5*(3-1))/3;;
                    //                    imgv.width = self.frame.size.width;;
                }];
                [self addSubview:imgv];
                
            } else if(imgArr.count >1){///多张图片
                CGFloat space = 5;
                int m = 3;//单行3列
                CGFloat imgvW = (SelfMaxWidth-space*(m-1))/m;
//                if (imgArr.count == 4) {
//                    m = 2;//单行2列
//                }
                for (int i=0; i<imgArr.count; i++) {
                    if (i==9) {//最多9张图
                        break;
                    }
                    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((imgvW+space)*(i%m),(imgvW+space)*(i/m), imgvW, imgvW)];
                    imgv.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                    imgv.clipsToBounds = YES;
                    imgv.contentMode = UIViewContentModeScaleAspectFill;
                    [imgv sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
                    [self addSubview:imgv];
                    imgv.tag = 1000+i;
                    imgv.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                    [imgv addGestureRecognizer:tap];
                }
                
            }
        }
    }
    return self;
}


//中间可变内容高度 (内容+图片)
+(CGFloat)getPhotosHeightWithModel:(HMHHeFaCircleOfFriendModel *)model{
    //内容高度
    CGFloat content_H=0.0;
    //图片高度
    NSArray *imgArr = [model.pubMedia componentsSeparatedByString:@","];

    if (imgArr.count == 1  && [imgArr[0] length] > 0){//单张图片的高度最大为内容区域宽度的2/3（已取消）
        content_H = (SelfMaxWidth-5*(3-1))/3;
    } else if(imgArr.count > 1){
        CGFloat space = 5;
        int m = 3;//单行3列
        CGFloat imgvW = (SelfMaxWidth-space*(m-1))/m;
        //行数
        NSInteger lineCount = (imgArr.count+2)/3;
        if (lineCount > 3) {
            lineCount = 3;
        }
        content_H = imgvW*lineCount+space*(lineCount-1);
    }
    
    return content_H;
}

//中间可变内容高度 (内容+图片)
+(CGFloat)getHeFaShoppingCommentPhotosHeightWithModel:(GetCommentListModel *)model{
    //内容高度
    CGFloat content_H=0.0;
    //图片高度    
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < model.commentPictureList.count; i++) {
        NSDictionary *imageDic = model.commentPictureList[i];
        NSString *imageStr = imageDic[@"picPath"];
        if (imageStr.length > 0) {
           
           [imgArr addObject:[imageStr get_sharImage]];
        }
    }
    if (imgArr.count == 1  && [imgArr[0] length] > 0){//单张图片的高度最大为内容区域宽度的2/3（已取消）
        content_H = (SelfMaxWidth-5*(3-1))/3;
    } else if(imgArr.count > 1){
        CGFloat space = 5;
        int m = 3;//单行3列
        CGFloat imgvW = (SelfMaxWidth-space*(m-1))/m;
        //行数
        NSInteger lineCount = (imgArr.count+2)/3;
        if (lineCount > 3) {
            lineCount = 3;
        }
        content_H = imgvW*lineCount+space*(lineCount-1);
    }
    
    return content_H;
}


//图片点击事件
-(void)imageTapAction:(UITapGestureRecognizer *)tap{
    NSInteger tapIndex = tap.view.tag - 1000;
    if (self.imageTap) {
        self.imageTap(tapIndex);
    }
}

@end

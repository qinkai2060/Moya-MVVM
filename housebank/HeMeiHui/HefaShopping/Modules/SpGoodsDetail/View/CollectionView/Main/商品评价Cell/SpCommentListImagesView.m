//
//  SpCommentListImagesView.m
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpCommentListImagesView.h"


#define SelfMaxWidth  (ScreenW - 24)
#define oneimageWidth (ScreenH - 64 - 30)

@implementation SpCommentListImagesView

- (id)initWithFrame:(CGRect)frame withCircleInfo:(GetCommentListModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < model.commentPictureList.count; i++) {
            NSDictionary *imageDic = model.commentPictureList[i];
            NSString *imageUrl = [imageDic[@"picPath"] get_sharImage];
            [imgArr addObject:imageUrl];
        }
        self.imageDataArray = imgArr;
        if (imgArr.count > 0) {
            if (imgArr.count == 1 && [imgArr[0] length] > 0) {//单张图
                
                float imageHeight = 0.0;
                imageHeight = [[self class] heightForImage:imgArr[0]];
                if (!imageHeight) {
                    imageHeight = oneimageWidth*2/3;
                }
                
                //
                UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,oneimageWidth*2/3,imageHeight)];
                imgv.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                imgv.clipsToBounds = YES;
                imgv.contentMode = UIViewContentModeScaleAspectFit;
                imgv.tag = 1000;
                imgv.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                [imgv addGestureRecognizer:tap];
                
                [imgv sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    imgv.width = self.frame.size.width;
                }];
                [self addSubview:imgv];
                
            } else if(imgArr.count >1){///多张图片
                
                for (int i=0; i<imgArr.count; i++) {
                    if (i==9) {//最多9张图
                        break;
                    }
                    
                    float imageHeight = 0.0;
                    float lastImageButtomY = 0.0;
                    // 获取图片的高度
                    imageHeight = [[self class] heightForImage:imgArr[i]];
                    // 获取前一张图片的最大y值 用来布局
                    if (i>0) {
                        UIView*lastImageView = [self viewWithTag:1000+i-1];
                        if (lastImageView) {
                            lastImageButtomY = lastImageView.buttomY + 10;
                        }
                    }
                    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0,lastImageButtomY, oneimageWidth*2/3, imageHeight)];
                    
                    imgv.backgroundColor = RGBACOLOR(240, 240, 240, 1);
                    imgv.clipsToBounds = YES;
                    imgv.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [imgv sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        imgv.width = self.frame.size.width;
                    }];
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




+(CGFloat)getPhotosHeightWithModel:(GetCommentListModel *)model{
    //内容高度
    CGFloat content_H=0.0;
    //图片高度
    //        NSArray *imgArr = model.commentPictureList;
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < model.commentPictureList.count; i++) {
        NSDictionary *imageDic = model.commentPictureList[i];
        NSString *imageStr = imageDic[@"picPath"];
        [imgArr addObject:[imageStr get_sharImage]];
        
    }
    if (imgArr.count == 1  && [imgArr[0] length] > 0){//单张图片的高度最大为内容区域宽度的2/3
        
        content_H = [[self class] heightForImage:imgArr[0]];
        
    } else if(imgArr.count > 1){
        //        content_H = (oneimageWidth*2/3) * imgArr.count + 10 * imgArr.count;
        
        for (int i = 0; i < imgArr.count; i++) {
            content_H = content_H + [[self class] heightForImage:imgArr[i]];
        }
        content_H = content_H + 10*imgArr.count;
    }
    
    return content_H;
}


#pragma mark 根据图片url 截取图片的宽高 如果没有 则返回默认高度
+ (CGFloat)heightForImage:(NSString *)imageUrl{
    

    if (imageUrl.length > 0) {
//        NSRange loRange = [imageUrl rangeOfString:@"?"];//匹配得到的下标
//        if (imageUrl.length >= loRange.location + 1) {
//            NSString *wAndhHStr =  [imageUrl substringFromIndex:loRange.location+1]; // 宽和高
//            NSArray *widthAndHArr = [wAndhHStr componentsSeparatedByString:@"*"];
            // 若 图片后面不传给 宽和高 就自己计算 目前是自己计算
//            NSURL *imgUrl = [NSURL URLWithString:imageUrl];
//            NSData *imageData = [NSData dataWithContentsOfURL:imgUrl];
//            UIImage *image = [UIImage imageWithData:imageData];
//            NSArray *widthAndHArr = @[[NSNumber numberWithFloat:image.size.width],[NSNumber numberWithFloat:image.size.height]];
//            NSLog(@"w = %f,h = %f",image.size.width,image.size.height);

      CGSize imageSize = [MyUtil getImageSizeWithURL:imageUrl];
        
        NSArray *widthAndHArr = @[[NSNumber numberWithFloat:imageSize.width],[NSNumber numberWithFloat:imageSize.height]];
            
            CGFloat scale ;
            float imageHeight;
            if (widthAndHArr.count >=2) {
                scale = (oneimageWidth*2/3) / [widthAndHArr[0] floatValue];
                imageHeight = [widthAndHArr[1] floatValue] *scale - 5;
            } else {
                imageHeight = oneimageWidth*2/3;
            }
            return imageHeight;
        }
//    }
    return oneimageWidth*2/3;
}




//图片点击事件
-(void)imageTapAction:(UITapGestureRecognizer *)tap{
    NSInteger tapIndex = tap.view.tag - 1000;
    if (self.imageTap) {
        self.imageTap(tapIndex);
    }
}
@end

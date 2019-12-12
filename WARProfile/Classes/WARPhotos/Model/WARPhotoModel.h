//
//  WARPhotoModel.h
//  WARProfile
//
//  Created by 秦恺 on 2018/4/2.
//

#import <Foundation/Foundation.h>
typedef void(^ResultPath)(NSData *filePath, NSURL *url,NSString *fileName);
typedef void(^Result)(NSData *data, NSString *fileName);
@interface WARPhotoModel : NSObject
@property (nonatomic,copy) NSString *MothStr;
@property (nonatomic,strong) NSArray *ModthArray;
@end

@interface WARPhotoSegementControlModel:NSObject
/**Nian*/
@property (nonatomic,copy) NSString *yearStr;
/**当前年份*/
@property (nonatomic,copy) NSString *month;

/**当前月份*/
@property (nonatomic,copy) WARPhotoModel *dataModel;
@property (nonatomic,strong) NSArray *ModthArray;
@end


@interface WARTZModelData:NSObject
/**        WARFormData *formData = [[WARFormData alloc] init];
 CGSize size = photo.size;
 UIImage* scaleImage = [photo war_scaledToSize:CGSizeMake(kScaleFrom_iPhone5(size.width),kScaleFrom_iPhone5(size.height))highQuality:YES];
 formData.data = UIImageJPEGRepresentation(scaleImage, 0.8);
 formData.name = @"files";
 formData.mimeType = @"image/jpeg";
 formData.filename = @"activity_image.png";
 @property (nonatomic, strong) NSData *data;
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, copy) NSString *filename;
 @property (nonatomic, copy) NSString *mimeType;
 */
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic, copy) UIImage *image;
@end

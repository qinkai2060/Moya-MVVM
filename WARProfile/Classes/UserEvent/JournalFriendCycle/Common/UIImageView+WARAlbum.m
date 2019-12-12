//
//  UIImageView+WARAlbum.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/26.
//

#import "UIImageView+WARAlbum.h"

#import "TZImageManager.h"
#import "WARUIHelper.h"

@implementation UIImageView (WARAlbum)

- (void)war_setImageWithIdentifier:(NSString *)identifier placeholderImage:(UIImage *)placeholderImage {
    if (identifier == nil || identifier.length <= 0) {
        return ;
    }
    
    PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        __weak typeof(self) weakSelf = self;
        [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIImage *image = [UIImage imageWithData:data];
            strongSelf.image = image;
        }];
    }else if (asset.mediaType == PHAssetMediaTypeVideo) {
//        [WARTweetVideoTool war_movFileTransformToMP4FromLocalPath:media.mediaPath completion:^(NSString *Mp4FilePath) {
//            [[WARUploadManager shared] uploadFilePath:Mp4FilePath type:WARUploadManagerTypeMOMENT mimeType:WARUploadManagerMimeTypeVideo progressBlock:^(float progressBaifen, NSString *key) {
//            } responseBlock:^(WARUploadRespData *respData, NSString *key) {
//                NSDictionary* dict = @{@"imgW" : kDefualtEmptyStrInDict(respData.videoWidth),
//                                       @"imgH" : kDefualtEmptyStrInDict(respData.videoHeight),
//                                       @"imgId" : kDefualtEmptyStrInDict(respData.url),
//                                       @"videoId" : kDefualtEmptyStrInDict(respData.url)
//                                       };
//                NDLog(@"\n上传视频：%@\n", dict);
//                @synchronized (resultArr) {
//                    WARPublishMeituMediaParam* media = resultArr[i];
//                    media.imgH = [respData.videoHeight floatValue];
//                    media.imgW = [respData.videoWidth floatValue];
//                    media.imgId = respData.url;
//                    media.videoId = respData.url;
//                }
//                dispatch_group_leave(group);
//            } errorInfo:^{
//                //dispatch_group_leave(group);
//                if (completeBlock) {
//                    completeBlock(NO);
//                }
//                return;
//            }];
//        } session:^(AVAssetExportSession *session) {
//            dispatch_group_leave(group);
//        }];
        self.image = DefaultPlaceholderImageForFullScreen;
    }else{
        self.image = DefaultPlaceholderImageForFullScreen;
    }
}

@end

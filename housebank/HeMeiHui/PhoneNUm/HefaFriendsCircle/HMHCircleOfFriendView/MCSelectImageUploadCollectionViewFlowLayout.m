//
//  MCSelectImageUploadCollectionViewFlowLayout.m
//  SalesCircle
//
//  Created by chenpeng on 2016/12/23.
//  Copyright © 2016年 雷雷. All rights reserved.
//

#import "MCSelectImageUploadCollectionViewFlowLayout.h"

@interface MCSelectImageUploadCollectionViewFlowLayout ()

@end

@implementation MCSelectImageUploadCollectionViewFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
        self.itemSize = CGSizeMake((ScreenW - 20 - 3 * 5)/4, (ScreenW - 20 - 3 * 5)/4);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

@end

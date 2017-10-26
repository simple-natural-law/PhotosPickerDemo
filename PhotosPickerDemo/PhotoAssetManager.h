//
//  PhotoAssetManager.h
//  PhotosPickerDemo
//
//  Created by 讯心科技 on 2017/10/26.
//  Copyright © 2017年 张诗健. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoAssetManager : NSObject

+ (instancetype)defaultManager;

/// 检查app系统相册访问权限
- (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;

- (void)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^) (UIImage *image, NSDictionary *info))resultHandler;

@end

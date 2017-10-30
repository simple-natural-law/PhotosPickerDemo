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

// 缩略图尺寸
@property (nonatomic, assign) CGSize thumbnailSize;

+ (instancetype)defaultManager;

/// 检查app系统相册访问权限
- (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler;

/// 获取所有照片资源
- (PHFetchResult<PHAsset *> *)requestAllPhotoAssets;

// 获取缩略图
- (void)requestThumbnailImageForAsset:(PHAsset *)asset resultHandler:(void (^) (UIImage *image, NSDictionary *info))resultHandler;

- (void)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^) (UIImage *image, NSDictionary *info))resultHandler;

- (void)updateCachedAssetsForCollectionView:(UICollectionView *)collectionView;

- (void)resetCachedAssets;

@end

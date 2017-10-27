//
//  PhotoAssetManager.m
//  PhotosPickerDemo
//
//  Created by 讯心科技 on 2017/10/26.
//  Copyright © 2017年 张诗健. All rights reserved.
//

#import "PhotoAssetManager.h"

@interface PhotoAssetManager ()

@property (nonatomic, strong) PHImageManager *imageManager;

@end



@implementation PhotoAssetManager

+ (instancetype)defaultManager
{
    static PhotoAssetManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[PhotoAssetManager alloc] init];
    });
    
    return manager;
}


- (void)requestAuthorization:(void (^)(PHAuthorizationStatus))handler
{
    [PHPhotoLibrary requestAuthorization:handler];
}


- (PHFetchResult<PHAsset *> *)requestAllPhotoAssets
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    
    options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithOptions:options];
    
    return result;
}



- (void)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage *, NSDictionary *))resultHandler
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.synchronous = NO;
    
    [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(targetSize.width*[UIScreen mainScreen].scale, targetSize.height*[UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:resultHandler];
}


#pragma mark- getter
- (PHImageManager *)imageManager
{
    return [PHImageManager defaultManager];
}

@end

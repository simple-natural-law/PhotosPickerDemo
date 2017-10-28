//
//  PhotoAssetManager.m
//  PhotosPickerDemo
//
//  Created by 讯心科技 on 2017/10/26.
//  Copyright © 2017年 张诗健. All rights reserved.
//

#import "PhotoAssetManager.h"

@interface PhotoAssetManager ()

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@property (nonatomic, assign) CGRect previousPreheatRect;

@end



@implementation PhotoAssetManager

+ (instancetype)defaultManager
{
    static PhotoAssetManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[PhotoAssetManager alloc] init];
        
        manager.previousPreheatRect = CGRectZero;
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
    
    [self.imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:resultHandler];
}

- (void)updateCachedAssetsWithCollectionView:(UICollectionView *)collectionView
{
    CGRect visibleRect = CGRectMake(collectionView.contentOffset.x, collectionView.contentOffset.y, collectionView.bounds.size.width,  collectionView.bounds.size.height);
    
    CGRect preheatRect = CGRectInset(visibleRect, 0, -0.5 * visibleRect.size.height);
    
    CGFloat delta = fabs(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    
    if (delta > collectionView.bounds.size.height/3.0)
    {
        NSMutableArray *addedRectArr   = [[NSMutableArray alloc] init];
        NSMutableArray *removedRectARr = [[NSMutableArray alloc] init];
        
        [self differencesBetweenOldRect:self.previousPreheatRect andNewRect:preheatRect addedRectArr:addedRectArr removedRectArr:removedRectARr];
        
        
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)differencesBetweenOldRect:(CGRect)oldRect andNewRect:(CGRect)newRect addedRectArr:(NSMutableArray *)addedRectArr removedRectArr:(NSMutableArray *)removedRectArr
{
    if (CGRectIntersectsRect(oldRect, newRect))
    {
        if (CGRectGetMaxY(newRect) > CGRectGetMaxY(oldRect))
        {
            [addedRectArr addObject:[NSValue valueWithCGRect:CGRectMake(newRect.origin.x, CGRectGetMaxY(oldRect), newRect.size.width, CGRectGetMaxY(newRect) - CGRectGetMaxY(oldRect))]];
        }
        
        if (CGRectGetMinY(oldRect) > CGRectGetMinY(newRect))
        {
            [addedRectArr addObject:[NSValue valueWithCGRect:CGRectMake(newRect.origin.x, CGRectGetMinY(newRect), newRect.size.width, CGRectGetMinY(oldRect) - CGRectGetMinY(newRect))]];
        }
        
        if (CGRectGetMaxY(newRect) < CGRectGetMaxY(oldRect))
        {
            [removedRectArr addObject:[NSValue valueWithCGRect:CGRectMake(newRect.origin.x, CGRectGetMaxY(newRect), newRect.size.width, CGRectGetMaxY(oldRect) - CGRectGetMaxY(newRect))]];
        }
        
        if (CGRectGetMinY(oldRect) < CGRectGetMinY(newRect))
        {
            [removedRectArr addObject:[NSValue valueWithCGRect:CGRectMake(newRect.origin.x, CGRectGetMinY(oldRect), newRect.size.width, CGRectGetMinY(newRect) - CGRectGetMinY(oldRect))]];
        }
    }else
    {
        [addedRectArr addObject:[NSValue valueWithCGRect:newRect]];
        
        [removedRectArr addObject:[NSValue valueWithCGRect:oldRect]];
    }
}

#pragma mark- getter
- (PHCachingImageManager *)imageManager
{
    return (PHCachingImageManager *)[PHCachingImageManager defaultManager];
}

@end

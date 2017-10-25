//
//  ViewController.m
//  PhotosPickerDemo
//
//  Created by 张诗健 on 2017/10/25.
//  Copyright © 2017年 张诗健. All rights reserved.
//


#import "ViewController.h"
#import "PhotoCell.h"
#import <Photos/Photos.h>
#import "PhotosPickerViewController.h"


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray<UIImage *> *selectedPhotoArray;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"PhotosPickerDemo";
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}


#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedPhotoArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.selectedPhotoArray.count)
    {
        cell.imageView.image = [UIImage imageNamed:@"add"];
    }else
    {
        cell.imageView.image = self.selectedPhotoArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectedPhotoArray.count)
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized)
            {
                PhotosPickerViewController *vc = [[PhotosPickerViewController alloc] init];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
                
            }else
            {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"照片权限已关闭" message:@"请前往设置-开启本APP的照片读取权限" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (action.style == UIAlertActionStyleDefault)
                    {
                        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        
                        if([[UIApplication sharedApplication] canOpenURL:url])
                        {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                
                [alertVC addAction:cancelAction];
                [alertVC addAction:otherAction];
                
                [self.navigationController presentViewController:alertVC animated:YES completion:nil];
            }
        }];
    }else
    {
        
    }
}


#pragma mark- getter
- (NSMutableArray<UIImage *> *)selectedPhotoArray
{
    if (_selectedPhotoArray == nil)
    {
        _selectedPhotoArray = [[NSMutableArray alloc] init];
    }
    return _selectedPhotoArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  PhotoPickerViewController.m
//  PhotosPickerDemo
//
//  Created by 张诗健 on 2017/10/25.
//  Copyright © 2017年 张诗健. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "PhotoAssetManager.h"
#import "PhotoCell.h"

@interface PhotoPickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;

@end


@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    
    [PhotoAssetManager defaultManager].thumbnailSize = CGSizeMake(80.0*[UIScreen mainScreen].scale, 80.0*[UIScreen mainScreen].scale);
    
    self.fetchResult = [[PhotoAssetManager defaultManager] requestAllPhotoAssets];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[PhotoAssetManager defaultManager] updateCachedAssetsForCollectionView:self.collectionView fetchResult:self.fetchResult];
}

#pragma mark- Methods
- (void)setUI
{
    self.title = @"选择相片";
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40.0, 30.0);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80.0, 80.0);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.sectionInset = UIEdgeInsetsMake(20.0, 10.0, 10.0, 10.0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[PhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
}

- (void)dismissViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    
    [[PhotoAssetManager defaultManager] requestThumbnailImageForAsset:[self.fetchResult objectAtIndex:indexPath.item] resultHandler:^(UIImage *image, NSDictionary *info) {
        
        cell.imageView.image = image;
    }];
    
    return cell;
}

#pragma mark- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[PhotoAssetManager defaultManager] updateCachedAssetsForCollectionView:self.collectionView fetchResult:self.fetchResult];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

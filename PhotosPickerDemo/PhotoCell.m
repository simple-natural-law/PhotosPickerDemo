//
//  PhotoCell.m
//  PhotosPickerDemo
//
//  Created by 张诗健 on 2017/10/25.
//  Copyright © 2017年 张诗健. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.layer.masksToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

@end


typedef void(^TouchSelectedButtonBlock)(BOOL selected, PhotoPickerCell *cell);

@interface PhotoPickerCell ()

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, copy)   TouchSelectedButtonBlock block;

@end


@implementation PhotoPickerCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = CGRectMake(frame.size.width - 25.0, 0.0, 25.0, 25.0);
        [self.selectButton setImage:[UIImage imageNamed:@"deselected"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [self.selectButton addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectButton];
    }
    
    return self;
}


- (void)selectedAction
{
    self.selectButton.selected = !self.selectButton.selected;
    
    if (self.block)
    {
        self.block(self.selectButton.selected, self);
    }
}

- (void)didTouchSelectedButtonBlock:(void (^)(BOOL, PhotoPickerCell *))block
{
    self.block = block;
}

@end

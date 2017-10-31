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



@interface PhotoPickerCell ()

@property (nonatomic, strong) UIButton *selectButton;

@end


@implementation PhotoPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = CGRectMake(frame.size.width - 30.0, 0.0, 30.0, 30.0);
        [self.selectButton setImage:[UIImage imageNamed:@"deselected"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.selectButton];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.selectButton.selected = selected;
}


@end

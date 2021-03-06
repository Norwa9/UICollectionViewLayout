//
//  HomeCaseCell.m
//  JianLiXiu
//
//  Created by shuni on 2017/5/15.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "HomeCaseCell.h"
#import <ReactiveObjC.h>

@interface HomeCaseCell ()
@property(nonatomic,strong)UIView *maskView;
@end

@implementation HomeCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

// 防止滚动时图片错乱
- (void)prepareForReuse {
    [super prepareForReuse];
    // 重置image
    self.coverImgView.image = nil;
    // 更新位置
    self.coverImgView.frame = self.contentView.bounds;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor colorWithRed:232.0/255.0 green:163.0/255.0 blue:136/255.0 alpha:1.0].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.f, 2.f);
        self.layer.shadowOpacity = 0.6f;
        self.layer.shadowRadius = 5.f;
    
        self.coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kItemW, kItemH)];
        self.coverImgView.userInteractionEnabled = YES;
        self.coverImgView.layer.masksToBounds = YES;
        self.coverImgView.layer.cornerRadius = 8.f;
        [self.contentView addSubview:self.coverImgView];
        
        self.maskView.frame = CGRectMake(0, 0, kItemW, kItemH);
        self.maskView.layer.cornerRadius = 8.f;
        [self.contentView addSubview:self.maskView];
        [RACObserve(self, alpha) subscribeNext:^(NSNumber *_Nullable x) {
            self.maskView.alpha = 1 - x.floatValue;//遮罩视图随着cell的alpha而变化。
        }];
        
    }
    return  self;
}

- (UIView *)maskView
{
    if(!_maskView){
        _maskView = [UIView new];
        _maskView.backgroundColor = UIColor.blackColor;
        _maskView.alpha = 0;
    }
    return _maskView;
}

@end

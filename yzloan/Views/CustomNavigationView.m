//
//  CustomNavigationView.m
//  yzloan
//
//  Created by 苏文彬 on 2018/12/20.
//  Copyright © 2018年 yinzhong. All rights reserved.
//

#import "CustomNavigationView.h"

@interface CustomNavigationView ()

#define UIColorFromRGBA(rgbValue, alphaValue)		[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0x0000FF))/255.0 \
alpha:(alphaValue)]

@end


@implementation CustomNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [UILabel new];
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
    
        UIButton *backButton = [UIButton new];
        self.backButton = backButton;
        [self addSubview:self.backButton];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGSize size = self.frame.size;
//    self.titleLabel.center = self.center;
    CGFloat centerX = (self.frame.size.width - 150)/2+ 37.5;
    self.titleLabel.frame = CGRectMake(centerX, 34,150, 20);
    self.titleLabel.textColor = UIColorFromRGBA(0x3d3d3d, 1.0);
    [self.titleLabel sizeToFit];
    
    self.backButton.frame = CGRectMake(15, 34, 20, 20);
//    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"back_gray"] forState:UIControlStateNormal];
//    self.backButton.hidden = YES;
}
@end

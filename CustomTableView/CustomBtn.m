//
//  CustomBtn.m
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/30.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel.textAlignment=NSTextAlignmentRight;
        self.imageView.contentMode=UIViewContentModeLeft;
        self.titleLabel.numberOfLines=0;
    }
    return self;
}

// 重写Button里面的方法,用来重新布局Button里面的文字和图片的Frame(各自一半的Frame)
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, self.width/2, self.height);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(self.width/2, 0, self.width/2, self.height);
}
@end

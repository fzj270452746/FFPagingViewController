//
//  FFPagingViewItem.m
//  BasicFrameworkManager
//
//  Created by Fan on 16/9/27.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import "FFPagingViewItem.h"

@implementation FFPagingViewItem
// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_fillColor set];

    CGRect newRect = rect;
    newRect.size.width = rect.size.width * self.progress;
    UIRectFillUsingBlendMode(newRect, kCGBlendModeSourceIn);
}
@end

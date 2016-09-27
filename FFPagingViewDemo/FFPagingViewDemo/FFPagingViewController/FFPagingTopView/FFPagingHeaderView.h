//
//  FFPagingHeaderView.h
//  BasicFrameworkManager
//
//  Created by Fan on 16/9/27.
//  Copyright © 2016年 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFPagingHeaderView : UIView
@property(nonatomic, copy) void(^pagingViewItemClickHandle)(FFPagingHeaderView *headerView, NSString *title, NSInteger currentIndex);

/**
 *   标题数组
 *   注：请设置完其他属性后在设置该属性
 */
@property(nonatomic, strong) NSArray <NSString *> *titles;

/**
 *  设置item宽度
 *
 */
@property(nonatomic, assign) CGFloat itemWidth;

/**
 *  设置item中文字字体
 *
 */
@property(nonatomic, strong) UIFont *font;

/**
 *  设置item字体颜色
 *
 */
@property(nonatomic, strong) UIColor *textColor;

/**
 *  设置item选中字体颜色
 *
 */
@property(nonatomic, strong) UIColor *selectTextColor;

/**
 *  设置整个view底部的线条颜色
 *
 */
@property(nonatomic, strong) UIColor *lineColor;

/**
 *  设置偏移位置
 *
 */
@property(nonatomic, assign) CGPoint contentOffset;

/**
 *  是否开启滑动缩放动效
 *
 */
@property(nonatomic, assign) BOOL scale;

/**
 *  随着选中title的位置的移动更新显示位置
 *
 *  @param  index 滚动视图停止时选择中的位置
 */
- (void)updateTitleContentOffset:(NSInteger)index;

@end

//
//  XScrollNumLab.h
//  ScrollNumber
//
//  Created by apple on 2017/4/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 数字增长方式

 - XScrollNumLabTypeConstant: 增长速率不变
 - XScrollNumLabTypeCube: 增长速率先慢后快
 */
typedef NS_ENUM(NSUInteger, XScrollNumLabType) {
    XScrollNumLabTypeConstant,
    XScrollNumLabTypeCube,
};

typedef NSString *(^labelFormatBlock)(CGFloat value);
typedef NSAttributedString *(^labelAttributedFormatBlock)(CGFloat value);

@interface XScrollNumLab : UILabel

@property (nonatomic, assign) XScrollNumLabType type;

/**
 文本类型
 */
@property (nonatomic, copy) NSString *format;
@property (nonatomic, copy) labelFormatBlock formatBlock;
@property (nonatomic, copy) labelAttributedFormatBlock attributeFormatBlock;

/**
 完成动画后的行为
 */
@property (nonatomic, copy) void (^completionBlock)();


/**
 数字变化的方法

 @param startValue 开始动画的起始数字
 @param endValue 最终结束动画的数字
 @param duration 动画持续的时间
 */
- (void)scrollFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

@end

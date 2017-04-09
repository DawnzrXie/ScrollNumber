//
//  XScrollNumLab.m
//  ScrollNumber
//
//  Created by apple on 2017/4/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "XScrollNumLab.h"

@protocol XScrollNumlabDelegate <NSObject>

- (CGFloat)update:(CGFloat)t;

@end

@interface  XScrollNumLabConstant: NSObject<XScrollNumlabDelegate>

@end

@implementation XScrollNumLabConstant

- (CGFloat)update:(CGFloat)t {
    
    return t;
}

@end

@interface XScrollNumLabCube : NSObject<XScrollNumlabDelegate>

@end

@implementation XScrollNumLabCube

- (CGFloat)update:(CGFloat)t {
    
    return pow(t, 2.0);
}

@end
/*******************************************************/

@interface XScrollNumLab ()

@property (nonatomic, strong)CADisplayLink *timer;
@property (nonatomic,strong) id<XScrollNumlabDelegate> delegate;

@end

@implementation XScrollNumLab {
    
    CGFloat _startValue;
    CGFloat _endValue;
    NSTimeInterval _progress;
    NSTimeInterval _duration;
    NSTimeInterval _lastUpdate;
}

- (void)scrollFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    
    _startValue = startValue;
    _endValue = endValue;
    
    //注销旧的时间管理器
    [self.timer invalidate];
    self.timer = nil;
    
    if (0.0 == duration) {
        
        [self TextValue:endValue];
        [self runCompletionBlock];
        return;
    }
    
    _progress = 0.0;
    _duration = duration;
    _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"%f",_lastUpdate);
    
    if (nil == self.format) {
        
        self.format = @"%f";
    }
    
    switch (self.type) {
        case XScrollNumLabTypeConstant:
            self.delegate = [[XScrollNumLabConstant alloc] init];
            break;
            case XScrollNumLabTypeCube:
            self.delegate = [[XScrollNumLabCube alloc] init];
            break;
        default:
            break;
    }
    
    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
    timer.preferredFramesPerSecond = 20;
    
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.timer = timer;

}

- (void)updateValue:(NSTimer *)timer {
    
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    _progress += now - _lastUpdate;
    _lastUpdate = now;
    
    if (_progress >= _duration) {
        [self.timer invalidate];
        self.timer = nil;
        _progress = _duration;
    }
    
    [self TextValue:[self currentValue]];
    
    if (_progress == _duration) {
        [self runCompletionBlock];
    }
}

- (void)TextValue:(CGFloat)value {

    if (nil != self.attributeFormatBlock) {
        
        self.attributedText = self.attributeFormatBlock(value);
        
    } else if (nil != self.formatBlock) {
        
        self.text = self.formatBlock(value);
        
    } else {
        
        BOOL isInt = [self.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound || [self.format rangeOfString:@"%(.*)i"].location != NSNotFound;
        
        if (isInt) {
            
            self.text = [NSString stringWithFormat:self.format,(int)value];
        } else {
            
            self.text = [NSString stringWithFormat:self.format,value];
        }
        
        
    }
}

- (CGFloat)currentValue {
    
    if (_progress >= _duration) {
        return _endValue;
    }
    CGFloat percent = _progress/_duration;
    CGFloat updateValue = [_delegate update:percent];
    CGFloat currentValue = _startValue + (updateValue*(_endValue-_startValue));
    return currentValue;
}

- (void)runCompletionBlock {
    
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = nil;
    }
}

#pragma mark - setMethods
- (void)setFormat:(NSString *)format {
    
    _format = format;
    [self TextValue:[self currentValue]];
}

@end

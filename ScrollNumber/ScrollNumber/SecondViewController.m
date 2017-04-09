//
//  SecondViewController.m
//  ScrollNumber
//
//  Created by apple on 2017/4/9.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "SecondViewController.h"
#import "XScrollNumLab.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *desArr = @[@"变化数字不需要转换的:",
                        @"文本中数字需要转换:",
                        @"文本是可变字符串:",
                        @"带千分符号的:"];
    for (int i = 0; i < 4; i++) {
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100 + 50*i, 180, 30)];
        desLabel.text = desArr[i];
        [self.view addSubview:desLabel];
    }
    
    XScrollNumLab *xSOneLabel = [[XScrollNumLab alloc] initWithFrame:CGRectMake(200, 100, 200, 30)];
    xSOneLabel.type = XScrollNumLabTypeCube;
    xSOneLabel.format = @"%d";
    [xSOneLabel scrollFrom:0 to:543 withDuration:2.0];
    [self.view addSubview:xSOneLabel];
    
    __weak typeof(self) weakSelf = self;
    xSOneLabel.completionBlock = ^{
      
        weakSelf.view.backgroundColor = [UIColor cyanColor];
    };
    
    
    XScrollNumLab *xSSecondLabel = [[XScrollNumLab alloc] initWithFrame:CGRectMake(200, 150, 200, 30)];
    xSOneLabel.type = XScrollNumLabTypeCube;
    xSSecondLabel.formatBlock = ^NSString *(CGFloat value) {
        NSString *dayStr = [NSString stringWithFormat:@"%d",(int)value/(60*24)];
        NSString *hourStr = [NSString stringWithFormat:@"%d",(int)value/60];
        NSString *minuteStr = [NSString stringWithFormat:@"%d",(int)value%60];
        return [NSString stringWithFormat:@"%@天%@小时%@分钟",dayStr,hourStr,minuteStr];
    };
    [xSSecondLabel scrollFrom:100000 to:1000 withDuration:2.0];
    [self.view addSubview:xSSecondLabel];
    
    
    XScrollNumLab *xSThirdLabel = [[XScrollNumLab alloc] initWithFrame:CGRectMake(200, 200, 200, 30)];
    xSThirdLabel.type = XScrollNumLabTypeCube;
    NSInteger toValue = 100;
    xSThirdLabel.attributeFormatBlock = ^NSAttributedString *(CGFloat value) {
        NSDictionary* normal = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-UltraLight" size: 20] };
        NSDictionary* highlight = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 20] };
        
        NSString* prefix = [NSString stringWithFormat:@"%d", (int)value];
        NSString* postfix = [NSString stringWithFormat:@"/%d", (int)toValue];
        
        NSMutableAttributedString* prefixAttr = [[NSMutableAttributedString alloc] initWithString: prefix
                                                                                       attributes: highlight];
        NSAttributedString* postfixAttr = [[NSAttributedString alloc] initWithString: postfix
                                                                          attributes: normal];
        [prefixAttr appendAttributedString: postfixAttr];
        
        return prefixAttr;
    };
    [xSThirdLabel scrollFrom:0 to:toValue withDuration:2.0];
    [self.view addSubview:xSThirdLabel];
    
    
    XScrollNumLab *XSFourthLabel = [[XScrollNumLab alloc] initWithFrame:CGRectMake(200, 250, 200, 30)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    XSFourthLabel.formatBlock = ^NSString *(CGFloat value) {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"$%@",formatted];
    };
    [XSFourthLabel scrollFrom:0 to:154333234 withDuration:2.0];
    [self.view addSubview:XSFourthLabel];
    
}

- (IBAction)dismissView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

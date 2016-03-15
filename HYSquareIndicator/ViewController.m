//
//  ViewController.m
//  HYSquareIndicator
//
//  Created by heyang on 16/3/14.
//  Copyright © 2016年 com.heyang. All rights reserved.
//
#import "HYSquareIndicatorView.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)start:(UIButton *)sender {
    
    
    [HYSquareIndicatorView show];
    
    
}

- (IBAction)dismiss:(UIButton *)sender {
    
    
    [HYSquareIndicatorView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

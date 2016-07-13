//
//  LYViewController.m
//  LTWebView
//
//  Created by yelon21 on 07/13/2016.
//  Copyright (c) 2016 yelon21. All rights reserved.
//

#import "LYViewController.h"
#import <LTWebView/LTWebViewController.h>
@interface LYViewController ()

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    LTWebViewController *viewCon = [[LTWebViewController alloc]init];
    [viewCon lt_loadUrl:@"http://www.baidu.com"];

    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

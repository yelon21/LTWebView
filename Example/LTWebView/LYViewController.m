//
//  LYViewController.m
//  LTWebView
//
//  Created by yelon21 on 07/13/2016.
//  Copyright (c) 2016 yelon21. All rights reserved.
//

#import "LYViewController.h"
#import "LTWebViewController.h"
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

    //[viewCon lt_loadUrl:@"https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1151018531/platform/ios/resolutioncenter"];
    [viewCon lt_loadUrl:@"https://pan.baidu.com/play/video#video/path=%2F%E9%B9%8F%E9%A3%9E%2F%E5%AD%A6%E4%B9%A0%2FHTML5%E6%95%99%E7%A8%8B%2FHTML5%E5%85%A5%E9%97%A8%E8%A7%86%E9%A2%91%E6%95%99%E7%A8%8B%EF%BC%9A%E7%AC%AC%E4%B8%80%E7%AB%A0%EF%BC%8C%E6%A6%82%E8%AE%BA%2F%E7%A7%80%E9%87%8E%E5%A0%82%E4%B8%BB%E8%AE%B2html5%E7%AC%AC%E4%B8%80%E7%AB%A0%EF%BC%88%E6%A6%82%E8%AE%BA%EF%BC%898.mp4&t=-1"];

    [self.navigationController pushViewController:viewCon animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

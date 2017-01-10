//
//  LTWebViewController.m
//  LTTools
//
//  Created by yelon on 16/4/27.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTWebViewController.h"

@interface LTWebViewController ()

@property(nonatomic,strong) UIProgressView *progressView;

@end

@implementation LTWebViewController

-(instancetype)init{

    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self initElements];
    }
    return self;
}

- (void)initElements{

    UIView *superView = self.view;
    [superView addSubview:self.webView];
}

-(UIProgressView *)progressView{

    if (!_progressView) {
        
        CGFloat orgY = 0.0;
        CGFloat height = 3.0;
        
        if (self.navigationController.navigationBar) {
            
            orgY = CGRectGetHeight(self.navigationController.navigationBar.bounds);
        }
        
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0.0, orgY, CGRectGetWidth(self.view.bounds), height)];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _progressView;
}

-(LTWebView *)webView{
    
    if (!_webView) {
        
        _webView = [[LTWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _webView;
}

- (void)updateBarItems{

    NSMutableArray *items = [NSMutableArray array];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    [btn setImage:[UIImage imageNamed:@"Frameworks/LTWebView.framework/LTWebView.bundle/back"]
         forState:UIControlStateNormal];
    
    [btn addTarget:self
            action:@selector(lt_goBack)
  forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [items addObject:backItem];
    
    if ([self.webView canGoBack]) {
        
        UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        
        [btn2 setTitle:@"关闭" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateNormal];
        
        [btn2 addTarget:self
                action:@selector(closeToBack)
      forControlEvents:UIControlEventTouchUpInside];
        
        [btn2 sizeToFit];
        
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc]initWithCustomView:btn2];
        [items addObject:closeItem];
    }
    self.navigationItem.leftBarButtonItems = items;
}

- (void)closeToBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)lt_goBack{
    
    if ([self.webView canGoBack]) {
        
        [self.webView lt_goBack];
    }
    else{
    
        [self closeToBack];
    }
}

-(void)lt_reload{

    [self.webView lt_reload];
}

- (void)lt_loadUrl:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSLog(@"url==%@",url);
    if (url) {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        [self.webView lt_loadRequest:request];
    }
}

-(void)lt_loadHtml:(NSString *)html{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.webView lt_loadHTMLString:html baseURL:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateBarItems];
}
- (void)setNetworkActivityIndicatorVisible:(BOOL)visible{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
}
#pragma mark LTWebViewDelegate
-(void)ltwebViewDidStartLoad:(LTWebView *)webView{
    
    [self setNetworkActivityIndicatorVisible:YES];
}
-(void)ltwebViewDidFinishLoad:(LTWebView *)webView{
    
    [self setNetworkActivityIndicatorVisible:NO];
    [self updateBarItems];
    
    [webView lt_evaluateJavaScript:@"document.title"
                 completionHandler:^(id  _Nullable response, NSError * _Nullable error) {
                     NSLog(@"document.title==%@",response);
                     self.navigationItem.title = response;
                 }];
}

-(BOOL)ltwebView:(LTWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL *url = [request URL];
    NSString *absoluteString = [url absoluteString];
    //NSLog(@"absoluteString == %@",absoluteString);
    if ([absoluteString hasPrefix:@"http://itunes.apple.com"]) {
        
        [[UIApplication sharedApplication]openURL:url];
        return NO;
    }
    return YES;
}

-(void)ltwebView:(LTWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self setNetworkActivityIndicatorVisible:NO];
    [self updateBarItems];
    NSLog(@"error==%@",error);
}

-(void)ltwebView:(LTWebView *)webView loadingProgress:(double)progress{

    NSLog(@"============progress=%@",@(progress));
    
    if (!_progressView) {
        
        if (self.navigationController.navigationBar) {
            
            [self.navigationController.navigationBar addSubview:self.progressView];
        }
        else{
            
            [self.view addSubview:self.progressView];
        }
    }
    [self.progressView setProgress:progress animated:YES];
    
    if (progress>=1.0) {
        
        [self.progressView setProgress:0 animated:NO];
    }
}

@end

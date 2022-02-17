//
//  LTWebView.h
//  YJNew
//
//  Created by yelon on 16/3/8.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#ifndef LTLog
#ifdef DEBUG
#define LTLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define LTLog(...)
#endif
#endif

@protocol LTWebViewDelegate;

@interface LTWebView : UIView<WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,readonly,assign,nullable) WKWebView *webView;
@property(nonatomic,readonly,strong,nullable) NSString *title;
@property(nonatomic,assign,nullable) id<LTWebViewDelegate>delegate;

@property (nullable, nonatomic, readonly, assign) NSURL *URL;
@property (nonnull, nonatomic, readonly, assign) UIScrollView *scrollView;
@property (nonatomic, readonly) double estimatedProgress;

- (void)lt_loadUrl:(nonnull NSString *)urlString;
- (void)lt_loadRequest:(nonnull NSURLRequest *)request;
- (void)lt_loadHTMLString:(nonnull NSString *)string baseURL:(nullable NSURL *)baseURL;
- (void)lt_loadData:(nonnull NSData *)data
           MIMEType:(nullable NSString *)MIMEType
   textEncodingName:(nullable NSString *)textEncodingName
            baseURL:(nullable NSURL *)baseURL;


@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

- (void)lt_reload;
- (void)lt_stopLoading;

- (void)lt_goBack;
- (void)lt_goForward;

//@property (nonatomic) BOOL scalesPageToFit;
//@property (nonatomic) UIDataDetectorTypes dataDetectorTypes NS_AVAILABLE_IOS(3_0);

- (void)lt_evaluateJavaScript:(nonnull NSString *)javaScriptString completionHandler:(void (^ __nullable)(__nullable id response, NSError * __nullable error))completionHandler;

@end

@protocol LTWebViewDelegate <NSObject>

@optional
- (BOOL)ltwebView:(nonnull LTWebView *)webView
shouldStartLoadWithRequest:(nonnull NSURLRequest *)request
   navigationType:(WKNavigationType)navigationType;
- (void)ltwebViewDidStartLoad:(nonnull LTWebView *)webView;
- (void)ltwebViewDidFinishLoad:(nonnull LTWebView *)webView;
- (void)ltwebView:(nonnull LTWebView *)webView didFailLoadWithError:(nullable NSError *)error;

- (void)ltwebView:(nonnull LTWebView *)webView loadingProgress:(double)progress;

@end

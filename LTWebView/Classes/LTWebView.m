//
//  LTWebView.m
//  YJNew
//
//  Created by yelon on 16/3/8.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTWebView.h"

@interface LTWebView ()

@property(nonatomic,strong) WKWebView *webViewWK;
@property(nonatomic,readwrite,strong,nullable) NSString *title;
@property(nonatomic,readwrite) double estimatedProgress;
@end

@implementation LTWebView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{

    [super awakeFromNib];
    
    [self setup];
}

- (void)setup{
    
    self.title = @"";
    
    _estimatedProgress = 0.0;
    
    [self initWKWebView];
    
    [self.webViewWK addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
                        context:(__bridge void * _Nullable)(self.delegate)];
}

-(void)dealloc{

    [self.webViewWK removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        double progress = [change[@"new"] doubleValue];
        [self lt_webView:self loadingProgress:progress];
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    
    [super setBackgroundColor:backgroundColor];
    
    self.webViewWK.backgroundColor = backgroundColor;
}
//初始化
- (void)initWKWebView{
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    
    configuration.preferences = [[WKPreferences alloc]init];
    configuration.userContentController = [[WKUserContentController alloc]init];
    
    self.webViewWK = [[WKWebView alloc]initWithFrame:self.bounds
                                       configuration:configuration];
    self.webViewWK.UIDelegate = self;
    self.webViewWK.navigationDelegate = self;
    
    UIView *superView = self;

    [superView addSubview:self.webViewWK];
    self.webViewWK.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.webViewWK.scrollView.bounces = YES;
}

// 成员方法
-(WKWebView *)webView{
    
    return self.webViewWK;
}
//加载
- (void)lt_loadUrl:(NSString *)urlString{
    
    if (urlString == nil) {
        
        urlString = @"";
    }
    else if ([urlString isKindOfClass:[NSString class]]) {
        
        urlString = [NSString stringWithFormat:@"%@",urlString];
        
    }else if([urlString isKindOfClass:[NSNumber class]]){
        
        urlString = [NSString stringWithFormat:@"%@",urlString];
    }
    else{
    
        urlString = @"";
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        
        LTLog(@"urlString异常=%@",urlString);
        return;
    }

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    [self lt_loadRequest:request];
}

-(void)lt_loadRequest:(NSURLRequest *)request{
    
    [self.webViewWK loadRequest:request];
}

-(void)lt_loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL{
    
    [self.webViewWK loadHTMLString:string baseURL:baseURL];
}

-(void)lt_loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL{
    
    if ([self.webViewWK respondsToSelector:@selector(loadData:MIMEType:characterEncodingName:baseURL:)]) {//9.0
        
        [self.webViewWK loadData:data MIMEType:MIMEType characterEncodingName:textEncodingName baseURL:baseURL];
    }
}
//属性 readonly
-(NSURL *)URL{
    
    return self.webViewWK.URL;
}

-(UIScrollView *)scrollView{
    
    return self.webViewWK.scrollView;
}

-(BOOL)canGoBack{
    
    return self.webViewWK.canGoBack;
}

-(BOOL)canGoForward{
    
    return self.webViewWK.canGoForward;
}

-(BOOL)isLoading{
    
    return self.webViewWK.isLoading;
}

- (void)lt_reload{
    
    [self.webViewWK reloadFromOrigin];
}

- (void)lt_stopLoading{
    
    [self.webViewWK stopLoading];
}

- (void)lt_goBack{
    
    [self.webViewWK goBack];
}

- (void)lt_goForward{
    
    [self.webViewWK goForward];
}
//
-(void)lt_evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable data, NSError * _Nullable))completionHandler{
    
    [self.webViewWK evaluateJavaScript:javaScriptString
                     completionHandler:completionHandler];
}
#pragma mark LTWebViewDelegate
- (void)lt_webViewDidStartLoad:(UIView *)webView {
    
    LTLog(@"lt_webViewDidStartLoad");
    if ([self.delegate respondsToSelector:@selector(ltwebViewDidStartLoad:)]) {
        
        [self.delegate ltwebViewDidStartLoad:self];
    }
}

- (void)lt_webViewDidFinishLoad:(UIView *)webView {
    LTLog(@"lt_webViewDidFinishLoad");
    if ([self.delegate respondsToSelector:@selector(ltwebViewDidFinishLoad:)]) {
        
        [self.delegate ltwebViewDidFinishLoad:self];
    }
}

- (BOOL)lt_webView:(UIView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
    navigationType:(WKNavigationType)navigationType{
    LTLog(@"shouldStartLoadWithRequest");
    if ([self.delegate respondsToSelector:@selector(ltwebView:shouldStartLoadWithRequest:navigationType:)]) {
        
        return [self.delegate ltwebView:self
             shouldStartLoadWithRequest:request
                         navigationType:navigationType];
    }
    return YES;
}

- (void)lt_webView:(UIView *)webView
didFailLoadWithError:(nullable NSError *)error{
    LTLog(@"didFailLoadWithError");
    if ([self.delegate respondsToSelector:@selector(ltwebView:didFailLoadWithError:)]) {
        
        [self.delegate ltwebView:self didFailLoadWithError:error];
    }
}

- (void)lt_webView:(nonnull LTWebView *)webView
   loadingProgress:(double)progress{
    
    if (progress<0.1) {
        progress = 0.1;
    }
    if (progress==0.1) {
        
        if (self.estimatedProgress == 0.1) {
            
            return;
        }
    }
    else if (self.estimatedProgress >= progress) {
        
        return;
    }

    self.estimatedProgress = progress;
    
    //LTLog(@"progress=%@",@(progress));
    
    if ([self.delegate respondsToSelector:@selector(ltwebView:loadingProgress:)]) {
        
        [self.delegate ltwebView:webView loadingProgress:progress];
    }

}

#pragma mark- WKNavigationDelegate
/*! @abstract 决定是否允许或者取消一个navigationAction
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //LTLog(@"决定是否允许=%@",navigationAction.request);
    BOOL allow = [self lt_webView:webView
       shouldStartLoadWithRequest:navigationAction.request
                   navigationType:navigationAction.navigationType];
    if (allow) {
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else{
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

/*! @abstract 判定在获取确定响应后是否允许导航
 @discussion 如果你不实现,如果webview能够显示， webview将允许响应.
 */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}

/*! @abstract 开始加载
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    LTLog(@"开始加载");
    [self lt_webViewDidStartLoad:webView];
}

/*! @abstract 接收到重定向
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    LTLog(@"接收到重定向");
}

/*! @abstract 加载失败
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    LTLog(@"加载失败");
    [self lt_webView:webView didFailLoadWithError:error];
}

/*! @abstract 开始接收数据
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    LTLog(@"开始接收数据");
}

/*! @abstract 加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    LTLog(@"加载完成");
    self.title = webView.title;
    
    [self lt_webViewDidFinishLoad:webView];
}

/*! @abstract 错误发生.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    LTLog(@"error==%@",error);
    [self lt_webView:webView didFailLoadWithError:error];
}

/*! @abstract webview 需要证书校验
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if (@available(iOS 7.0, *)) {
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        
        __block NSURLCredential *credential = nil;
        
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            
            if (credential) {
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
        } else {
            
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
        if (completionHandler) {
            completionHandler(disposition, credential);
        }
    }
}

/*! @abstract webview 内容处理终止
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0){
    
    LTLog(@"内容处理终止");
}

#pragma mark- WKUIDelegate

/*! @abstract 创建新的webview
 @param webView The web view invoking the delegate method.
 @param configuration The configuration to use when creating the new web
 view.
 @param navigationAction The navigation action causing the new web view to
 be created.
 @param windowFeatures Window features requested by the webpage.
 @result A new web view or nil.
 @discussion The web view returned must be created with the specified configuration. WebKit will load the request in the returned web view.
 
 If you do not implement this method, the web view will cancel the navigation.
 */
//- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//
//}

/*! @abstract Notifies your app that the DOM window object's close() method completed successfully.
 @discussion Your app should remove the web view from the view hierarchy and update
 the UI as needed, such as by closing the containing browser tab or window.
 调用 关闭页面
 */
- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0){
    
    LTLog(@"关闭页面");
}

/*! @abstract 显示js alert
 @param webView The web view invoking the delegate method.
 @param message The message to display.
 @param frame Information about the frame whose JavaScript initiated this
 call.
 @param completionHandler The completion handler to call after the alert
 panel has been dismissed.
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have a single OK button.
 
 If you do not implement this method, the web view will behave as if the user selected the OK button.
 */

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    LTLog(@"message=%@",message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    
        completionHandler();
    }];
    
    [alert addAction:action];
    
    UIViewController *viewCon = (UIViewController *)self.delegate;
    if (![viewCon isKindOfClass:[UIViewController class]]) {
        
        viewCon = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if (viewCon.presentedViewController) {
        
        completionHandler();
    }
    else{
    
        [viewCon presentViewController:alert animated:YES completion:nil];
    }
}

/*! @abstract 显示js confirm
 
 @discussion For user security, your app should call attention to the fact
 that a specific website controls the content in this panel. A simple forumla
 for identifying the controlling website is frame.request.URL.host.
 The panel should have two buttons, such as OK and Cancel.
 
 If you do not implement this method, the web view will behave as if the user selected the Cancel button.
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionConfirm];
    
    UIViewController *viewCon = (UIViewController *)self.delegate;
    if (![viewCon isKindOfClass:[UIViewController class]]) {
        
        viewCon = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [viewCon presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:prompt
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(nil);
    }];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *input = ((UITextField *)alert.textFields.firstObject).text;
        completionHandler(input);
    }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionConfirm];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = defaultText;
        textField.secureTextEntry = ([prompt rangeOfString:@"密码"].location != NSNotFound || [defaultText rangeOfString:@"密码"].location != NSNotFound);
    }];
    
    UIViewController *viewCon = (UIViewController *)self.delegate;
    if (![viewCon isKindOfClass:[UIViewController class]]) {
        
        viewCon = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [viewCon presentViewController:alert animated:YES completion:nil];
}


@end

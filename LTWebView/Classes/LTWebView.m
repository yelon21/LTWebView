//
//  LTWebView.m
//  YJNew
//
//  Created by yelon on 16/3/8.
//  Copyright © 2016年 yelon. All rights reserved.
//

#import "LTWebView.h"
#import "LTUIWebView.h"

@interface LTWebView ()<LTUIWebViewDelegate>{

    NSInteger loadingCount;
}

@property(nonatomic,strong) LTUIWebView *webViewUI;
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
    
    loadingCount = 0;
    _estimatedProgress = 0.0;
    
    Class wkClass = NSClassFromString(@"WKWebView");
    if (wkClass) {
        _isWKWebView = YES;
        [self initWKWebView];
    }
    else{
        
        _isWKWebView = NO;
        [self initUIWebView];
    }
    
    if (_isWKWebView) {
        
        [self.webViewWK addObserver:self
                         forKeyPath:@"estimatedProgress"
                            options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
                            context:(__bridge void * _Nullable)(self.delegate)];
    }
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
    
    if (self.isWKWebView) {
        
        self.webViewWK.backgroundColor = backgroundColor;
    }
    else{
        
        self.webViewUI.backgroundColor = backgroundColor;
    }
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

- (void)initUIWebView{
    
    self.webViewUI = [[LTUIWebView alloc]initWithFrame:self.bounds];
    self.webViewUI.delegate = self;
    self.webViewUI.ltDelegate = self;
    UIView *superView = self;

    [superView addSubview:self.webViewUI];
    self.webViewUI.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.webViewUI.scrollView.bounces = YES;
}
// 成员方法
-(UIView *)webView{
    
    if (self.isWKWebView) {
        
        return self.webViewWK;
    }
    else{
        
        return self.webViewUI;
    }
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
    
    if ([urlString respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    else{
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        
        NSLog(@"urlString异常=%@",urlString);
        return;
    }

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    [self lt_loadRequest:request];
}

-(void)lt_loadRequest:(NSURLRequest *)request{
    
    if (self.isWKWebView) {
        
        [self.webViewWK loadRequest:request];
    }
    else {
        
        [self.webViewUI loadRequest:request];
    }
}

-(void)lt_loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL{
    
    if (self.isWKWebView) {
        
        [self.webViewWK loadHTMLString:string baseURL:baseURL];
    }
    else {
        
        [self.webViewUI loadHTMLString:string baseURL:baseURL];
    }
}

-(void)lt_loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL{
    
    if (self.isWKWebView) {
        
        if ([self.webViewWK respondsToSelector:@selector(loadData:MIMEType:characterEncodingName:baseURL:)]) {//9.0
            
            [self.webViewWK loadData:data MIMEType:MIMEType characterEncodingName:textEncodingName baseURL:baseURL];
        }
    }
    else {
        
        [self.webViewUI loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
    }
}
//属性 readonly
-(NSURL *)URL{
    
    if (self.isWKWebView) {
        
        return self.webViewWK.URL;
    }
    else{
        
        return self.webViewUI.request.URL;
    }
}
-(UIScrollView *)scrollView{
    
    if (self.isWKWebView) {
        
        return self.webViewWK.scrollView;
    }
    else{
        
        return self.webViewUI.scrollView;
    }
}

-(BOOL)canGoBack{
    
    if (self.isWKWebView) {
        
        return self.webViewWK.canGoBack;
    }
    else{
        
        return self.webViewUI.canGoBack;
    }
}

-(BOOL)canGoForward{
    
    if (self.isWKWebView) {
        
        return self.webViewWK.canGoForward;
    }
    else{
        
        return self.webViewUI.canGoForward;
    }
}

-(BOOL)isLoading{
    
    if (self.isWKWebView) {
        
        return self.webViewWK.isLoading;
    }
    else{
        
        return self.webViewUI.isLoading;
    }
}

- (void)lt_reload{
    
    if (self.isWKWebView) {
        
        [self.webViewWK reloadFromOrigin];
    }
    else{
        
        [self.webViewUI reload];
    }
}
- (void)lt_stopLoading{
    
    if (self.isWKWebView) {
        
        [self.webViewWK stopLoading];
    }
    else{
        
        [self.webViewUI stopLoading];
    }
}

- (void)lt_goBack{
    
    if (self.isWKWebView) {
        
        [self.webViewWK goBack];
    }
    else{
        
        [self.webViewUI goBack];
    }
}
- (void)lt_goForward{
    
    if (self.isWKWebView) {
        
        [self.webViewWK goForward];
    }
    else{
        
        [self.webViewUI goForward];
    }
}
//
-(void)lt_evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable data, NSError * _Nullable))completionHandler{
    
    if (self.isWKWebView) {
        
        [self.webViewWK evaluateJavaScript:javaScriptString
                         completionHandler:completionHandler];
    }
    else{
        
        NSString *result = [self.webViewUI stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (completionHandler) {
            completionHandler(result,nil);
        }
    }
}
#pragma mark LTUIWebViewDelegate
-(void)webView:(LTUIWebView *)webView didChangedProgress:(CGFloat)progress{

    [self lt_webView:self
     loadingProgress:progress];
}
#pragma mark LTWebViewDelegate
- (void)lt_webViewDidStartLoad:(UIView *)webView {
    
    NSLog(@"lt_webViewDidStartLoad");
    if ([self.delegate respondsToSelector:@selector(ltwebViewDidStartLoad:)]) {
        
        [self.delegate ltwebViewDidStartLoad:self];
    }
}

- (void)lt_webViewDidFinishLoad:(UIView *)webView {
    NSLog(@"lt_webViewDidFinishLoad");
    if ([self.delegate respondsToSelector:@selector(ltwebViewDidFinishLoad:)]) {
        
        [self.delegate ltwebViewDidFinishLoad:self];
    }
}

- (BOOL)lt_webView:(UIView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"shouldStartLoadWithRequest");
    if ([self.delegate respondsToSelector:@selector(ltwebView:shouldStartLoadWithRequest:navigationType:)]) {
        
        return [self.delegate ltwebView:self
             shouldStartLoadWithRequest:request
                         navigationType:navigationType];
    }
    return YES;
}

- (void)lt_webView:(UIView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"didFailLoadWithError");
    if ([self.delegate respondsToSelector:@selector(ltwebView:didFailLoadWithError:)]) {
        
        [self.delegate ltwebView:self didFailLoadWithError:error];
    }
}

- (void)lt_webView:(nonnull LTWebView *)webView loadingProgress:(double)progress{
    
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
    
    //NSLog(@"progress=%@",@(progress));
    
    if ([self.delegate respondsToSelector:@selector(ltwebView:loadingProgress:)]) {
        
        [self.delegate ltwebView:webView loadingProgress:progress];
    }

}
#pragma mark UIWebView document.readyState
- (void)startLoading{

    [self lt_webView:self loadingProgress:0.1];
   // [self checkDocumentReadyState];
}

- (void)endLoading{
    
    [self lt_webView:self loadingProgress:1.0];
}

- (void)checkDocumentReadyState{

    NSString *readyState = [self.webViewUI stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    NSLog(@"---------readyState=%@",readyState);
    
    if ([readyState isEqualToString:@"uninitialized"]) {
        
        [self lt_webView:self loadingProgress:0.1];
    }
    else if ([readyState isEqualToString:@"loading"]) {
        
        [self lt_webView:self loadingProgress:0.4];
    }
    else if ([readyState isEqualToString:@"loaded"]) {
        
        [self lt_webView:self loadingProgress:0.6];
    }
    else if ([readyState isEqualToString:@"interactive"]) {
        
        [self lt_webView:self loadingProgress:0.8];
    }
    else if ([readyState isEqualToString:@"complete"]){
        
        [self lt_webView:self loadingProgress:1.0];
    }
    
    if (loadingCount>0) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self checkDocumentReadyState];
        });
    }
}
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
   
    loadingCount++;
    if (loadingCount == 1) {
        
        [self startLoading];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self lt_webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    
    loadingCount--;
    
    if (loadingCount == 0) {
        
        [self endLoading];
    }
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    // 禁用用户选择
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self lt_webViewDidFinishLoad:webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return [self lt_webView:webView
 shouldStartLoadWithRequest:request
             navigationType:navigationType];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    loadingCount--;
    
    if (loadingCount == 0) {
        
        [self endLoading];
    }
    
    [self lt_webView:webView didFailLoadWithError:error];
}

#pragma mark- WKNavigationDelegate
/*! @abstract 决定是否允许或者取消一个navigationAction
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //NSLog(@"决定是否允许=%@",navigationAction.request);
    BOOL allow = [self lt_webView:webView
       shouldStartLoadWithRequest:navigationAction.request
                   navigationType:(NSInteger)navigationAction.navigationType];
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
    
    NSLog(@"开始加载");
    [self lt_webViewDidStartLoad:webView];
}

/*! @abstract 接收到重定向
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"接收到重定向");
}

/*! @abstract 加载失败
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"加载失败");
    [self lt_webView:webView didFailLoadWithError:error];
}

/*! @abstract 开始接收数据
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"开始接收数据");
}

/*! @abstract 加载完成
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"加载完成");
    self.title = webView.title;
    
    [self lt_webViewDidFinishLoad:webView];
}

/*! @abstract 错误发生.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"error==%@",error);
    [self lt_webView:webView didFailLoadWithError:error];
}

/*! @abstract webview 需要证书校验
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
//
//    NSLog(@"需要证书校验");
//}

/*! @abstract webview 内容处理终止
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0){
    
    NSLog(@"内容处理终止");
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
    
    NSLog(@"关闭页面");
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
    
    NSLog(@"message=%@",message);
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

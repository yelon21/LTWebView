//
//  LTUIWebView.m
//  Pods
//
//  Created by yelon on 17/1/10.
//
//

#import "LTUIWebView.h"

@interface UIWebView ()

- (id)webView:(UIView *)sender
identifierForInitialRequest:(NSURLRequest *)request
fromDataSource:(id)dataSource;

- (void)webView:(UIView *)sender
       resource:(id)identifier
didReceiveResponse:(NSURLResponse *)response
 fromDataSource:(id)dataSource;

- (void)webView:(UIView *)sender
       resource:(id)identifier
didReceiveContentLength:(NSInteger)length
 fromDataSource:(id)dataSource;

- (void)webView:(UIView *)sender
       resource:(id)identifier
didFinishLoadingFromDataSource:(id)dataSource;

- (void)webView:(UIView *)sender
plugInFailedWithError:(NSError *)error
     dataSource:(id)dataSource;

- (void)webView:(UIView *)sender
       resource:(id)identifier
didFailLoadingWithError:(NSError *)error
 fromDataSource:(id)dataSource;
@end

@implementation LTUIWebView

- (void)updateProgress{

    if ([self.ltDelegate respondsToSelector:@selector(webView:didChangedProgress:)]
        &&resourceTotoalCount>0) {
        
        CGFloat loadedCount = resourceLoadedCount*1.0;
        CGFloat progress = loadedCount/resourceTotoalCount;
        
        [self.ltDelegate webView:self didChangedProgress:progress];
    }
}

- (id)webView:(UIView *)sender
identifierForInitialRequest:(NSURLRequest *)request
fromDataSource:(id)dataSource{
    
    resourceTotoalCount++;
    
    [self updateProgress];
    
    return [super webView:sender
identifierForInitialRequest:request
    fromDataSource:dataSource];
}

- (void)webView:(UIView *)sender
       resource:(id)identifier
didFinishLoadingFromDataSource:(id)dataSource{

    resourceLoadedCount++;
    [self updateProgress];
    
    [super webView:sender
          resource:identifier
didFinishLoadingFromDataSource:dataSource];
}

- (void)webView:(UIView *)sender
       resource:(id)identifier
didFailLoadingWithError:(NSError *)error
 fromDataSource:(id)dataSource{

    resourceLoadedCount++;
    [self updateProgress];
    
    [super webView:sender
          resource:identifier
didFailLoadingWithError:error
    fromDataSource:dataSource];
}

/*
 - (void)webView:(UIView *)sender
 resource:(id)identifier
 didReceiveResponse:(NSURLResponse *)response
 fromDataSource:(id)dataSource{
 
 [super webView:sender
 resource:identifier
 didReceiveResponse:response
 fromDataSource:dataSource];
 }
 
 - (void)webView:(UIView *)sender
 resource:(id)identifier
 didReceiveContentLength:(NSInteger)length
 fromDataSource:(id)dataSource{
 
 [super webView:sender
 resource:identifier
 didReceiveContentLength:length
 fromDataSource:dataSource];
 }
 
 - (void)webView:(UIView *)sender
 plugInFailedWithError:(NSError *)error
 dataSource:(id)dataSource{
 
 [super webView:sender
 plugInFailedWithError:error
 dataSource:dataSource];
 }
 
 */


/*
- (void)webView:(WebView *)sender
       resource:(id)identifier
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
 fromDataSource:(WebDataSource *)dataSource;

- (void)webView:(WebView *)sender
       resource:(id)identifier
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
 fromDataSource:(WebDataSource *)dataSource;

- (NSURLRequest *)webView:(WebView *)sender
                 resource:(id)identifier
          willSendRequest:(NSURLRequest *)request
         redirectResponse:(NSURLResponse *)redirectResponse
           fromDataSource:(WebDataSource *)dataSource;
 */

@end

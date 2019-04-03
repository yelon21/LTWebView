//
//  LTUIWebView.h
//  Pods
//
//  Created by yelon on 17/1/10.
//
//

#import <UIKit/UIKit.h>

@class LTUIWebView;

@protocol LTUIWebViewDelegate <NSObject>

@optional
- (void)webView:(LTUIWebView *)webView didChangedProgress:(CGFloat)progress;

@end

@interface LTUIWebView : UIWebView<UIWebViewDelegate>{
    
    NSUInteger resourceTotoalCount;
    NSUInteger resourceLoadedCount;
}

@property(nonatomic,assign) IBOutlet id<LTUIWebViewDelegate>ltDelegate;

@end

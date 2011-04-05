//
//  WebThumbnailer.m
//  WebThumbnailer
//
//  Created by Ray Hilton on 5/04/11.
//  Copyright 2011 Ray Hilton. All rights reserved.
//

#import "WebThumbnailer.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebThumbnailer

@synthesize delegate;
@synthesize url;
@synthesize cache;
@synthesize context;

-(void)dealloc {
    self.url = nil;
    
    if(webView)
        [webView release];
    
    [super dealloc];
}

-(void)finishOperationWithImage:(UIImage*)image fromCache:(BOOL)fromCache {
    if(self.delegate && [self.delegate respondsToSelector:@selector(webThumbnailer:didGenerateThumbnailForUrl:image:cached:)])
        [self.delegate webThumbnailer:self didGenerateThumbnailForUrl:self.url image:image cached:fromCache];
}

-(void)finishOperationWithoutImage {
    if(self.delegate && [self.delegate respondsToSelector:@selector(webThumbnailer:didNotGenerateThumbnailForUrl:)])
        [self.delegate webThumbnailer:self didNotGenerateThumbnailForUrl:self.url];
}

-(void)generateThumbnail {
    
    if(self.cache) {
        UIImage *image = [self.cache webThumnailerImageForUrl:self.url];
        if(image) {
            [self finishOperationWithImage:image fromCache:YES];
            return;
        }
    }
        
    NSLog(@"WILL generate thumbnail for %@", self.url);
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    webView.userInteractionEnabled = NO;
    webView.delegate = self;
    
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    CGRect rectt = CGRectMake(0, 0, webView.frame.size.width, webView.frame.size.height);
    UIGraphicsBeginImageContext(rectt.size);
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"DID generate thumbnail for %@", self.url);
    
    if(self.cache) 
        [self.cache webThumnailerSetImage:image forUrl:self.url];
    
    [self finishOperationWithImage:image fromCache:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"DID NOT generate thumbnail for %@ because %@", self.url, [error localizedDescription]); 
    [self finishOperationWithoutImage];
}

@end

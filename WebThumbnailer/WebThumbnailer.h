//
//  WebThumbnailer.h
//  WebThumbnailer
//
//  Created by Ray Hilton on 5/04/11.
//  Copyright 2011 Ray Hilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WebThumbnailer;

@protocol WebThumbnailerCache <NSObject>

-(UIImage*)webThumnailerImageForUrl:(NSURL*)url;
-(void)webThumnailerSetImage:(UIImage*)image forUrl:(NSURL*)url;

@end

@protocol WebThumbnailerDelegate <NSObject>

-(void)webThumbnailer:(WebThumbnailer*)thumbnailer didGenerateThumbnailForUrl:(NSURL*)url image:(UIImage*)image cached:(BOOL)cached;
-(void)webThumbnailer:(WebThumbnailer*)thumbnailer didNotGenerateThumbnailForUrl:(NSURL *)url;

@end

@interface WebThumbnailer : NSObject <UIWebViewDelegate> {
    UIWebView *webView;
    id <WebThumbnailerCache> cache;
    id <WebThumbnailerDelegate> delegate;   
    NSURL *url;
    id context;
}

@property (nonatomic, assign) id context;
@property (nonatomic, assign) id <WebThumbnailerCache> cache;
@property (nonatomic, assign) id <WebThumbnailerDelegate> delegate;
@property (nonatomic, retain) NSURL *url;

-(void)generateThumbnail;

@end

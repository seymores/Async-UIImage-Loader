//
//  AsImageView.h
//  Machinima3.0
//
//  Created by Teo Choong Ping on 2/12/10.
//  Copyright 2010 FavoriteMedium.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageCacheManager.h"


@interface AsImageView : UIImageView {
	NSURLConnection  *connection;
	NSMutableData *data;
	NSString *imageUrl;
	BOOL crossFadeEnabled;
}

+ (AsImageView *)imageWithUrl:(NSString *)url;

@property(nonatomic,retain) NSString *imageUrl;
@property(nonatomic,assign) BOOL crossFadeEnabled;

- (void)loadFromURLString:(NSString *)url;
- (void)displayNewImage:(UIImage *)newImage;
- (void)crossfadeImage:(UIImage *)newImage;
- (void)clearImage;
- (void)clearConnection;
- (void)clearURLCache;

@end

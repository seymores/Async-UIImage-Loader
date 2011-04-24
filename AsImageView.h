//  AsImageView.h
//
//  Copyright 2011 Apache License 2.0. All rights reserved.
//

//#import "ImageCacheManager.h"


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

//
//  AsImageView.m
//  Machinima3.0
//
//  Created by Teo Choong Ping on 2/12/10.
//  Copyright 2010 FavoriteMedium.com. All rights reserved.
//

#import "AsImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "DebugLog.h"

@implementation AsImageView

@synthesize imageUrl;
@synthesize crossFadeEnabled;

+ (AsImageView *)imageWithUrl:(NSString *)url {
	AsImageView *img = [[[AsImageView alloc] init] autorelease];
	[img loadFromURLString:url];
	img.crossFadeEnabled = YES;
	return img;
}

- (id)init {
	self = [super init];
	[self setContentMode:UIViewContentModeScaleAspectFit];
	//[self setContentMode:UIViewContentModeScaleAspectFill];
	[self setClipsToBounds:YES];
	return self;
}

- (void)setDefaultImage {
	[self setImage:[UIImage imageNamed:@"blank_case.gif"]];
}

- (void)loadFromURLString:(NSString *)url {
	if(url) {
		[self clearConnection];
		
		UIImage *image = (UIImage *)[ImageCacheManager get:url];
		if (image != nil) {
			[self displayNewImage:image];
			return;
		}
		
		//[self setAlpha:0.2];
		[self setDefaultImage];
		NSURLRequest  *request = [NSURLRequest  requestWithURL:[NSURL URLWithString:url]
												   cachePolicy:NSURLRequestReturnCacheDataElseLoad
												//cachePolicy:NSURLRequestReloadRevalidatingCacheData
											   timeoutInterval:30.0];
		connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	} else {
		[self setDefaultImage];
	}

	self.imageUrl = url;
}

- (void)connection:(NSURLConnection  *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data == nil) {
		data = [[NSMutableData alloc] initWithCapacity:2048];
	}
	[data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection	{
	UIImage *newImg = [UIImage imageWithData:data];
   // [data release];
    
	[self displayNewImage:newImg];
	[ImageCacheManager put:imageUrl objectValue:newImg];

	/*[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];
	[self setAlpha:1.0];
	[UIView commitAnimations];*/
	
	//[self performSelectorOnMainThread:@selector(displayNewImage:) withObject:newImg waitUntilDone:NO];
	//NSLog(@" [INFO] AsImageView load complete: %@", [connection description]);
	[self clearURLCache];
}

- (void)displayNewImage:(UIImage *)newImage {
	if(self.crossFadeEnabled) {
		[self crossfadeImage:newImage];
	}
	[self setImage:newImage];
	//[self setAlpha:1.0];
}

- (void)clearURLCache {
	NSURLCache *cache = [NSURLCache sharedURLCache];
	[cache setDiskCapacity:0];
	[cache setMemoryCapacity:0];
}

- (void)clearImage {
	[self setDefaultImage];
	[self setImageUrl:nil];
	[self clearConnection];
	//NSLog(@" %s : Image cleared", __FUNCTION__);
}

- (void)clearConnection {
	if (connection != nil) {
		[connection cancel];
		[connection release];
		[data release];
		connection = nil;
		data = nil;
	}
}

- (void)crossfadeImage:(UIImage *)newImage {
	CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
	crossFade.duration = 0.4;
	crossFade.fromValue = (id)self.image.CGImage;
	crossFade.toValue = (id)newImage.CGImage;
	[self.layer addAnimation:crossFade forKey:@"animateContents"];
}

- (void)dealloc {
	[data release];
	[connection release];
	[imageUrl release];
	[super dealloc];
}

@end

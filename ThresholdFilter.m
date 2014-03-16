//
//  ThresholdFilter.m
//  Threshold
//
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "ThresholdFilter.h"

@implementation ThresholdFilter

- (void) initPlugin
{
}

- (long) filterImage:(NSString *)menuName {
	windowController = [[ThresholdController alloc] initWithViewer:viewerController];
	[windowController showWindow:self];
	return 0;
}

@end

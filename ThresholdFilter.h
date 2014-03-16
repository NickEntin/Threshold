//
//  ThresholdFilter.h
//  Threshold
//
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import "ThresholdController.h"

@interface ThresholdFilter : PluginFilter {
    ThresholdController* windowController;
}

- (long) filterImage:(NSString*) menuName;

@end

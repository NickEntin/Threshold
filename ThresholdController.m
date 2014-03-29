//
//  ThresholdController.m
//  Threshold
//
//  Created by Nick Entin on 6/10/13.
//
//

#import "ThresholdController.h"

@interface ThresholdController ()

@end

@implementation ThresholdController

const int MAX_HU = 1000;
const int MIN_HU = -1000;

- (id)initWithViewer:(ViewerController *)vc {
    NSLog(@"Loading threshold plugin...");
    
    [super initWithWindowNibName:@"ThresholdWindow"];
    [[self window] setDelegate:self];
    [[self window] setLevel:NSFloatingWindowLevel];
    [[self window] makeFirstResponder:[self window]];
    
    viewerController = vc;
	imageView = [viewerController imageView];
    seriesROIList = [viewerController roiList];
    
    [slider1 setMinValue:MIN_HU];
    [slider1 setMaxValue:MAX_HU];
    [slider2 setMinValue:MIN_HU];
    [slider2 setMaxValue:MAX_HU];
    
//    [self generatePixelList];
    
    return self;
}

//- (void)generatePixelList {
//    NSLog(@"-[ThresholdController generatePixelList];");
//    
//    long roiDataSize;
//    DCMPix *curPix;
//    
//    for (int z = 0 ; z < [seriesROIList count] ; z++) {
//        curPix = [[viewerController pixList] objectAtIndex:z];
//        
//        NSMutableArray *roiImageList = [seriesROIList objectAtIndex:z];
//        ROI *scanROI = [viewerController newROI:tROI];
//        NSRect scanRect = NSMakeRect(0, 0, 512, 512);
//        [scanROI setROIRect:scanRect];
//        [roiImageList addObject:scanROI];
//        [pixels addObject:[curPix getROIValue:&roiDataSize :scanROI :0L]];
//    }
//}

- (void)drawOverlays {
    NSLog(@"-[ThresholdController drawOverlays];");
    
    if ([rangeTypeSelector selectedColumn] == 0) {
        min = [slider1 intValue];
        max = MAX_HU;
    } else if ([rangeTypeSelector selectedColumn] == 1) {
        min = MIN_HU;
        max = [slider1 intValue];
    } else {
        min = [slider1 intValue];
        max = [slider2 intValue];
    }
    
    if ([sliceSelector selectedColumn] == 0) {
        [self drawOverlayOnSlice:[[viewerController imageView] curImage]];
    } else {
        for (int z = 0 ; z < [[viewerController pixList] count] ; z++) {
            [self drawOverlayOnSlice:z];
        }
    }
    
    [[viewerController imageView] updateImage];
}

- (void)drawOverlayOnSlice:(int)slice {
    NSLog(@"-[ThresholdController drawOverlaysOnSlice:%d];", slice);
    
    // Create Texture Buffer
    unsigned char* textureBuffer = malloc(512 * 512 * sizeof(unsigned char));
    
//    float *curPixels = [pixels objectAtIndex:slice];
    long roiDataSize;
    DCMPix *curPix = [[viewerController pixList] objectAtIndex:slice];
    NSMutableArray *roiImageList = [seriesROIList objectAtIndex:slice];
    ROI *scanROI = [viewerController newROI:tROI];
    NSRect scanRect = NSMakeRect(0, 0, 512, 512);
    [scanROI setROIRect:scanRect];
    [roiImageList addObject:scanROI];
    float *curPixels = [curPix getROIValue:&roiDataSize :scanROI :0L];
    
    for (int i = 0 ; i < 262144 ; i++) {
        if (curPixels[i]>=min && curPixels[i]<=max) {
            textureBuffer[i] = 0xFF;
        } else {
            textureBuffer[i] = 0x00;
        }
    }
    
    /*
    if ([[[[[viewerController roiList] objectAtIndex:slice] lastObject] name] isEqualToString:@"ThresholdTexture"]) {
        [[[viewerController roiList] objectAtIndex:slice] removeLastObject];
    }
     */
    [[[viewerController roiList] objectAtIndex:slice] removeAllObjects];
    
    ROI* roi = [viewerController newROI:tPlain];
//    float pixelSpacingX = [[[viewerController roiList] objectAtIndex:[[viewerController imageView] curImage]] pixelSpacingX];
//    float pixelSpacingY = [[[viewerController roiList] objectAtIndex:[[viewerController imageView] curImage]] pixelSpacingY];
    float pixelSpacingX = 0.683594, pixelSpacingY = 0.683594;
    [roi initWithTexture:textureBuffer textWidth:512 textHeight:512 textName:@"Texture" positionX:0 positionY:0 spacingX:pixelSpacingX spacingY:pixelSpacingY imageOrigin:NSMakePoint(0,0)];
    [roi setName:@"ThresholdTexture"];
    [[[viewerController roiList] objectAtIndex:slice] addObject:roi];
    
    free(textureBuffer);
}

- (IBAction)sliceSelectorChanged:(id)sender {
    [self drawOverlays];
}
- (IBAction)rangeTypeSelectorChanged:(id)sender {
    [slider2 setHidden:([sender selectedColumn] != 2)];
    [label2 setHidden:([sender selectedColumn] != 2)];
    [self drawOverlays];
    NSLog(@"Selected column: %d",([sender selectedColumn] != 2));
}
- (IBAction)slider1Changed:(id)sender {
    [self drawOverlays];
    [label1 setStringValue:[NSString stringWithFormat:@"%d",[sender intValue]]];
}
- (IBAction)slider2Changed:(id)sender {
    [self drawOverlays];
    [label2 setStringValue:[NSString stringWithFormat:@"%d",[sender intValue]]];
}

@end

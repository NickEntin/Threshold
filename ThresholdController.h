//
//  ThresholdController.h
//  Threshold
//
//  Created by Nick Entin on 6/10/13.
//
//

#import <Cocoa/Cocoa.h>
#import <OsiriXAPI/ViewerController.h>
#import <OsiriXAPI/DCMView.h>
#import <OsiriXAPI/ROI.h>
#import <OsiriXAPI/DCMPix.h>

@interface ThresholdController : NSWindowController <NSWindowDelegate> {
    IBOutlet NSMatrix *sliceSelector;
    IBOutlet NSMatrix *rangeTypeSelector;
    IBOutlet NSSlider *slider1;
    IBOutlet NSSlider *slider2;
    IBOutlet NSTextField *label1;
    IBOutlet NSTextField *label2;
    
    int max, min;
    
    NSMutableArray *pixels;
    
    ViewerController *viewerController;
	DCMView *imageView;
    NSMutableArray *seriesROIList;
}

- (id)initWithViewer:(ViewerController *)vc;

- (IBAction)sliceSelectorChanged:(id)sender;
- (IBAction)rangeTypeSelectorChanged:(id)sender;
- (IBAction)slider1Changed:(id)sender;
- (IBAction)slider2Changed:(id)sender;

- (void)drawOverlays;
- (void)drawOverlayOnSlice:(int)slice;

@end

//
//  BIDViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/14/14.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class CIDetector;

@interface BIDViewController : UIViewController
<UIGestureRecognizerDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate>
{
    IBOutlet UIView *previewView;
	IBOutlet UISegmentedControl *camerasControl;
	AVCaptureVideoPreviewLayer *previewLayer;
	AVCaptureVideoDataOutput *videoDataOutput;
	dispatch_queue_t videoDataOutputQueue;
	AVCaptureStillImageOutput *stillImageOutput;
	UIView *flashView;
	UIImage *square;
	BOOL isUsingFrontFacingCamera;
    CGImageRef cgImageResult;
    BOOL isPictureTaken;
	CIDetector *faceDetector;
    CIDetector *smileDetector;
	CGFloat beginGestureScale;
	CGFloat effectiveScale;
}

- (IBAction)switchCameras:(id)sender;
- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender;
@end

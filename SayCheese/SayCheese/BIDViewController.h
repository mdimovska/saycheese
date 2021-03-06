//
//  BIDViewController.h
//  SayCheese
//
//  Created by Milena Dimovska on 8/14/14.
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
    IBOutlet UIView *topView;
    IBOutlet UIButton *switchButton;
	IBOutlet UISegmentedControl *camerasControl;
	AVCaptureVideoPreviewLayer *previewLayer;
	AVCaptureVideoDataOutput *videoDataOutput;
	dispatch_queue_t videoDataOutputQueue;
	AVCaptureStillImageOutput *stillImageOutput;
	UIView *flashView;
	UIImage *square;
	BOOL isUsingFrontFacingCamera;
    CGImageRef cgImageResult;
    NSData *jpegData;
    BOOL isPictureTaken;
	CIDetector *faceDetector;
    CIDetector *smileDetector;
	CGFloat beginGestureScale;
	CGFloat effectiveScale;
}

- (IBAction)switchCameras:(id)sender;
- (IBAction)handlePinchGesture:(UIGestureRecognizer *)sender;
@end

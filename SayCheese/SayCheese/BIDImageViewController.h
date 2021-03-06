//
//  BIDImageViewController.h
//  SayCheese
//
//  Created by Milena Dimovska on 8/15/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface BIDImageViewController : UIViewController <UIActionSheetDelegate>
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSData *jpegData;
@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@property (strong, nonatomic) IBOutlet UIToolbar* toolbar;
- (IBAction)deletePhotoActionSheet:(id)sender;
- (IBAction)sharePhoto:(id)sender;
@end

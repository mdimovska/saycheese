//
//  BIDImageViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/15/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
@interface BIDImageViewController : UIViewController <UIActionSheetDelegate>
@property (retain, nonatomic) UIImage *image;
@property (strong, nonatomic) NSData *jpegData;
@property (strong, nonatomic) UIImageView* imageView;
@end

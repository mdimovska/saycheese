//
//  BIDPhotoViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 9/22/14.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface BIDPhotoViewController : UIViewController
- (IBAction)popupController:(id)sender;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
//@property (nonatomic, strong) IBOutlet UILabel *captionLabel; //not neccesary for now
@property (nonatomic, strong) IBOutlet UIButton *numOfLikesLabel;
@property (nonatomic, strong) IBOutlet  AsyncImageView* imageViewFriendPicture;
@property (nonatomic, strong) IBOutlet  AsyncImageView* imageViewFriendUploadedPhoto;
@property (nonatomic, strong) IBOutlet  UIButton* buttonLike;

@property (strong, nonatomic) NSDictionary *photoModel;
@end

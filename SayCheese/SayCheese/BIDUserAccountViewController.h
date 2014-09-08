//
//  BIDUserAccountViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/30/14.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface BIDUserAccountViewController : UIViewController
@property (strong, nonatomic) NSDictionary *userDictionary;
@property (strong, nonatomic) IBOutlet UILabel* userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView* imageViewWhite;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewUserPicture;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewFriendPicture1;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewFriendPicture2;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewFriendPicture3;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewUploadedPhoto1;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewUploadedPhoto2;
@property (strong, nonatomic) IBOutlet UILabel* labelNameFriendPicture1;
@property (strong, nonatomic) IBOutlet UILabel* labelNameFriendPicture2;
@property (strong, nonatomic) IBOutlet UILabel* labelNameFriendPicture3;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;

@property (strong, nonatomic) IBOutlet UIButton* buttonFriends;
@property (strong, nonatomic) IBOutlet UIButton* buttonPhotos;


- (IBAction)logout:(id)sender;
@end

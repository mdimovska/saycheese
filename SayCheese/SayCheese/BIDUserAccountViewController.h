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
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewUserPicture;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewFriendPicture1;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewFriendPicture2;
@property (strong, nonatomic) IBOutlet AsyncImageView* imageViewFriendPicture3;

- (IBAction)logout:(id)sender;
@end

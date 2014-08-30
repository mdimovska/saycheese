//
//  BIDUserAccountViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/30/14.
//
//

#import <UIKit/UIKit.h>

@interface BIDUserAccountViewController : UIViewController
@property (strong, nonatomic) NSDictionary *userDictionary;
@property (strong, nonatomic) IBOutlet UILabel* userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView* imageViewUserPicture;

- (IBAction)logout:(id)sender;
@end

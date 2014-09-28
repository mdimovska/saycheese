//
//  BIDLoginViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/30/14.
//
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"

@interface BIDLoginViewController : UIViewController 

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@end

//
//  BIDAppDelegate.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/14/14.
//
//

#import <UIKit/UIKit.h>
#import "FacebookSDK/FacebookSDK.h"

@interface BIDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
@end

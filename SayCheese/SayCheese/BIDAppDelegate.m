//
//  BIDAppDelegate.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/14/14.
//
//

#import "BIDAppDelegate.h"
#import "FacebookSDK/FacebookSDK.h"
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"

@implementation BIDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UINavigationController *myNavC = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"MainNav"];
    self.window.rootViewController = myNavC;
    
    // FIX THIS:
    //REMOVE THIS LINE
    /*
    UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
    [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"TabBarControllerSequeIdentifier" sender:self];
    */
    
    
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_birthday", @"user_friends"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    return YES;
}
// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         BIDAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [[Utils getInstance] showErrorMessage:alertTitle message: alertText];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                [[Utils getInstance] showErrorMessage:alertTitle message: alertText];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
             
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = @"Please retry";
              //  alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [[Utils getInstance] showErrorMessage:alertTitle message: alertText];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}
-(void) userLoggedIn
{
 //   [self performSegueWithIdentifier:@"InitialViewSegueIdentifier" sender:self];
   // UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary= [prefs dictionaryForKey:@"userInfo"];
    if(!dictionary)
        [self requestUserInfo];
    else{
        UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
        [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"TabBarControllerSequeIdentifier" sender:self];
    }
 //   [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"InitialViewSegueIdentifier" sender:self];
}

-(void) userLoggedOut
{
    //clear user info from prefs
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"userInfo"];
    [prefs setObject:nil forKey:@"userFriends"];

}


- (void)requestUserInfo
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"public_profile", @"user_birthday", @"user_friends"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted, we can request the user information
                                               [self makeRequestForUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
    
    
    
}

- (void) makeRequestForUserData
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithObject:result forKey:@"user"];
            
   
            NSString* pictureUrl = [[Utils getInstance] getFacebookPictureUrl:dictionary[@"user"][@"id"]];
            [dictionary[@"user"] setObject: pictureUrl forKey:@"picture"] ;
            
            NSLog(@"pictureUrl: %@", pictureUrl);
            
            NSLog(@"user info: %@", dictionary );
              NSLog(@"user img: %@", dictionary[@"user"][@"picture"]);
            [prefs setObject:dictionary forKey:@"userInfo"];
            
            [self register:dictionary];
     
    
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
            NSString *alertText;
            NSString *alertTitle;
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
            [[Utils getInstance] showErrorMessage:alertTitle message: alertText];

            [FBSession.activeSession closeAndClearTokenInformation];
            [self userLoggedOut];

        }
    }];
}


-(void) register: (NSMutableDictionary *) dictionary{
    NSLog(@"registering..");
    //POST request

    NSString * url = [[Utils getInstance] getRegisterUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"_id": dictionary[@"user"][@"id"],
                                 @"firstName":dictionary[@"user"][@"first_name"],
                                 @"lastName": dictionary[@"user"][@"last_name"],
                                 @"pictureUrl": dictionary[@"user"][@"picture"]
                                 };
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        //registering (or login) successful
        UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
        [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"TabBarControllerSequeIdentifier" sender:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error registering: %@", error);
        NSString *alertText;
        NSString *alertTitle;
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [[Utils getInstance] showErrorMessage:alertTitle message: alertText];
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [self userLoggedOut];
        
        
        //DELETE THIS!!!
        /*
        UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
        [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"TabBarControllerSequeIdentifier" sender:self];
         */
    }];
}

@end

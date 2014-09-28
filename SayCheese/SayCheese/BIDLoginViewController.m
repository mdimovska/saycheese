//
//  BIDLoginViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/30/14.
//
//

#import "BIDLoginViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "BIDAppDelegate.h"
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"

@interface BIDLoginViewController ()  <FBLoginViewDelegate>

@end

@implementation BIDLoginViewController

@synthesize loginView;
bool isRegistering = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.cs
    
    loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"]; //new
    loginView.delegate = self;
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"loginViewFetchedUserInfo");
    if(!isRegistering){
        isRegistering = YES;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary= [prefs dictionaryForKey:@"userInfo"];
        if(!dictionary)
        {
            NSLog(@"Not logged in");
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            NSString* userId = user.objectID;
            
            [dict setObject: [[Utils getInstance] getFacebookPictureUrl: userId] forKey:@"picture"] ;
            [dict setObject: user.objectID forKey:@"id"] ;
            [dict setObject: user.first_name forKey:@"first_name"] ;
            [dict setObject: user.last_name forKey:@"last_name"] ;
            
            NSLog(@"name: %@", user.first_name);
            
            NSLog(@"user info: %@", dictionary );
            NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithObject:dict forKey:@"user"];
            [prefs setObject:dictionary forKey:@"userInfo"];
            
            [self register:dictionary];
            
        }else{
              NSLog(@"Already logged in");
            
            UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            [self.navigationController pushViewController: myController animated:YES];
        }
    }
    
}


// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShowingLoggedInUser");
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShowingLoggedOutUser");
}

/*
 // Handle possible errors that can occur during login
 - (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
 NSString *alertMessage, *alertTitle;
 
 // If the user should perform an action outside of you app to recover,
 // the SDK will provide a message for the user, you just need to surface it.
 // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
 if ([FBErrorUtility shouldNotifyUserForError:error]) {
 alertTitle = @"Facebook error";
 alertMessage = [FBErrorUtility userMessageForError:error];
 
 // This code will handle session closures that happen outside of the app
 // You can take a look at our error handling guide to know more about it
 // https://developers.facebook.com/docs/ios/errors
 } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
 alertTitle = @"Session Error";
 alertMessage = @"Your current session is no longer valid. Please log in again.";
 
 // If the user has cancelled a login, we will do nothing.
 // You can also choose to show the user a message if cancelling login will result in
 // the user not being able to complete a task they had initiated in your app
 // (like accessing FB-stored information or posting to Facebook)
 } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
 NSLog(@"user cancelled login");
 
 // For simplicity, this sample handles other errors with a generic message
 // You can checkout our error handling guide for more detailed information
 // https://developers.facebook.com/docs/ios/errors
 } else {
 alertTitle  = @"Something went wrong";
 alertMessage = @"Please try again later.";
 NSLog(@"Unexpected error:%@", error);
 }
 
 if (alertMessage) {
 [[[UIAlertView alloc] initWithTitle:alertTitle
 message:alertMessage
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil] show];
 }
 }
 */

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */







//hide the status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//set only portrait orientation

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationPortrait);
}
-(BOOL) shouldAutorotate {
    return YES;
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
         NSLog(@"registering successfully finished");
        NSLog(@"Response: %@", responseObject);
        
        //registering (or login) successful
        
        UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self.navigationController pushViewController: myController animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error registering: %@", error);
        NSString *alertText;
        NSString *alertTitle;
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [[Utils getInstance] showErrorMessage:alertTitle message: alertText];
        
        [FBSession.activeSession closeAndClearTokenInformation];
        // [self userLoggedOut];
        
        
        //DELETE THIS!!!
        /*
         UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
         [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"TabBarControllerSequeIdentifier" sender:self];
         */
    }];
}



@end

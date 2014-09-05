//
//  BIDUserAccountViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/30/14.
//
//

#import "BIDUserAccountViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "BIDAppDelegate.h"
#import "RequestQueue.h"
#import "Utils.h"


@interface BIDUserAccountViewController ()

@end

@implementation BIDUserAccountViewController

@synthesize userDictionary;
@synthesize userNameLabel;
@synthesize imageViewUserPicture;
@synthesize imageViewFriendPicture1;
@synthesize imageViewFriendPicture2;
@synthesize imageViewFriendPicture3;

bool areFriendsLoaded;
NSUserDefaults *prefs;
NSString* userId;


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
    areFriendsLoaded = NO;
    
    //set placeholder image or cell won't update when image is loaded
    imageViewUserPicture.image = [UIImage imageNamed:@"background.jpg"];

    // Do any additional setup after loading the view.
    prefs = [NSUserDefaults standardUserDefaults];
    userDictionary = [prefs dictionaryForKey:@"userInfo"];
    
    if(userDictionary){
        userNameLabel.text = userDictionary[@"user"][@"name"];
        userId = userDictionary[@"user"][@"id"];
        //load the image
        NSURL *URL = [NSURL URLWithString:userDictionary[@"user"][@"picture"]];
        imageViewUserPicture.imageURL = URL;
        
    //    [self getFriends];
    }
    
    
    //navigation bar and status bar changes
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
}

-(void) getFriends{
    NSLog(@"get friends called");
    
    NSURL *URL = [[Utils getInstance] getFriendsUrl:userId];
    NSLog(userId);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    RQOperation *operation = [RQOperation operationWithRequest:request];
    //add response handler
    operation.completionHandler = ^(__unused NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            areFriendsLoaded = NO;
        }
        else
        {
            // convert to JSON
            NSError *myError = nil;
            NSMutableData* responseData = [NSMutableData data];
            [responseData appendData:data];

            NSArray *friendsArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
            
            if(myError){
                areFriendsLoaded = NO;
                return;
            }
        
            areFriendsLoaded = YES;
          //  NSDictionary *user1 = [friendsArray objectAtIndex:0];
            
            NSLog(@"getting friends finished");
            
            [prefs setObject:friendsArray forKey:@"userFriends"];
            
            [self fillFriendsImageViews:friendsArray];
         
        }
    };
    
    //make request
    [[RequestQueue mainQueue] addOperation:operation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void) fillFriendsImageViews:(NSArray*) friendsArray{

    if([friendsArray count] > 0){
        imageViewFriendPicture1.image = [UIImage imageNamed:@"squarePNG.png"];
        NSDictionary *user1 = [friendsArray objectAtIndex:0];
        NSURL *URL = [NSURL URLWithString:user1[@"pictureUrl"]];
        imageViewFriendPicture1.imageURL = URL;
    }
    if([friendsArray count] > 1){
        imageViewFriendPicture2.image = [UIImage imageNamed:@"squarePNG.png"];
        NSDictionary *user2 = [friendsArray objectAtIndex:1];
        NSURL *URL = [NSURL URLWithString:user2[@"pictureUrl"]];
        imageViewFriendPicture2.imageURL = URL;
    }
    if([friendsArray count] > 2){
        imageViewFriendPicture3.image = [UIImage imageNamed:@"squarePNG.png"];
        NSDictionary *user3 = [friendsArray objectAtIndex:2];
        NSURL *URL = [NSURL URLWithString:user3[@"pictureUrl"]];
        imageViewFriendPicture3.imageURL = URL;
    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!areFriendsLoaded)
        [self getFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (IBAction)logout:(id)sender{
    [FBSession.activeSession closeAndClearTokenInformation];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"userInfo"];
    [prefs setObject:nil forKey:@"userFriends"];

    UIViewController *loginViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginViewController"];
    [[self navigationController] pushViewController:loginViewController
                                           animated:YES];
    
    
}
@end

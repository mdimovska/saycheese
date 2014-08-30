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

@interface BIDUserAccountViewController ()

@end

@implementation BIDUserAccountViewController

@synthesize userDictionary;
@synthesize userNameLabel;
@synthesize imageViewUserPicture;


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
    // Do any additional setup after loading the view.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    userDictionary = [prefs dictionaryForKey:@"userInfo"];
    if(userDictionary){
        userNameLabel.text = userDictionary[@"user"][@"name"];
    }
    else{
        //TODO: go to login view controller
        /*
        UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
        [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"LoginControllerSegueIdentifier" sender:self];
         */
        
    }
    
    
    //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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

//set only portrait orientation

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (IBAction)logout:(id)sender{
    [FBSession.activeSession closeAndClearTokenInformation];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"userInfo"];

    UIViewController *loginViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginViewController"];
    [[self navigationController] pushViewController:loginViewController
                                           animated:YES];
    
    
}
@end

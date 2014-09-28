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
#import "AFHTTPRequestOperationManager.h"
#import "Utils.h"


@interface BIDUserAccountViewController ()

@end

@implementation BIDUserAccountViewController

@synthesize userDictionary;
@synthesize userNameLabel;
@synthesize imageViewWhite;
@synthesize imageViewUserPicture;
@synthesize imageViewFriendPicture1;
@synthesize imageViewFriendPicture2;
@synthesize imageViewFriendPicture3;
@synthesize imageViewUploadedPhoto1;
@synthesize imageViewUploadedPhoto2;
@synthesize labelNameFriendPicture1;
@synthesize labelNameFriendPicture2;
@synthesize labelNameFriendPicture3;
@synthesize buttonFriends;
@synthesize buttonPhotos;
@synthesize  scrollView;

NSArray *friendsArray;
NSArray *photosArray;
bool areFriendsLoaded;
bool arePhotosLoaded;
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
    arePhotosLoaded = NO;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    //set placeholder image or cell won't update when image is loaded
    imageViewUserPicture.image = [UIImage imageNamed:@"default_user1.jpg"];
    imageViewUploadedPhoto1.image = [UIImage imageNamed:@"default_user1.jpg"];
    imageViewUploadedPhoto2.image = [UIImage imageNamed:@"default_user1.jpg"];
    
    // Do any additional setup after loading the view.
    prefs = [NSUserDefaults standardUserDefaults];
    userDictionary = [[Utils getInstance]getUserDictionary];
    
    if(userDictionary){
        userNameLabel.text = userDictionary[@"user"][@"name"];
        userId = userDictionary[@"user"][@"id"];
        //load the image
        NSURL *URL =[[Utils getInstance]makePictureUrl:
             userId];
        imageViewUserPicture.imageURL = URL;
        imageViewUploadedPhoto1.clipsToBounds = YES;
        imageViewUploadedPhoto2.clipsToBounds = YES;
      
    }
    
    scrollView.contentSize = CGSizeMake(320, 600);
    
    
    //navigation bar and status bar changes
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    [[Utils getInstance] setImageViewRound:imageViewUserPicture];
    [[Utils getInstance] setImageViewRound:imageViewFriendPicture1];
    [[Utils getInstance] setImageViewRound:imageViewFriendPicture2];
    [[Utils getInstance] setImageViewRound:imageViewFriendPicture3];
    [[Utils getInstance] setImageViewRound:imageViewWhite];
}

-(void) getFriends{
    NSLog(@"getting friends");
    NSLog(@"userId: %@", userId);
    
    NSString *url = [[Utils getInstance] getFriendsUrl: userId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"getting friends finished");
        NSLog(@"JSON (friends): %@", responseObject);
        
        friendsArray = responseObject;
        
        areFriendsLoaded = YES;
        
        [prefs setObject:friendsArray forKey:@"userFriends"];
        
        [self fillFriendsImageViews];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting friends: %@", error);
        [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not get user info"]; //?
        areFriendsLoaded = NO;
    }];
}


-(void) getPhotos{
    NSLog(@"getting photos");
    
    NSString *url = [[Utils getInstance] getUserPhotos: userId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"getting photos finished");
        NSLog(@"JSON (photos): %@", responseObject);
        
        photosArray = responseObject;
        
        arePhotosLoaded = YES;
        
        [prefs setObject:photosArray forKey:@"userPhotos"];
        
        [self fillPhotosImageViews];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting user photos: %@", error);
        [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not get user photos"]; //?
        arePhotosLoaded = NO;
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void) clearFriends
{
    imageViewFriendPicture1.image = nil;
    imageViewFriendPicture2.image = nil;
    imageViewFriendPicture3.image = nil;
    labelNameFriendPicture1.text = @"";
    labelNameFriendPicture2.text = @"";
    labelNameFriendPicture3.text = @"";
}

-(void) fillFriendsImageViews{
    [self clearFriends];
    
    if([friendsArray count] > 0){
        imageViewFriendPicture1.image = [UIImage imageNamed:@"default_user1.jpg"];
        NSDictionary *user1 = [friendsArray objectAtIndex: [friendsArray count]-1];
        // NSURL *URL = [NSURL URLWithString:user1[@"pictureUrl"]];
        NSURL *URL = [NSURL URLWithString:user1[@"pictureUrl"]];
        URL=  [[Utils getInstance]makePictureUrl:user1[@"userId"]]; //FIX: REMOVE THIS
        imageViewFriendPicture1.imageURL = URL;
        labelNameFriendPicture1.text = user1[@"firstName"];
    }
    if([friendsArray count] > 1){
        imageViewFriendPicture2.image = [UIImage imageNamed:@"default_user.jpg"];
        NSDictionary *user2 = [friendsArray objectAtIndex:[friendsArray count]-2];
        NSURL *URL = [NSURL URLWithString:user2[@"pictureUrl"]];
        [[Utils getInstance]makePictureUrl:user2[@"userId"]];
        imageViewFriendPicture2.imageURL = URL;
        labelNameFriendPicture2.text = user2[@"firstName"];
    }
    if([friendsArray count] > 2){
        imageViewFriendPicture3.image = [UIImage imageNamed:@"default_user.jpg"];
        NSDictionary *user3 = [friendsArray objectAtIndex:[friendsArray count]-3];
        NSURL *URL = [NSURL URLWithString:user3[@"pictureUrl"]];
        [[Utils getInstance]makePictureUrl:user3[@"userId"]];
        imageViewFriendPicture3.imageURL = URL;
        labelNameFriendPicture3.text = user3[@"firstName"];
    }
    [buttonFriends setTitle:[NSString stringWithFormat:@"Friends (%d)", [friendsArray count]] forState:UIControlStateNormal];
}

-(void) fillPhotosImageViews{
    // [self clearFriends];
    
    if([photosArray count] > 0){
        imageViewUploadedPhoto1.image = [UIImage imageNamed:@"default_user1.jpg"];
        NSDictionary *photo = [photosArray objectAtIndex: [photosArray count]-1];
        
       NSURL * URL=  [[Utils getInstance]getSaycheesePictureUrl:photo[@"photoUrl"] userId:userId];
        imageViewUploadedPhoto1.imageURL = URL;
    }
    if([photosArray count] > 1){
        imageViewUploadedPhoto2.image = [UIImage imageNamed:@"default_user1.jpg"];
        NSDictionary *photo = [photosArray objectAtIndex: [photosArray count]-2];
        
        NSURL *URL = [NSURL URLWithString:photo[@"photoUrl"]];
        URL=  [[Utils getInstance]getSaycheesePictureUrl:photo[@"photoUrl"] userId:userId];
        imageViewUploadedPhoto2.imageURL = URL;
        
    }
    [buttonPhotos setTitle:[NSString stringWithFormat:@"Photos (%d)", [photosArray count]] forState:UIControlStateNormal];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    if(!areFriendsLoaded)
        [self getFriends];
    else{
        friendsArray = [[Utils getInstance] getUserFriendsFromPrefs];
        [self fillFriendsImageViews];
    }
    */
    //  if(!arePhotosLoaded)
    [self getFriends];
    [self getPhotos];
    //   else{
    //  photosArray = [[Utils getInstance] get];
    //     [self fillFriendsImageViews:friendsArray];
    //  }
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
    return UIStatusBarStyleLightContent;
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

//
//  BIDPhotoViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 9/22/14.
//
//

#import "BIDPhotoViewController.h"
#import "Utils.h"
#import "TTTTimeIntervalFormatter.h"
#import "AFHTTPRequestOperationManager.h"
#import "FacebookSDK/FacebookSDK.h"
#import "LeveyPopListView.h"

@implementation BIDPhotoViewController
@synthesize photoModel;
@synthesize buttonLike;
@synthesize dateLabel;
@synthesize nameLabel;
@synthesize imageViewFriendPicture;
@synthesize imageViewFriendUploadedPhoto;
@synthesize numOfLikesLabel;
NSString * userIdInPhotoController = @"";
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary * a = [NSDictionary dictionaryWithDictionary:photoModel];
    userIdInPhotoController = [[Utils getInstance] getLoggedInUserId];
    if(nil != photoModel){
        [self initViews];
    }
    
    
    [self.navigationItem setHidesBackButton:YES];

    
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //black transparent status bar
    //this covers navigation bar too
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,800, 64)]; //20 only for status bar
    view.backgroundColor= [UIColor  colorWithRed:((float) 0.0f)
                                           green:((float) 0.0f)
                                            blue:((float) 0.0f)
                                           alpha:0.5];
    
  
   // [self.view addSubview:view];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];

    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

-(void) initViews{
    [numOfLikesLabel setEnabled:YES];
    [numOfLikesLabel addTarget:self action:@selector(showLikesPopup:) forControlEvents:UIControlEventTouchUpInside];
    
    bool likeFromUserExists = NO;
    
    [buttonLike addTarget:self action:@selector(addOrRemoveLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if(photoModel[@"likes"] != nil){
        NSArray * likesArray = photoModel[@"likes"];
        if([likesArray count]==1)
            [numOfLikesLabel setTitle:[NSString stringWithFormat:@"%lu like", (unsigned long)[likesArray count]] forState:UIControlStateNormal] ;
        else
        [numOfLikesLabel setTitle:[NSString stringWithFormat:@"%lu likes", (unsigned long)[likesArray count]] forState:UIControlStateNormal] ;
        for(NSDictionary* likeDictionary in likesArray){
            if([likeDictionary[@"userId"] isEqualToString:userIdInPhotoController])
            {
                likeFromUserExists = YES;
            }
        }
    }else{
        [numOfLikesLabel setTitle: @"0 likes" forState:UIControlStateNormal] ;
    }
    
  //  [buttonLike setNeedsLayout];
  //  [cell setNeedsLayout];

    
    if(
       likeFromUserExists)
    {
        [ buttonLike setImage:[UIImage imageNamed:@"like_icon_green.png"] forState:UIControlStateNormal];
    }
    else
    {
        [ buttonLike setImage:[UIImage imageNamed:@"like_icon.png"] forState:UIControlStateNormal];
    }
    
    NSString* formattedDate =[self formatDate:photoModel[@"dateTaken"]];
    dateLabel.text = formattedDate ;
    
    nameLabel.text = [[photoModel[@"firstName"] stringByAppendingString: @" "] stringByAppendingString:photoModel[@"lastName"]];
    
    [[Utils getInstance] setImageViewRound:imageViewFriendPicture];
    
    imageViewFriendPicture.image = [UIImage imageNamed:@"default_user1.jpg"];
    
    imageViewFriendPicture.imageURL = [[Utils getInstance]makePictureUrl:photoModel[@"userId"]];
    
    imageViewFriendUploadedPhoto.image = [UIImage imageNamed:@"default_user1.jpg"]; //loading.....
    NSURL *photoUrl =[[Utils getInstance] getSaycheesePictureUrl:photoModel[@"photoUrl"] userId:photoModel[@"userId"]];
    
    imageViewFriendUploadedPhoto.imageURL = photoUrl;
}

- (NSString *)formatDate:(NSString *)rfc3339DateTimeString {
    
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Convert the RFC 3339 date time string to an NSDate.
    NSDate *result = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    
    NSTimeInterval secondsSinceNow = [[NSDate date] timeIntervalSinceDate:result];
    TTTTimeIntervalFormatter *timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    //   [timeIntervalFormatter setUsesIdiomaticDeicticExpressions:YES];
    [timeIntervalFormatter setPresentTimeIntervalMargin:10];
    [timeIntervalFormatter setFutureDeicticExpression:@"ago"];
    return  [timeIntervalFormatter stringForTimeInterval:secondsSinceNow];
    //return result;
}

-(void) showLikesPopup: (id) sender{
 
    NSMutableArray* options = [[NSMutableArray alloc]init];
    
    if(photoModel[@"likes"] != nil){
        NSMutableArray * likesArray = photoModel[@"likes"];
        
        
        for(NSMutableDictionary* likeDictionary in likesArray){
            NSString* imgUrl =[[Utils getInstance] getFacebookPictureUrl:likeDictionary[@"userId"]];
            //NSString* imgUrl = [UIImage imageNamed:@"Icon-76.png"];
            [options addObject: [NSDictionary dictionaryWithObjectsAndKeys:imgUrl,@"img", likeDictionary[@"firstName"],@"text", nil]];
            
        }
    }
    
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"Likes" options:options handler:^(NSInteger anIndex) {
        //  _infoLabel.text = [NSString stringWithFormat:@"You have selected %@", _options[anIndex]];
    }];
    //    lplv.delegate = self;
    [lplv showInView:self.view animated:YES];
    
}

- (IBAction)popupController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

//
//  BIDNewsFeedTableViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 9/7/14.
//
//

#import "BIDNewsFeedTableViewController.h"
#import "BIDNewsFeedTableViewCell.h"
#import "Utils.h"
#import "RequestQueue.h"
#import "TTTTimeIntervalFormatter.h"

@interface BIDNewsFeedTableViewController ()

@end

@implementation BIDNewsFeedTableViewController

@synthesize newsFeedArray;
NSString* userId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userId = [[Utils getInstance]getLoggedInUserId];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.view.backgroundColor = [[Utils getInstance]greenColor];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    self.navigationController.navigationBar.barTintColor = [[Utils getInstance]greenColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.topItem.title = @"News";
    newsFeedArray = [[Utils getInstance]getUserFriendsFromPrefs];
   // [self.tableView reloadData];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 //   if(!areFriendsLoaded)
        [self getNewsFeed];
  //  else{
      //  friendsArray = [[Utils getInstance] getUserFriendsFromPrefs];
        //[self fillFriendsImageViews:friendsArray];
    //}
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsFeedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newsFeedTableCell";
    
    BIDNewsFeedTableViewCell *cell = [tableView
                                      dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BIDNewsFeedTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSMutableDictionary *result =[newsFeedArray objectAtIndex: [indexPath row]];
    NSLog( result[@"dateTaken"] );
    NSString* formattedDate =[self formatDate:result[@"dateTaken"]];
    NSLog(formattedDate);
    cell.nameLabel.text = [[result[@"firstName"] stringByAppendingString: @" "] stringByAppendingString:result[@"lastName"]];
    cell.dateLabel.text = formattedDate ;
    [[Utils getInstance] setImageViewRound:cell.imageViewFriendPicture];
    
    cell.imageViewFriendPicture.image = [UIImage imageNamed:@"default_user1.jpg"];
  
    cell.imageViewFriendPicture.imageURL = [[Utils getInstance]makePictureUrl:result[@"userId"]];
    
    cell.imageViewFriendUploadedPhoto.image = [UIImage imageNamed:@"default_user1.jpg"]; //loading.....
    cell.imageViewFriendUploadedPhoto.imageURL = [NSURL URLWithString:result[@"photoUrl"]];;
    
    return cell;
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
/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) getNewsFeed{
    NSLog(@"loading news feed");
    
    NSURL *URL = [[Utils getInstance] getNewsFeedUrl:userId];
    NSLog(@"userId: %@", userId);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    RQOperation *operation = [RQOperation operationWithRequest:request];
    //add response handler
    operation.completionHandler = ^(__unused NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error)
        {
            [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not load news feed"]; //?
           // areFriendsLoaded = NO;
        }
        else
        {
            NSError *myError = nil;
            NSMutableData* responseData = [NSMutableData data];
            [responseData appendData:data];
            
            newsFeedArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
            
            if(myError){
               // areFriendsLoaded = NO;
                return;
            }
            
          //  areFriendsLoaded = YES;
            
            NSLog(@"loading news feed finished");
            
           // [prefs setObject:friendsArray forKey:@"userFriends"];
            
           // [self fillFriendsImageViews:friendsArray];
            [self.tableView reloadData];
        }
    };
    
    //make request
    [[RequestQueue mainQueue] addOperation:operation];
}

@end

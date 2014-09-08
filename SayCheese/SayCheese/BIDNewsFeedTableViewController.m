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
NSDictionary* userDictionary;
bool isLikeRequestSending;

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
    [self.tabBarController.navigationItem setHidesBackButton:YES];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    newsFeedArray = [[NSMutableArray alloc] init];
    
    userId = [[Utils getInstance]getLoggedInUserId];
    userDictionary = [[Utils getInstance]getUserDictionary];
    
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
    isLikeRequestSending = NO;
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.topItem.title = @"Say cheese";
    newsFeedArray = [[Utils getInstance]getUserFriendsFromPrefs];
    [self.navigationItem setHidesBackButton:YES];
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
    [self.tableView reloadData];

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
    [cell.buttonLike setEnabled:YES];
    cell.buttonLike.tag = [indexPath row];
    
    bool likeFromUserExists = NO;
    
    [cell.buttonLike addTarget:self action:@selector(addOrRemoveLikeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSMutableDictionary *result =[newsFeedArray objectAtIndex: [indexPath row]];
    if(result[@"likes"] != nil){
        NSArray * likesArray = result[@"likes"];
        cell.numOfLikesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[likesArray count]] ;
        for(NSDictionary* likeDictionary in likesArray){
            if([likeDictionary[@"userId"] isEqualToString:userId])
            {
                likeFromUserExists = YES;
            }
        }
    }else{
        cell.numOfLikesLabel.text = @"0";
    }
    
    [cell.buttonLike setNeedsLayout];
    [cell setNeedsLayout];
   // [cell layoutIfNeeded];
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    if(
       likeFromUserExists)
    {
        [ cell.buttonLike setImage:[UIImage imageNamed:@"like_icon_green.png"] forState:UIControlStateNormal];
    }
    else
    {
        [ cell.buttonLike setImage:[UIImage imageNamed:@"like_icon.png"] forState:UIControlStateNormal];
    }
    cell.buttonLike.tag = [indexPath row];
    
    NSString* formattedDate =[self formatDate:result[@"dateTaken"]];
    cell.dateLabel.text = formattedDate ;
    
    cell.nameLabel.text = [[result[@"firstName"] stringByAppendingString: @" "] stringByAppendingString:result[@"lastName"]];
    
    [[Utils getInstance] setImageViewRound:cell.imageViewFriendPicture];
    
    cell.imageViewFriendPicture.image = [UIImage imageNamed:@"default_user1.jpg"];
    
    cell.imageViewFriendPicture.imageURL = [[Utils getInstance]makePictureUrl:result[@"userId"]];
    
    cell.imageViewFriendUploadedPhoto.image = [UIImage imageNamed:@"default_user1.jpg"]; //loading.....
    NSURL *photoUrl =[[Utils getInstance] getSaycheesePictureUrl:result[@"photoUrl"] userId:result[@"userId"]];
    
     cell.imageViewFriendUploadedPhoto.imageURL = photoUrl;
    
    CGFloat width = 245.0;
    CGFloat height = 480.0 * 245.0/320.0;
    if(result[@"photoWidth"]!=nil && result[@"photoHeight"]!=nil){
        width =  [result[@"photoWidth"] floatValue];
        height= [result[@"photoHeight"] floatValue];
    }
    
    cell.imageViewFriendUploadedPhoto.frame = CGRectMake(cell.imageViewFriendUploadedPhoto.frame.origin.x, cell.imageViewFriendUploadedPhoto.frame.origin.y, width , height);
    
    
   
  
    return cell;
}
/*
- (UITableViewCell *)tableView:estimatedHeightForRowAtIndexPath: (NSIndexPath *) indexPath {
    static BIDNewsFeedTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"newsFeedTableCell"];
    });
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    return size.height;
}
*/



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
        return [self heightForImageCellAtIndexPath:indexPath];
}

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* result = [newsFeedArray objectAtIndex:[indexPath row]];
    CGFloat width = 245.0;
    CGFloat height = 480.0 * 245.0/320.0;
    if(result[@"photoWidth"]!=nil && result[@"photoHeight"]!=nil){
        width =  [result[@"photoWidth"] floatValue];
        height= [result[@"photoHeight"] floatValue];
    }
    return 100 + height;
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)addOrRemoveLikeClicked:(id)sender {
    if(!isLikeRequestSending){
        [sender setEnabled:NO];
        isLikeRequestSending = YES;
        NSInteger rowIndex = [sender tag];
        NSString* photoId;
        NSMutableDictionary *newsFeedDictionary =[newsFeedArray objectAtIndex: rowIndex];
        photoId = newsFeedDictionary[@"_id"];
        NSLog(@"adding/removing like");
        NSLog(@"photo id: %@", photoId);
        NSLog(@"user id: %@", userId);
        
        NSString* firstName =userDictionary[@"user"][@"first_name"];
        NSString* lastName =userDictionary[@"user"][@"last_name"];
        //post request for adding friend...
        
        
        NSURL *URL = [[Utils getInstance] addRemoveLikeUrl];
        NSString *post = [NSString stringWithFormat:@"&userId=%@&photoId=%@&firstName=%@&lastName=%@", userId, photoId, firstName, lastName];
        
        NSData *postData =   [post dataUsingEncoding:NSUTF8StringEncoding];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        RQOperation *operation = [RQOperation operationWithRequest:request];
        //add response handler
        operation.completionHandler = ^(__unused NSURLResponse *response, NSData *data, NSError *error)
        {
            if (error)
            {
                //   [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not send friend request"];
                isLikeRequestSending = NO;
                [sender setEnabled:YES];
            }
            else
            {
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                NSInteger code = [httpResponse statusCode];
                
                if(code == 200){
                    [self addOrRemoveLikeInArray:rowIndex userId:userId firstName:firstName lastName: lastName];
                    [self.tableView reloadData];
                }
                else
                {
                    
                }
                [sender setEnabled:YES];
                isLikeRequestSending = NO;
                
            }
        };
        //make request
        [[RequestQueue mainQueue] addOperation:operation];
    }
}

-(void) addOrRemoveLikeInArray: (NSInteger) rowIndex userId:(NSString*) userId firstName: (NSString*) firstName lastName: (NSString*) lastName
{
    NSMutableDictionary *result =[newsFeedArray objectAtIndex: rowIndex];
    if(result[@"likes"] != nil){
        NSMutableArray * likesArray = result[@"likes"];
        NSMutableDictionary * like = nil;
        for(NSMutableDictionary* likeDictionary in likesArray){
            if([likeDictionary[@"userId"] isEqualToString:userId])
            {
                like = [NSMutableDictionary dictionaryWithDictionary:likeDictionary];
                break;
            }
        }
        if(like != nil){
            //exists -> should be removed
            
            NSMutableArray*  likesArrayNew = [likesArray mutableCopy];
            [likesArrayNew removeObject:like];
            
            NSMutableDictionary* requestsArrayNew = [result mutableCopy];
            [requestsArrayNew removeObjectForKey:@"likes"];
            [requestsArrayNew setObject:likesArrayNew forKey:@"likes"];
            result = [[NSMutableDictionary alloc] init];
            result = [NSMutableDictionary dictionaryWithDictionary:requestsArrayNew];
            
            NSMutableArray* newsFeedArrayNew = [newsFeedArray mutableCopy];
            
            [newsFeedArrayNew setObject:result atIndexedSubscript:rowIndex];
            newsFeedArray = [[NSMutableArray alloc] init];
            newsFeedArray = [NSMutableArray arrayWithArray:newsFeedArrayNew];
            
            NSLog(@"like successfully removed");
        }else{
            //add like
            like = [[NSMutableDictionary alloc] init];
            [like setObject:userId forKey:@"userId"];
            [like setObject:firstName forKey:@"firstName"];
            [like setObject:lastName forKey:@"lastName"];
            
            NSMutableArray*  likesArrayNew = [likesArray mutableCopy];
            [likesArrayNew addObject:like];
            
            NSMutableDictionary* requestsArrayNew = [result mutableCopy];
            [requestsArrayNew removeObjectForKey:@"likes"];
            [requestsArrayNew setObject:likesArrayNew forKey:@"likes"];
            result = [[NSMutableDictionary alloc] init];
            result = [NSMutableDictionary dictionaryWithDictionary:requestsArrayNew];
            
            NSMutableArray* newsFeedArrayNew = [newsFeedArray mutableCopy];
            
            [newsFeedArrayNew setObject:result atIndexedSubscript:rowIndex];
            newsFeedArray = [[NSMutableArray alloc] init];
            newsFeedArray = [NSMutableArray arrayWithArray:newsFeedArrayNew];
            
            //  [newsFeedArray addObject:like];
            NSLog(@"like successfully added");
        }
    }
    
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

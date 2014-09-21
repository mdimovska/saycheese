//
//  BIDAddFriendsTableViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import "BIDAddFriendsTableViewController.h"
#import "FacebookSDK/FacebookSDK.h"
#import "BIDAddFriendsTableViewCell.h"
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"

@interface BIDAddFriendsTableViewController ()

@end

@implementation BIDAddFriendsTableViewController

@synthesize friendsToAddArray;
@synthesize facebookFriendsArray;
@synthesize pendingFriendsArray;

NSString* userId = @"";
bool isFriendRequestSending;
bool isCancelRequestSent;

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
    isFriendRequestSending = NO;
    isCancelRequestSent = NO;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    // self.navigationController.navigationBar.topItem.title = @"Friends";
    facebookFriendsArray = [[NSMutableArray alloc] init];
    pendingFriendsArray = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
    
    
    userId = [[Utils getInstance]getLoggedInUserId];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self requestUserFriends];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"Find friends";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section==0)
        return [friendsToAddArray count];
    else
        return [pendingFriendsArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"addFriendsTableCell";
    
    BIDAddFriendsTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BIDAddFriendsTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
          }
    NSMutableDictionary *result;
    
    //add click handler and button tag (tag = number of row clicked)
    cell.addButton.tag = [indexPath row];
    
    //   [cell.addButton addTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    if(indexPath.section == 0)//add
    {
        [cell.addButton setEnabled:YES];
        [cell.addButton setHidden:NO];
        result =[friendsToAddArray objectAtIndex: [indexPath row]];
        [cell.addButton addTarget:self action:@selector(addFriendClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else //pending
    {
        result =[pendingFriendsArray objectAtIndex: [indexPath row]];
        [cell.addButton setEnabled:NO];
        [cell.addButton setHidden:YES];
        
        //      [cell.addButton  addTarget:self action:@selector(cancelPendingClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.nameLabel.text = [[result[@"firstName"] stringByAppendingString: @" "] stringByAppendingString:result[@"lastName"]];
    [[Utils getInstance] setImageViewRound:cell.imageViewFriendPicture];
    
     //set temporaty img until image is loaded
    cell.imageViewFriendPicture.image = [UIImage imageNamed:@"default_user1.jpg"];
    NSURL *URL = [NSURL URLWithString: result[@"pictureUrl"]];
    cell.imageViewFriendPicture.imageURL = URL;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)//friends to add
        return NO;
    
    return YES; //pending requests
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self cancelPendingClicked: indexPath.row];
        
        //  if(!isRemoveFromFriendsRequestSent){
        //    [self removeUserFromFriends:indexPath];
        //    }
        // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // [prefs setObject:favouritesArray forKey:@"favouritesArray"];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

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


- (void)requestUserFriends
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"user_friends"];
    
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
                                               [self makeRequestForUserFriends];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                               NSLog(@"error %@", error.description);
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestForUserFriends];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                          }];
}

- (void) makeRequestForUserFriends
{
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              /* handle the result */
                              
                              if (!error) {
                                  
                                  NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithObject:result forKey:@"result"];
                                  
                                  
                                  facebookFriendsArray = dictionary[@"result"][@"data"]; //[ {id,name} ... ]
                                  
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                      [self findFriendsToAdd];
                                      
                                  });
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                                  [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not get facebook friends"];
                              }
                              
                              
                          }];
}

-(void) findFriendsToAdd
{
    NSLog(@"finding friends to add..");
    //POST request
    
    if([facebookFriendsArray count]<=0) return;
    
    NSString* friendsIdList = @"";
    for (NSDictionary *facebookFriendsArrayElement in facebookFriendsArray) {
        friendsIdList = [[friendsIdList stringByAppendingString:@" "] stringByAppendingString:facebookFriendsArrayElement[@"id"]];
    }
    NSLog(@"Friends id list: %@", friendsIdList);
    NSString * url = [[Utils getInstance] findFriendsUrl: userId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"fbContacts": friendsIdList };
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON (find friends): %@", responseObject);
        
        NSDictionary* responseDictionary = (NSDictionary*)responseObject;
        friendsToAddArray = responseDictionary[@"add"];
        pendingFriendsArray = responseDictionary[@"pending"];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error finding friends: %@", error);
        [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not get saycheese users"];
        
    }];
    
}

- (void)addFriendClicked:(id)sender {
    if(!isFriendRequestSending){
        [sender setEnabled:NO];
        isFriendRequestSending = YES;
        NSInteger rowIndex = [sender tag];
        NSString* contactId;
        NSMutableDictionary *contactDictionary =[friendsToAddArray objectAtIndex: rowIndex];
        contactId = contactDictionary[@"userId"];
        NSLog(@"sending friend request");
        NSLog(@"Contact id: %@", contactId);
        NSLog(@"User id: %@", userId);
        
        //post request for adding friend...
        
        NSString * url = [[Utils getInstance] addContactUrl];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{ @"userId": userId,
                                      @"contactId": contactId
                                    };
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSInteger code = [[operation response] statusCode];
            
            if(code == 200){
                NSLog(@"friend request from user %@ to user %@ successfully sent", userId, contactId);
                [self removeFriendAndReloadData:rowIndex];
            }
            else
            {
                
            }
            [sender setEnabled:YES];
            isFriendRequestSending = NO;

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error adding friend: %@", error);
            [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not send friend request"];
            isFriendRequestSending = NO;
            [sender setEnabled:YES];
        }];
        
    }
}


- (void)cancelPendingClicked:(NSInteger)rowIndex {
    if(!isCancelRequestSent){
        //  [sender setEnabled:NO];
        isCancelRequestSent = YES;
        //NSInteger rowIndex = [sender tag];
        
        NSString* contactId;
        NSMutableDictionary *contactDictionary =[pendingFriendsArray objectAtIndex: rowIndex];
        contactId = contactDictionary[@"userId"];
        
        NSLog(@"canceling request");
        NSLog(@"Contact id: %@", contactId);
        NSLog(@"User id: %@", userId);
       
        //post request for canceling friend request...
   
        NSString * url = [[Utils getInstance] removeContactOrPendingRequestUrl];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"userId": userId,
                                     @"contactId": contactId
                                     };
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            
            NSInteger code = [[operation response] statusCode];
            
            if(200 == code)
            {
                NSLog(@"request from user %@ to user %@ successfully canceled", userId, contactId);
                [self removePendingRequestAndReloadData:rowIndex];
            }
            else
            {
                
            }
            //   [sender setEnabled:YES];
            isCancelRequestSent = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error canceling friend request: %@", error);
            [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not cancel request"];
            isCancelRequestSent = NO;
        }];
        
    }
}

//customize header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string ;
    if(section==0)
        string = @"Add friends";
    else
        string = @"Pending requests";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.2]]; //your background color...
    return view;
}

-(void) removeFriendAndReloadData:(NSInteger) rowIndex
{
    // [friendsToAddArray removeObjectAtIndex:indexPath.row];
    
    // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //remove friend from  pending list and add to list with friends to add
    
    NSMutableArray *requestsArrayNew = [pendingFriendsArray mutableCopy];
    NSMutableDictionary * dictionaryUserToBeTransferred =[friendsToAddArray objectAtIndex:rowIndex];
    [requestsArrayNew addObject:dictionaryUserToBeTransferred];
    pendingFriendsArray = [[NSMutableArray alloc] init];
    pendingFriendsArray = [NSMutableArray arrayWithArray:requestsArrayNew];
    
    requestsArrayNew = [friendsToAddArray mutableCopy];
    [requestsArrayNew removeObjectAtIndex: rowIndex];
    friendsToAddArray = [[NSMutableArray alloc] init];
    friendsToAddArray = [NSMutableArray arrayWithArray:requestsArrayNew];

    int num= [pendingFriendsArray count];
    int s=num-1;
    
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow: s inSection:1],
                                 nil];
    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:rowIndex inSection:0],
                                 nil];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
}

-(void) removePendingRequestAndReloadData:(NSInteger) rowIndex
{
    
    //remove friend from  pending list and add to list with friends to add
    NSMutableArray *requestsArrayNew = [friendsToAddArray mutableCopy];
    NSMutableDictionary * dictionaryUserToBeTransferred =[pendingFriendsArray objectAtIndex:rowIndex];
    [requestsArrayNew addObject:dictionaryUserToBeTransferred];
    friendsToAddArray = [[NSMutableArray alloc] init];
    friendsToAddArray = [NSMutableArray arrayWithArray:requestsArrayNew];
    
    requestsArrayNew = [pendingFriendsArray mutableCopy];
    [requestsArrayNew removeObjectAtIndex: rowIndex];
    pendingFriendsArray = [[NSMutableArray alloc] init];
    pendingFriendsArray = [NSMutableArray arrayWithArray:requestsArrayNew];
    
    int num= [friendsToAddArray count];
    int s=num-1;
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:s inSection:0],
                                 nil];
    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:rowIndex inSection:1],
                                 nil];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationPortrait);
}

@end

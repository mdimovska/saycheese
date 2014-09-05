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
#import "RequestQueue.h"

@interface BIDAddFriendsTableViewController ()

@end

@implementation BIDAddFriendsTableViewController

@synthesize friendsToAddArray;
@synthesize facebookFriendsArray;
@synthesize pendingFriendsArray;

NSString* userId = @"";
bool isFriendRequestSent;
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
    isFriendRequestSent = NO;
    isCancelRequestSent = NO;
   // self.navigationController.navigationBar.topItem.title = @"Friends";
    facebookFriendsArray = [[NSMutableArray alloc] init];
    pendingFriendsArray = [[NSMutableArray alloc] init];
    
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSDictionary * userDictionary = [prefs dictionaryForKey:@"userInfo"];
    
    if(userDictionary){
        userId = userDictionary[@"user"][@"id"];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self requestUserFriends];

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
    cell.addButton.tag = indexPath.row;
    if(indexPath.section == 0)//add
    {
        result =[friendsToAddArray objectAtIndex: [indexPath row]];
        [cell.addButton addTarget:self action:@selector(addFriendClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else //pending
    {
        result =[pendingFriendsArray objectAtIndex: [indexPath row]];
        [cell.addButton addTarget:self action:@selector(cancelPendingClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
  cell.nameLabel.text = [[result[@"firstName"] stringByAppendingString: @" "] stringByAppendingString:result[@"lastName"]];
    
    //set temporaty img until image is loaded
    cell.imageViewFriendPicture.image = [UIImage imageNamed:@"squarePNG.png"];
    NSURL *URL = [NSURL URLWithString: result[@"pictureUrl"]];
    cell.imageViewFriendPicture.imageURL = URL;
   
    return cell;
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
                                  
                                  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                                  NSMutableDictionary *dictionary=[NSMutableDictionary dictionaryWithObject:result forKey:@"result"];
                                
                                  
                                facebookFriendsArray = dictionary[@"result"][@"data"]; //[ {id,name} ... ]
                           //     [self.tableView reloadData];
                                
                               //   NSDictionary *a = [array objectAtIndex:0];
                                    NSLog([facebookFriendsArray objectAtIndex:0][@"id"]);
                                   //       NSLog(a[@"name"]);
                                  
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                      [self findFriendsToAdd];

                                  });
                                //  [self findFriendsToAdd];
                                  
                                  /*
                                  NSLog(@"pictureUrl: %@", pictureUrl);
                                  
                                  NSLog(@"user info: %@", dictionary );
                                  NSLog(@"user img: %@", dictionary[@"user"][@"picture"]);
                                  [prefs setObject:dictionary forKey:@"userInfo"];
                                  
                                  
                                  UINavigationController *navigationController = (UINavigationController*) self.window.rootViewController;
                                  [[[navigationController viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"TabBarControllerSequeIdentifier" sender:self];
                                  
                                  */
                                  
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog(@"error %@", error.description);
                              }
                              
                              
                          }];
}

-(void) findFriendsToAdd
{
    NSLog(@"finding friends to add..");
    //POST request
        NSURL *URL = [[Utils getInstance] findFriendsUrl:userId];
        
        if([facebookFriendsArray count]<=0) return;
        
        NSString* friendsIdList = @"";
        for (NSDictionary *facebookFriendsArrayElement in facebookFriendsArray) {
            friendsIdList = [[friendsIdList stringByAppendingString:@" "] stringByAppendingString:facebookFriendsArrayElement[@"id"]];
        }
        
   
        NSString *post = [NSString stringWithFormat:@"&fbContacts=%@", friendsIdList];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
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
                NSString *alertText;
                NSString *alertTitle;
                alertTitle = @"Something went wrong";
                alertText = [FBErrorUtility userMessageForError:error];
                [self showMessage:alertText withTitle:alertTitle];
            }
            else
            {
                // convert to JSON
                NSError *myError = nil;
                NSMutableData* responseData = [NSMutableData data];
                [responseData appendData:data];
                
                NSDictionary* resObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
                
                friendsToAddArray = resObject[@"add"];
                pendingFriendsArray = resObject[@"pending"];
                NSLog(@"resObject: %@", resObject);
                
                
                [self.tableView reloadData];
            }
        };
        
        //make request
        [[RequestQueue mainQueue] addOperation:operation];
    
}

-(void)showMessage:(NSString*)alertText withTitle:(NSString*)alertTitle
{
    [[[UIAlertView alloc] initWithTitle:alertTitle
                                message:alertText
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)addFriendClicked:(id)sender {
    if(!isFriendRequestSent){
         NSInteger rowIndex = [sender tag];
        NSString* contactId;
        NSMutableDictionary *contactDictionary =[friendsToAddArray objectAtIndex: rowIndex];
        contactId = contactDictionary[@"_id"];
        NSLog(@"Contact id: %@", contactId);
        NSLog(@"User id: %@", userId);
        
        [sender setEnabled:NO];
        
        
        //post request for adding friend...
        NSLog(@"sending friend request");
        
        NSURL *URL = [[Utils getInstance] addContactUrl];
        NSString *post = [NSString stringWithFormat:@"&userId=%@&contactId=%@", userId, contactId];
        
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
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                isFriendRequestSent = NO;
                [sender setEnabled:YES];
            }
            else
            {
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                NSInteger code = [httpResponse statusCode];
                
                if(code!= nil && code == 200){
                    NSLog(@"friend request from user %@ to user %@ successfully sent", userId, contactId);
                    [self removeFriendAndReloadData:rowIndex];
               }
               else
               {
                   
                }
                [sender setEnabled:YES];
                isFriendRequestSent = NO;

            }
        };
        //make request
        [[RequestQueue mainQueue] addOperation:operation];
    }
}


- (void)cancelPendingClicked:(id)sender {
    if(!isCancelRequestSent){
        NSInteger rowIndex = [sender tag];
       
        NSString* contactId;
         NSMutableDictionary *contactDictionary =[pendingFriendsArray objectAtIndex: rowIndex];
        contactId = contactDictionary[@"userId"];
        NSLog(@"Contact id: %@", contactId);
        NSLog(@"User id: %@", userId);
        
        [sender setEnabled:NO];
        
        
        //post request for adding friend...
        NSLog(@"sending friend request");
        
        NSURL *URL = [[Utils getInstance] removeContactOrPendingRequestUrl];
        NSString *post = [NSString stringWithFormat:@"&userId=%@&contactId=%@", userId, contactId];
        
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
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                isCancelRequestSent = NO;
                [sender setEnabled:YES];
            }
            else
            {
                
                
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                NSInteger code = [httpResponse statusCode];
                
                if(200 == code)
                {
                     NSLog(@"request from user %@ to user %@ successfully canceled", userId, contactId);
                    [self removePendingRequestAndReloadData:rowIndex];
                }
                else
                {
                    
                }
                [sender setEnabled:YES];
                isCancelRequestSent = NO;
            }
        };
        //make request
        [[RequestQueue mainQueue] addOperation:operation];
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

-(void) removeFriendAndReloadData:(NSInteger*) rowIndex
{
    //remove friend from  pending list and add to list with friends to add
    NSMutableArray *resuestsArrayNew = [pendingFriendsArray mutableCopy];
    NSMutableDictionary * dictionaryUserToBeTransferred =[friendsToAddArray objectAtIndex:rowIndex];
    [resuestsArrayNew addObject:dictionaryUserToBeTransferred];
    pendingFriendsArray = [NSMutableArray arrayWithArray:resuestsArrayNew];
    
    resuestsArrayNew = [friendsToAddArray mutableCopy];
    [resuestsArrayNew removeObjectAtIndex: rowIndex];
    friendsToAddArray = [NSMutableArray arrayWithArray:resuestsArrayNew];
    [self.tableView reloadData];

}

-(void) removePendingRequestAndReloadData:(NSInteger*) rowIndex
{
    //remove friend from  pending list and add to list with friends to add
    NSMutableArray *resuestsArrayNew = [friendsToAddArray mutableCopy];
    NSMutableDictionary * dictionaryUserToBeTransferred =[pendingFriendsArray objectAtIndex:rowIndex];
    [resuestsArrayNew addObject:dictionaryUserToBeTransferred];
    friendsToAddArray = [NSMutableArray arrayWithArray:resuestsArrayNew];
    
    resuestsArrayNew = [pendingFriendsArray mutableCopy];
    [resuestsArrayNew removeObjectAtIndex: rowIndex];
    pendingFriendsArray = [NSMutableArray arrayWithArray:resuestsArrayNew];
    [self.tableView reloadData];
}

@end

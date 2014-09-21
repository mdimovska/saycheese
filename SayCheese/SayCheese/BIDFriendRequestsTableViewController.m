//
//  BIDFriendRequestsTableViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 9/5/14.
//

#import "BIDFriendRequestsTableViewController.h"
#import "BIDFriendRequestsTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "Utils.h"

@interface BIDFriendRequestsTableViewController ()

@end

@implementation BIDFriendRequestsTableViewController

@synthesize friendRequestsArray;
NSString* userId1 = @"";
bool hasTaskStarted;
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
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    isCancelRequestSent = NO;
    hasTaskStarted = NO;
    friendRequestsArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary * userDictionary = [prefs dictionaryForKey:@"userInfo"];
    
    if(userDictionary){
        userId1 = userDictionary[@"user"][@"id"];
    }
    
    [self getFriendRequests];
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"Friend requests";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(friendRequestsArray != nil)
        return [friendRequestsArray count];
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendRequestsTableCell";
    
    BIDFriendRequestsTableViewCell *cell = [tableView
                                        dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BIDFriendRequestsTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSMutableDictionary *result;
    
    //add click handler and button tag (tag = number of row clicked)
    cell.addButton.tag = indexPath.row;
        result =[friendRequestsArray objectAtIndex: [indexPath row]];
        [cell.addButton addTarget:self action:@selector(acceptFriendClicked:) forControlEvents:UIControlEventTouchUpInside];

    cell.nameLabel.text = [[result[@"firstName"] stringByAppendingString: @" "] stringByAppendingString:result[@"lastName"]];
    
    [[Utils getInstance] setImageViewRound:cell.imageViewFriendPicture];
    cell.imageViewFriendPicture.image = [UIImage imageNamed:@"default_user1.jpg"];
    NSURL *URL = [NSURL URLWithString: result[@"pictureUrl"]];
    cell.imageViewFriendPicture.imageURL = URL;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self cancelPendingClicked: indexPath];
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

-(void) getFriendRequests{
    NSLog(@"get friend requests called");
    
    NSString *url = [[Utils getInstance] getFriendRequestsUrl:userId1];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        friendRequestsArray = responseObject;
        
        if(friendRequestsArray != nil){
            NSLog(@"getting friend requests finished");
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting friend requests: %@", error);
        [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not get friend requests"];
    }];
            
}

- (void)acceptFriendClicked: (id)sender {
    if(!hasTaskStarted){
        hasTaskStarted = YES;
        NSInteger rowIndex = [sender tag];
        NSString* contactId;
        NSMutableDictionary *contactDictionary =[friendRequestsArray objectAtIndex: rowIndex];
        contactId = contactDictionary[@"userId"];
        NSLog(@"Contact id: %@", contactId);
        NSLog(@"User id: %@", userId1);
        
        [sender setEnabled:NO];
        
        //post request for adding friend...
        NSLog(@"sending friend request");
        
        NSString *url = [[Utils getInstance] acceptFriendUrl:userId1];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{ @"contactId": contactId };
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            
            NSInteger code = [[operation response] statusCode];
            
            if(200 == code){
                NSLog(@"friend %@ accepted" , contactId);
              //  [self removeFriendRequestAndReloadData:rowIndex];
                //remove friend from requests list (users are friends now!)
                NSMutableArray * requestsArrayNew = [friendRequestsArray mutableCopy];
                
                NSMutableArray* userFriendsArray = [[Utils getInstance] getUserFriendsFromPrefs];
                NSMutableDictionary * dictionaryFriend =[requestsArrayNew objectAtIndex:rowIndex];
                [userFriendsArray addObject:dictionaryFriend];
                
                
                [requestsArrayNew removeObjectAtIndex: rowIndex];
                friendRequestsArray = [[NSMutableArray alloc] init];
                friendRequestsArray = [NSMutableArray arrayWithArray:requestsArrayNew];
                
                // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                //new
                /*
                 
                NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                             [NSIndexPath indexPathForRow:rowIndex inSection:0],
                                             nil];
                
                 
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
                */
                [self.tableView reloadData];
                
                [[Utils getInstance]setUserFriendsToPrefs:userFriendsArray];
            }
            else
            {
                
            }
            [sender setEnabled:YES];
            hasTaskStarted = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error accepting friend request: %@", error);
            [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not confirm friendship"];
            
            hasTaskStarted = NO;
            [sender setEnabled:YES];
        }
         ];
        //[sender setEnabled:YES];
        
            }
}
-(void) removeFriendRequestAndReloadData:(NSInteger) rowIndex
{
    //remove friend from requests list (users are friends now!)
    NSMutableArray * requestsArrayNew = [friendRequestsArray mutableCopy];
 
    NSMutableArray* userFriendsArray = [[Utils getInstance] getUserFriendsFromPrefs];
    NSMutableDictionary * dictionaryFriend =[requestsArrayNew objectAtIndex:rowIndex];
    [userFriendsArray addObject:dictionaryFriend];
    [[Utils getInstance]setUserFriendsToPrefs:userFriendsArray];
    
    [requestsArrayNew removeObjectAtIndex: rowIndex];
    friendRequestsArray = [[NSMutableArray alloc] init];
    friendRequestsArray = [NSMutableArray arrayWithArray:requestsArrayNew];
    
   // [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //new
    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:rowIndex inSection:0],
                                 nil];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationPortrait);
}


- (void)cancelPendingClicked:(NSIndexPath *)indexPath {
    if(!isCancelRequestSent){
        //  [sender setEnabled:NO];
        isCancelRequestSent = YES;
        //NSInteger rowIndex = [sender tag];
        
        NSString* contactId;
        NSMutableDictionary *contactDictionary =[friendRequestsArray objectAtIndex: [indexPath row]];
        contactId = contactDictionary[@"userId"];
        
        NSLog(@"canceling friend request");
        NSLog(@"Contact id: %@", contactId);
        NSString* userId = [[Utils getInstance] getLoggedInUserId];
        NSLog(@"User id: %@", userId);
        
        //post request for cancel pending request...
        
        NSString *url = [[Utils getInstance] removeContactOrPendingRequestUrl];
        
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
                NSLog(@"request successfully canceled");
                NSMutableArray*  requestsArrayNew = [friendRequestsArray mutableCopy];
                [requestsArrayNew removeObjectAtIndex: indexPath.row];
                friendRequestsArray = [[NSMutableArray alloc] init];
                friendRequestsArray = [NSMutableArray arrayWithArray:requestsArrayNew];
                
                
                NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                             [NSIndexPath indexPathForRow:indexPath.row inSection:0],
                                             nil];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
                //update userPreferences
                
            }
            else
            {
            }
            //   [sender setEnabled:YES];
            isCancelRequestSent = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error canceling request: %@", error);
            [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not cancel request"];
            isCancelRequestSent = NO;
          }
        ];
        //[sender setEnabled:YES];
    }
}

@end

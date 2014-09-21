//
//  BIDFriendsTableViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import "BIDFriendsTableViewController.h"
#import "BIDFriendsTableViewCell.h"
#import "Utils.h"
#import "AFHTTPRequestOperationManager.h"

@interface BIDFriendsTableViewController ()

@end

@implementation BIDFriendsTableViewController

@synthesize friendsArray;

bool isRemoveFromFriendsRequestSent;
NSString* userIdInFriendsController = @"";

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
    
    userIdInFriendsController = [[Utils getInstance]getLoggedInUserId];
    
    isRemoveFromFriendsRequestSent = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //navigation bar style (transparent navigation bar)
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
    
    [self setNavigationBarItems];
}

-(void) setNavigationBarItems
{
    UIImage* image = [[UIImage imageNamed:@"icon_add_friends.png" ] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *friendRequestsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_friend_requests.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goToFriendRequestsController:)];
  
    UIBarButtonItem * addFriendsItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(goToAddFriendsController:)];
    
    NSArray *actionButtonItems = @[addFriendsItem, friendRequestsItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void)goToAddFriendsController:(id)sender
{
 [[[self.navigationController viewControllers] lastObject] performSegueWithIdentifier:@"addFriendsSegueIdentifier" sender:self];
}

- (void)goToFriendRequestsController:(id)sender
{
     [[[self.navigationController viewControllers] lastObject] performSegueWithIdentifier:@"friendRequestsSegueIdentifier" sender:self];
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
    self.navigationController.navigationBar.topItem.title = @"Friends";
     friendsArray = [[Utils getInstance]getUserFriendsFromPrefs];
    [self.tableView reloadData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    // Return the number of rows in the section.
    return [friendsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendsTableCell";
    
    BIDFriendsTableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BIDFriendsTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
     }
    NSMutableDictionary *result =[friendsArray objectAtIndex: [indexPath row]];
    
    cell.nameLabel.text = [[result[@"firstName"] stringByAppendingString: @" "] stringByAppendingString:result[@"lastName"]];
    //set temporaty img until image is loaded
    [[Utils getInstance] setImageViewRound:cell.imageViewFriendPicture];
    
    cell.imageViewFriendPicture.image = [UIImage imageNamed:@"default_user1.jpg"];
    NSURL *URL = [NSURL URLWithString:result[@"pictureUrl"]];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if(!isRemoveFromFriendsRequestSent){
            [self removeUserFromFriends:indexPath];
        }
       // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
       // [prefs setObject:favouritesArray forKey:@"favouritesArray"];
    }
}



- (void)removeUserFromFriends: (NSIndexPath *)indexPath
{
    if(!isRemoveFromFriendsRequestSent){
        isRemoveFromFriendsRequestSent = YES;
        NSString* contactId;
        NSMutableDictionary *contactDictionary =[friendsArray objectAtIndex: indexPath.row];
        contactId = contactDictionary[@"userId"];
        NSLog(@"Contact id: %@", contactId);
        NSLog(@"User id: %@", userIdInFriendsController);
        
       // [sender setEnabled:NO];
        
        //post request for adding friend...
        NSLog(@"sending request for removing friend");
        
        NSString * url = [[Utils getInstance] removeContactOrPendingRequestUrl];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"userId": userIdInFriendsController,
                                     @"contactId": contactId
                                     };
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            
            NSInteger code = [[operation response] statusCode];
            
            if(200 == code)
            {
                NSLog(@"user %@ successfully removed", contactId);
                [friendsArray removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [[Utils getInstance]setUserFriendsToPrefs:friendsArray];
            }
            else
            {
            }
            
            //[sender setEnabled:YES];
            isRemoveFromFriendsRequestSent = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error removing friend: %@", error);
            [[Utils getInstance] showErrorMessage:@"Something went wrong" message:@"Could not remove friend"];
            isRemoveFromFriendsRequestSent = NO;
        }];

    }
}

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
- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return (UIInterfaceOrientationPortrait);
}

@end
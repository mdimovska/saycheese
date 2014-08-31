//
//  BIDFriendsTableViewController.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import "BIDFriendsTableViewController.h"
#import "BIDFriendsTableViewCell.h"

@interface BIDFriendsTableViewController ()

@end

@implementation BIDFriendsTableViewController

@synthesize friendsArray;

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
    
      self.navigationController.view.backgroundColor = [UIColor  colorWithRed:((float) 235 / 255.0f)
green:((float) 160 / 255.0f)
blue:((float) 132/ 255.0f)
alpha:0.8];
  //  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor] ;
  
    //self.navigationController.view.tintColor=[UIColor whiteColor];  !!!!!
    self.navigationController.navigationBar.topItem.title = @"My account";
   
    
    self.navigationController.navigationBar.barTintColor = [UIColor  colorWithRed:((float) 21 / 255.0f)
                                                                             green:((float) 160 / 255.0f)
                                                                              blue:((float) 132/ 255.0f)
                                                                             alpha:0.8];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    friendsArray = [prefs mutableArrayValueForKey:@"userFriends"];
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
    cell.imageViewFriendPicture.image = [UIImage imageNamed:@"squarePNG.png"];
    NSURL *URL = [NSURL URLWithString:result[@"pictureUrl"]];
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

@end

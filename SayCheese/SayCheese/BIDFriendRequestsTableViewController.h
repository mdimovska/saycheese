//
//  BIDFriendRequestsTableViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 9/5/14.
//
//

#import <UIKit/UIKit.h>

@interface BIDFriendRequestsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *friendRequestsArray;
- (void)acceptFriendClicked:(id)sender;

@end

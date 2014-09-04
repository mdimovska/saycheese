//
//  BIDAddFriendsTableViewController.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import <UIKit/UIKit.h>

@interface BIDAddFriendsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *facebookFriendsArray;
@property (nonatomic, strong) NSMutableArray *friendsToAddArray;
@property (nonatomic, strong) NSMutableArray *pendingFriendsArray;
- (void)addFriendClicked:(id)sender;
@end

//
//  BIDFriendRequestsTableViewCell.h
//  SayCheese
//
//  Created by Goran Kopevski on 9/5/14.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface BIDFriendRequestsTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet  AsyncImageView* imageViewFriendPicture;
@property (nonatomic, strong) IBOutlet  UIButton* addButton;
@end

//
//  BIDAddFriendsTableViewCell.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface BIDAddFriendsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet  AsyncImageView* imageViewFriendPicture;
@property (nonatomic, strong) IBOutlet  UIButton* addButton;
@end

//
//  BIDLikesTableViewCell.h
//  SayCheese
//
//  Created by Goran Kopevski on 9/21/14.
//
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface BIDLikesTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet  AsyncImageView* imageView;

@end

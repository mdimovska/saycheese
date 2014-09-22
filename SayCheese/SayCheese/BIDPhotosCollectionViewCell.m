//
//  BIDPhotosCollectionViewCell.m
//  SayCheese
//
//  Created by Goran Kopevski on 9/21/14.
//
//

#import "BIDPhotosCollectionViewCell.h"

@implementation BIDPhotosCollectionViewCell
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // WRONG:
        // _imageView = [[UIImageView alloc] initWithFrame:frame];
        
        // RIGHT:
        imageView = [[AsyncImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:imageView];
    }
    return self;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // reset image property of imageView for reuse
    self.imageView.image = nil;
    
    // update frame position of subviews
    self.imageView.frame = self.contentView.bounds;
}

@end

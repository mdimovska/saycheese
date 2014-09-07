//
//  Utils.h
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (Utils *) getInstance;
- (NSString *) getDefaultUrl;
- (NSString *) getFacebookPictureUrl:(NSString*) userId;

- (NSURL *) getFriendsUrl:(NSString*) userId;
- (NSURL *) getRegisterUrl;
- (NSURL*) findFriendsUrl:(NSString*) userId;
- (NSURL*) addContactUrl;
- (NSURL*) removeContactOrPendingRequestUrl;
- (NSURL*) getFriendRequestsUrl:(NSString*) userId;
- (NSURL*) acceptFriendUrl:(NSString*) userId;
- (NSURL*) sendPhotoUrl;

- (UIColor* ) greenColor;

- (NSDictionary*) getUserDictionary;
- (NSString* ) getLoggedInUserId;
- (NSMutableArray*) getUserFriendsFromPrefs;
- (void) setUserFriendsToPrefs: (NSMutableArray*) friendsArray;

-(void) setImageViewRound:(UIImageView*) imageView;
-(void) showErrorMessage: (NSString*) errorTitle message:(NSString*) message;
- (UIColor* ) greenColorWithAlpha: (CGFloat) alpha;
- (NSURL *) makePictureUrl:(NSString*) userId;
@end

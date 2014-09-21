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

- (NSString *) getFriendsUrl:(NSString*) userId;
- (NSString *) getRegisterUrl;
- (NSString*) findFriendsUrl:(NSString*) userId;
- (NSString*) addContactUrl;
- (NSString*) removeContactOrPendingRequestUrl;
- (NSString*) getFriendRequestsUrl:(NSString*) userId;
- (NSString*) acceptFriendUrl:(NSString*) userId;
- (NSURL*) sendPhotoUrl;
- (NSString*) addRemoveLikeUrl;
- (NSString*) getNewsFeedUrl:(NSString*) userId;
- (NSURL *) getSaycheesePictureUrl:(NSString*) photoName userId:(NSString*) userId;
- (NSString*) getUserPhotos:(NSString*) userId;

- (UIColor* ) greenColor;

- (NSDictionary*) getUserDictionary;
- (NSString* ) getLoggedInUserId;
- (NSMutableArray*) getUserFriendsFromPrefs;
- (void) setUserFriendsToPrefs: (NSMutableArray*) friendsArray;

-(void) setImageViewRound:(UIImageView*) imageView;
-(void) showErrorMessage: (NSString*) errorTitle message:(NSString*) message;
- (UIColor* ) greenColorWithAlpha: (CGFloat) alpha;
- (NSURL *) makePictureUrl:(NSString*) userId;

- (void) logout: (UINavigationController*) navigationController;
@end
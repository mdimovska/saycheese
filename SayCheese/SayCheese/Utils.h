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
@end

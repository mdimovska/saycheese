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
- (NSURL *) getFriendsUrl:(NSString*) userId;
- (NSString *) getFacebookPictureUrl:(NSString*) userId;
- (NSURL *) getRegisterUrl;
@end

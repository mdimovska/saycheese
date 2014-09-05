//
//  Utils.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import "Utils.h"

@implementation Utils


- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

+ (Utils *)getInstance
{
    static Utils *instance = nil;
    
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[Utils alloc] init];
        }
    }
    
    return instance;
}

- (NSString*) getDefaultUrl
{
    return @"http:/95.180.244.26:9000";
}

- (NSURL*) getFriendsUrl:(NSString*) userId
{
    NSString* urlString = [NSString stringWithFormat:@"%@/users/%@/contacts", [self getDefaultUrl], userId];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) getFacebookPictureUrl:(NSString*) userId
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", userId];
}

- (NSURL *) getRegisterUrl
{
    //params: _id, firstName, lastName, pictureUrl
    NSString* urlString = [NSString stringWithFormat:@"%@/register", [self getDefaultUrl]];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL*) findFriendsUrl:(NSString*) userId
{
    //params: fbContacts  (in form: id1 id2 id3 ...)
    NSString* urlString = [NSString stringWithFormat:@"%@/users/%@/findFriends", [self getDefaultUrl], userId];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL*) addContactUrl
{
    //params: userId, contactId
    NSString* urlString = [NSString stringWithFormat:@"%@/users/addContact", [self getDefaultUrl]];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL*) removeContactOrPendingRequestUrl
{
    //params: userId, contactId
    NSString* urlString = [NSString stringWithFormat:@"%@/users/removeContact", [self getDefaultUrl]];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL*) getFriendRequestsUrl:(NSString*) userId
{
    NSString* urlString = [NSString stringWithFormat:@"%@/users/%@/friendRequests", [self getDefaultUrl], userId];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
- (NSURL*) acceptFriendUrl:(NSString*) userId
{
    NSString* urlString = [NSString stringWithFormat:@"%@/users/%@/acceptFriend", [self getDefaultUrl], userId];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
@end

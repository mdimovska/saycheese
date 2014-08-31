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
    return @"http://95.180.240.215:8080";
}

- (NSURL*) getFriendsUrl:(NSString*) userId
{
    NSString* urlString = [NSString stringWithFormat:@"%@/users/%@/contacts", [self getDefaultUrl], userId];
    return [NSURL URLWithString: urlString];
}

- (NSString *) getFacebookPictureUrl:(NSString*) userId
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", userId];
}

- (NSURL *) getRegisterUrl
{
    //params: _id, firstName, lastName, pictureUrl
    NSString* urlString = [NSString stringWithFormat:@"%@/register", [self getDefaultUrl]];
    return [NSURL URLWithString: urlString];
}

@end
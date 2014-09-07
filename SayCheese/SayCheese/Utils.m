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
    return @"http://95.180.244.51:9000";
}

- (NSDictionary*) getUserDictionary
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs dictionaryForKey:@"userInfo"];
}

- (NSString* ) getLoggedInUserId{
    NSDictionary * userDictionary = [self getUserDictionary];
    if(userDictionary){
        return userDictionary[@"user"][@"id"];
    }
    else return @"";
}

- (NSMutableArray*) getUserFriendsFromPrefs
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs mutableArrayValueForKey:@"userFriends"];
}

- (void) setUserFriendsToPrefs: (NSMutableArray*) friendsArray
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:friendsArray forKey:@"userFriends"];
}

- (NSURL*) getFriendsUrl:(NSString*) userId
{
    NSString* urlString = [NSString stringWithFormat:@"%@/users/%@/contacts", [self getDefaultUrl], userId];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) getFacebookPictureUrl:(NSString*) userId
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", userId];
}
- (NSURL *) makePictureUrl:(NSString*) userId
{
return [NSURL URLWithString: [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", userId]];
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
- (UIColor* ) greenColor
{
   return [UIColor  colorWithRed:((float) 21 / 255.0f)
                     green:((float) 160 / 255.0f)
                      blue:((float) 132/ 255.0f)
                     alpha:1];
}

- (UIColor* ) greenColorWithAlpha: (CGFloat) alpha
{
    return [[self greenColor] colorWithAlphaComponent:alpha];
}

-(void) setImageViewRound:(UIImageView*) imageView
{
    imageView.layer.cornerRadius = imageView.frame.size.height /2;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 0;
}

-(void) showErrorMessage: (NSString*) errorTitle message:(NSString*) message
{
    [[[UIAlertView alloc] initWithTitle:errorTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

//
//  Utils.m
//  SayCheese
//
//  Created by Goran Kopevski on 8/31/14.
//
//

#import "Utils.h"
#import "FacebookSDK/FacebookSDK.h"

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
    return @"http://192.168.1.103:9000";
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


- (NSMutableArray*) getUserPhotosFromPrefs
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs mutableArrayValueForKey:@"userPhotos"];
}

- (void) setUserFriendsToPrefs: (NSMutableArray*) friendsArray
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:friendsArray forKey:@"userFriends"];
}

- (NSString*) getFriendsUrl:(NSString*) userId
{
    return[[NSString stringWithFormat:@"%@/users/%@/contacts", [self getDefaultUrl], userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
}

- (NSString *) getFacebookPictureUrl:(NSString*) userId
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", userId];
}
- (NSURL *) makePictureUrl:(NSString*) userId
{
return [NSURL URLWithString: [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", userId]];
}

- (NSString *) getRegisterUrl
{
    //params: _id, firstName, lastName, pictureUrl
    return [[NSString stringWithFormat:@"%@/register", [self getDefaultUrl]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) findFriendsUrl:(NSString*) userId
{
    //params: fbContacts  (in form: id1 id2 id3 ...)
    return[[NSString stringWithFormat:@"%@/users/%@/findFriends", [self getDefaultUrl], userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) addContactUrl
{
    //params: userId, contactId
    return[[NSString stringWithFormat:@"%@/users/addContact", [self getDefaultUrl]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) removeContactOrPendingRequestUrl
{
    //params: userId, contactId
    return [[NSString stringWithFormat:@"%@/users/removeContact", [self getDefaultUrl]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) getFriendRequestsUrl:(NSString*) userId
{
    return [[NSString stringWithFormat:@"%@/users/%@/friendRequests", [self getDefaultUrl], userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) acceptFriendUrl:(NSString*) userId
{
   return [[NSString stringWithFormat:@"%@/users/%@/acceptFriend", [self getDefaultUrl], userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) getNewsFeedUrl:(NSString*) userId
{
    return[[NSString stringWithFormat:@"%@/photos/%@/latest", [self getDefaultUrl], userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSURL*) sendPhotoUrl
{
    NSString* urlString = [NSString stringWithFormat:@"%@/upload", [self getDefaultUrl]];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}
- (NSString*) uploadPhotoUrl
{
   return [[NSString stringWithFormat:@"%@/upload", [self getDefaultUrl]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
}

- (NSString*) addRemoveLikeUrl
{
    return [[NSString stringWithFormat:@"%@/photos/like", [self getDefaultUrl]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
  //  return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL *) getSaycheesePictureUrl:(NSString*) photoName userId:(NSString*) userId
{
    NSString* urlString = [NSString stringWithFormat:@"%@/picture/%@/%@", [self getDefaultUrl], userId, photoName];
    return [NSURL URLWithString: [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString*) getUserPhotos:(NSString*) userId
{
   return [[NSString stringWithFormat:@"%@/photos/%@", [self getDefaultUrl], userId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (void) logout: (UINavigationController*) navigationController  {
    [FBSession.activeSession closeAndClearTokenInformation];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:nil forKey:@"userInfo"];
    [prefs setObject:nil forKey:@"userFriends"];
    
    UIViewController *loginViewController =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginViewController"];
    [ navigationController pushViewController:loginViewController
                                           animated:YES];
    
    
}

@end

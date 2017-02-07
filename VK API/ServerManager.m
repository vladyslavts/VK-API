//
//  ServerManager.m
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "User.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation ServerManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *apiURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:apiURL];
    }
    return self;
}

+ (ServerManager *)sharedManager {
    
    static ServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ServerManager new];
    });
    
    return manager;
}

- (void)getFriendsWithUserID:(NSInteger)userID
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(NSArray *))success
                     failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = @{
                                 @"user_id" :   @(userID),
                                 @"order"   :   @"name",
                                // @"count"   :   @(count),
                                 //@"offset"  :   @(offset),
                                 @"fields"  :   @"photo_100, online"
                             };
    
    [_sessionManager GET:@"friends.get"
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    // NSLog(@"%@", responseObject);
                     NSArray *friendsResponse = [responseObject objectForKey:@"response"];
                    
                     NSMutableArray *objects = [NSMutableArray array];
                     
                     for (NSDictionary *dict in friendsResponse) {
                         User *friend = [[User alloc] initWithServerResponse:dict];
                         [objects addObject:friend];
                     }
                     
                     if (success) {
                         success(objects);
                     }
                 }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     if (failure) {
                         failure(error);
                     }
                 }];
    
}


- (void)getUserInfoWithID:(NSInteger)userID
                  success:(void (^)(User *))success
                  failure:(void (^)(NSError *))failure {
    
    NSString *fields = @"photo_200, online, bdate, city, relation, status, last_seen, domain, home_town, followers_count";
    
    NSDictionary *parameters = @{
                                 @"user_ids" :   @(userID),
                                 @"fields"   :   fields,
                                 @"version"  :   @5.8,
                                 };
    
        [self.sessionManager GET:@"users.get"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSDictionary *userInfo = [[responseObject valueForKey:@"response"] firstObject];
                         //NSLog(@"%@", userInfo);
                         User *user = [[User alloc] initWithDetailServerResponse:userInfo];
                         
                         if (success) {
                             success(user);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                     }];
}


- (void)getFollowersWithUserID:(NSInteger)userID
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                       success:(void (^)(NSArray *))success
                       failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = @{
                                 @"user_id" :   @(userID),
                                // @"order"   :   @"name",
                                // @"count"   :   @(count),
                                // @"offset"  :   @(offset),
                                 @"fields"  :   @"photo_100, online"
                                 };
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSDictionary *responseDict = [responseObject objectForKey:@"response"];
                         
                         NSArray *itemsArray = [responseDict objectForKey:@"items"];
                        // NSLog(@"%@", itemsArray);
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary *dict in itemsArray) {
                             User *follower = [[User alloc] initWithServerResponse:dict];
                             [objectsArray addObject:follower];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
    }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                     }];
}
@end

//
//  ServerManager.m
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "Friend.h"

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

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void (^)(NSArray *))success
                     failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameters = @{
                                 @"user_id" :   @"1",
                                 @"order"   :   @"name",
                                 @"count"   :   @(count),
                                 @"offset"  :   @(offset),
                                 @"fields"  :   @"photo_100"
                             };
    
    [_sessionManager GET:@"friends.get" parameters:parameters progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"%@", responseObject);
                     NSArray *friendsResponse = [responseObject objectForKey:@"response"];
                    
                     NSMutableArray *objects = [NSMutableArray array];
                     
                     for (NSDictionary *dict in friendsResponse) {
                         Friend *friend = [[Friend alloc] initWithServerResponse:dict];
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

@end

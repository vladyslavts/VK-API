//
//  ServerManager.h
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

- (void)getFriendsWithUserID:(NSInteger)userID
                      offset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void(^)(NSArray *friends))success
                     failure:(void(^)(NSError *error))failure;

- (void)getUserInfoWithID:(NSInteger)userID
                  success:(void(^)(User *user))success
                  failure:(void(^)(NSError *error))failure;

- (void)getFollowersWithUserID:(NSInteger)userID
                        offset:(NSInteger)offset
                         count:(NSInteger)count
                       success:(void(^)(NSArray *followers))success
                       failure:(void(^)(NSError *error))failure;
@end

//
//  ServerManager.h
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                     success:(void(^)(NSArray *friends))success
                     failure:(void(^)(NSError *error))failure;

@end

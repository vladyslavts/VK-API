//
//  Friend.h
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) NSString *domain;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *lastSeen;
@property (strong, nonatomic) NSString *homeTown;
@property (assign, nonatomic) NSInteger followersCount;
@property (assign, nonatomic) BOOL online;
@property (assign, nonatomic) BOOL onlineMob;

- (id)initWithServerResponse:(NSDictionary *)responseObject;
- (id)initWithDetailServerResponse:(NSDictionary *)responseObject;

@end

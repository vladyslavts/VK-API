//
//  Friend.h
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSURL *avatarURL;
@property (assign, nonatomic) BOOL online;

- (id)initWithServerResponse:(NSDictionary *)responseObject;
@end

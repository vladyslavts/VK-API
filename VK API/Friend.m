//
//  Friend.m
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(id)initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject valueForKey:@"first_name"];
        self.lastName = [responseObject valueForKey:@"last_name"];
        
        NSString *url = [responseObject valueForKey:@"photo_100"];
        
        if (url) {
            self.avatarURL = [NSURL URLWithString:url];
        }
    }
    return self;
}


@end

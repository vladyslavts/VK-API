//
//  Friend.m
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.firstName = [responseObject valueForKey:@"first_name"];
        self.lastName = [responseObject valueForKey:@"last_name"];
        self.online = [[responseObject valueForKey:@"online"] integerValue];
        self.userID = [[responseObject valueForKey:@"uid"] integerValue];
        
        NSString *url = [responseObject valueForKey:@"photo_100"];
        
        if (url) {
            self.avatarURL = [NSURL URLWithString:url];
        }
    }
    return self;
}


- (id)initWithDetailServerResponse:(NSDictionary *)responseObject {
    
    self = [super init];
    if (self) {
        
        self.online = [[responseObject valueForKey:@"online"] integerValue];
        self.onlineMob = [[responseObject valueForKey:@"online_mobile"] integerValue];
        self.userID = [[responseObject valueForKey:@"uid"] integerValue];
        self.status = [responseObject valueForKey:@"status"];
        self.domain = [responseObject valueForKey:@"domain"];
        self.homeTown = [responseObject valueForKey:@"home_town"];
        self.followersCount = [[responseObject valueForKey:@"followers_count"] integerValue];
        
        // ----- Avatar ------
        NSString *url = [responseObject valueForKey:@"photo_200"];
       
        if (url) {
            self.avatarURL = [NSURL URLWithString:url];
        }
        
        // ----- Last Seen ------
        NSDictionary *lastSeen = [responseObject valueForKey:@"last_seen"];
        
        if (lastSeen) {
            NSInteger time = [[lastSeen valueForKey:@"time"] integerValue];
            NSTimeInterval interval = time;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            //[formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"d MMM HH:mm"];
            self.lastSeen = [formatter stringFromDate:date];
        }
        
        
    }
    return self;
}




@end

//
//  FriendInfoTableViewController.h
//  VK API
//
//  Created by Vlad on 04.02.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserInfoTableViewController : UITableViewController

@property (strong, nonatomic) User *currentUser;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *domainLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTownLabel;

@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarLoadingIndicator;

- (IBAction)getFollowers:(UIButton *)sender;


@end

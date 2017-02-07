//
//  FriendInfoTableViewController.m
//  VK API
//
//  Created by Vlad on 04.02.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "ServerManager.h"
#import "FriendsTableViewController.h"
#import "FollowersTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserInfoTableViewController ()


@end

@implementation UserInfoTableViewController

- (void)loadView {
    [super loadView];
    [self loadUserInfo];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.avatarLoadingIndicator startAnimating];
    self.navigationItem.title = self.currentUser.firstName;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", self.currentUser.firstName];
    self.lastNameLabel.text = [NSString stringWithFormat:@"%@", self.currentUser.lastName];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)loadUserInfo {
   
    [[ServerManager sharedManager] getUserInfoWithID:self.currentUser.userID
                                             success:^(User *user)
    {
        /*self.nameLabel.text = [NSString stringWithFormat:@"%@", user.firstName];
        self.lastNameLabel.text = [NSString stringWithFormat:@"%@", user.lastName];*/
        self.domainLabel.text = [NSString stringWithFormat:@"%@", user.domain];
        self.homeTownLabel.text = [NSString stringWithFormat:@"%@", user.homeTown];
        self.followersLabel.text = [NSString stringWithFormat:@"%ld", (long)user.followersCount];
        
        if (user.status) {
            self.statusLabel.text = user.status;
        }
                                                 
        if (user.online && user.onlineMob) {
            self.onlineLabel.text = @"online (mob.)";
        } else if (user.online) {
            self.onlineLabel.text = @"online";
        } else {
            self.onlineLabel.text = [NSString stringWithFormat:@"Last seen %@", user.lastSeen];
        }
        
        [self.avatar.layer setMasksToBounds:YES];
        [self.avatar.layer setCornerRadius:self.avatar.frame.size.height / 2];
        
        __weak UIImageView *weakAvatar = self.avatar;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:user.avatarURL];
        [self.tableView reloadData];

        [self.avatar setImageWithURLRequest:urlRequest
                              placeholderImage:[UIImage imageNamed:@"user.png"]
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                                           weakAvatar.image = image;
                                           [self.avatarLoadingIndicator stopAnimating];
                                           [weakAvatar layoutSubviews];
                                           
                                       }
                                    failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                        
                                    }];
        
    }
                                             failure:^(NSError *error) {
    }];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getFollowers:(UIButton *)sender {

     FollowersTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"followersTable"];
     vc.user = self.currentUser;
     [self.navigationController pushViewController:vc animated:YES];

}

@end

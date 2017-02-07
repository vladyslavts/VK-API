//
//  FollowersTableViewController.m
//  VK API
//
//  Created by Vlad on 07.02.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "FollowersTableViewController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserInfoTableViewController.h"

@interface FollowersTableViewController ()

@property (strong, nonatomic) NSMutableArray *followers;

@end

@implementation FollowersTableViewController

static int followersInRequst = 25;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Followers"];
    
    self.followers = [NSMutableArray array];
    
    [self getUserFollowers];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API {

- (void)getUserFollowers {
    
    [[ServerManager sharedManager] getFollowersWithUserID:self.user.userID
                                                   offset:self.followers.count
                                                    count:followersInRequst
                                                  success:^(NSArray *followers)
    {
        [self.followers addObjectsFromArray:followers];
        NSMutableArray* newPaths = [NSMutableArray array];
        
        for (int i = (int)[self.followers count] - (int)[followers count]; i < [self.followers count]; i++) {
            [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
    }
                                                  failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    User *follower = [self.followers objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", follower.firstName, follower.lastName];
    
    if (follower.online) {
        cell.detailTextLabel.text = @"Online";
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:cell.contentView.frame.size.height / 2];
    
    __weak UITableViewCell *weakCell = cell;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:follower.avatarURL];
    
    [cell.imageView setImageWithURLRequest:urlRequest
                          placeholderImage:[UIImage imageNamed:@"user.png"]
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       
                                       weakCell.imageView.image = image;
                                       [weakCell layoutSubviews];
                                       
                                   }
                                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       
                                   }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *follower = [self.followers objectAtIndex:indexPath.row];
    UserInfoTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfo"];
    vc.currentUser = follower;
    [self.navigationController pushViewController:vc animated:YES];

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

@end

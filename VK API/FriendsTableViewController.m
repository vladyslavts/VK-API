//
//  FriendsTableViewController.m
//  VK API
//
//  Created by Vlad on 30.01.17.
//  Copyright © 2017 Vlad. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "Friend.h"
#import "UIScrollView+InfiniteScroll.h"


@interface FriendsTableViewController ()

@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (assign, nonatomic) BOOL loadingData;

@end

@implementation FriendsTableViewController

static int friendsInRequst = 25;

- (void)loadView {
    [super loadView];
    
    self.friendsArray = [NSMutableArray array];
    [self loadFriendsFromServer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.loadingData = YES;
    
    __weak FriendsTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {

        [weakSelf loadFriendsFromServer];
        [weakSelf.tableView finishInfiniteScroll];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - VK API

- (void)loadFriendsFromServer {
    
   [[ServerManager sharedManager] getFriendsWithOffset:self.friendsArray.count count:friendsInRequst
                                               success:^(NSArray *friends)
    {
        [self.friendsArray addObjectsFromArray:friends];
        NSMutableArray* newPaths = [NSMutableArray array];
                                                   
         for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
         self.loadingData = NO;
    }
                                               failure:^(NSError *error) {
                                                   NSLog(@"Error = %@", [error localizedDescription]);
                                               }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friendsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Friend *friend = [self.friendsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]   ;
    
    if (friend.online) {
        cell.detailTextLabel.text = @"Online";
    } else {
        cell.detailTextLabel.text = nil;
    }
    
    [cell.imageView.layer setMasksToBounds:YES];
    [cell.imageView.layer setCornerRadius:cell.contentView.frame.size.height / 2];

    __weak UITableViewCell *weakCell = cell;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:friend.avatarURL];
    
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

// Scrolling
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self loadFriendsFromServer];
        }
    }
}
*/

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

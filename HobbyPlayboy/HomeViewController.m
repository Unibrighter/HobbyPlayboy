//
//  HomeViewController.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "HomeViewController.h"
#import "HtmlContentParser.h"
#import "HomeTableViewDataSource.h"
#import "BrowserViewController.h"
#import "Gallery.h"
#import "BrowserCollectionViewDataSource.h"

@interface HomeViewController ()
@property (strong, nonatomic) RLMNotificationToken *realmNotificationToken;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.searchViewController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.navigationItem.hidesSearchBarWhenScrolling = NO;
//    if (@available(iOS 11.0, *)) {
//        self.navigationItem.searchController = self.searchViewController;
//    } else {
        // Fallback on earlier versions
//        self.navigationItem.titleView = self.searchViewController.searchBar;
//    }
    self.navigationItem.titleView = [[UISearchBar alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:nil];
    
    self.dataSource = [[HomeTableViewDataSource alloc] init];
    [self.dataSource registerNibForTableView:self.tableView];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (0 == self.dataSource.galleries.count){
        [self loadGalleriesFromPageNum:0];
    }
    
    [self setupRealmNotifications];
    
}

#pragma mark - Synchronization

- (void)loadGalleriesFromPageNum:(NSInteger)pageNum{
    //TODO: start loading animation
    [[HtmlContentParser sharedInstance] getGalleriesCount:0 pageNumOffset:pageNum completion:^(NSArray<Gallery *> *galleries, NSError * error) {
        if (!error){
            //data persist with Realm
            RLMRealm *realm = [RLMRealm defaultRealm];
            //persist all galleries to the disk
            [realm transactionWithBlock:^{
                [realm addOrUpdateObjects:galleries];
            }];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
        }
    }];
}

#pragma mark - ResponderChain

- (void)selectGallery:(id)object{
    BrowserViewController *browserViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[BrowserViewController className]];
    browserViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    browserViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    Gallery *gallery = (Gallery *)object;
    browserViewController.gallery = gallery;
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).mainTabBarController presentViewController:browserViewController animated:YES completion:nil];
}

- (void)downloadGalleryWithGalleryId:(NSString *)galleryId{
    //TODO: implement me
    NSLog(@"download gallery with id: %@", galleryId);
}

#pragma mark - Helper Functions
- (void)setupRealmNotifications{
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.realmNotificationToken = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        [self.tableView reloadData];
    }];
    
}
@end

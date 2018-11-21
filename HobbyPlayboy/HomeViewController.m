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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:nil];
    
    //table view and delegate configuration
    self.dataSource = [[HomeTableViewDataSource alloc] init];
    [self.dataSource registerNibForTableView:self.tableView];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //load gallery from the server if local data has zero record
    if (0 == [Gallery allObjects].count){
        [self loadGalleriesFromPageNum:0];
    }
    
    //force to update datasource if there is any the realm notification
    [self setupRealmNotifications];
    
    //search bar configuration
    self.searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
}

#pragma mark - SearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (!self.searchOverlayView){
        self.searchOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.searchOverlayView.backgroundColor = UIColor.clearColor;
        [self.searchOverlayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingSearchBarIfNeeded)]];
    }
    [self.view addSubview:self.searchOverlayView];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if (self.searchOverlayView){
        [self.searchOverlayView removeFromSuperview];
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText && searchText.length != 0){
        self.dataSource.predicate = [NSPredicate predicateWithFormat:@"rawTitle CONTAINS %@", searchText];
    }else{
        self.dataSource.predicate = nil;
    }
    [self.tableView reloadData];
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

- (void)downloadGalleryWithGalleryId:(NSNumber *)galleryId{
    //TODO: implement me
    NSLog(@"download gallery with id: %@", galleryId.stringValue);
}

- (void)toggleFavoriteGalleryWithGalleryId:(NSNumber *)galleryId{
    RLMResults<Gallery *> *results = [Gallery objectsWhere:@"galleryId = %@",galleryId];
    if (results.count){
        Gallery *gallery = results.firstObject;
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            gallery.favorite = !gallery.favorite;
        }];
    }
}

#pragma mark - Helper Functions
- (void)setupRealmNotifications{
    RLMRealm *realm = [RLMRealm defaultRealm];
    self.realmNotificationToken = [realm addNotificationBlock:^(RLMNotification  _Nonnull notification, RLMRealm * _Nonnull realm) {
        [self.tableView reloadData];
    }];
}

- (BOOL)endEditingSearchBarIfNeeded{
    BOOL searchBarActivate = self.searchBar.isFirstResponder;
    if (searchBarActivate){
        [self.searchBar resignFirstResponder];
    }
    return searchBarActivate;
}
@end

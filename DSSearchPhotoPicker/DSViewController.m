//
//  DSViewController.m
//  customPhotoPicker
//
//  Created by Ruthwick S Rai on 05/10/16.
//  Copyright © 2016 Ruthwick S Rai. All rights reserved.
//

#import "DSViewController.h"
#import "DSFirstView.h"
#import "DSSecondView.h"
#import "DSThirdView.h"
@interface DSViewController ()<UISearchBarDelegate, UISearchControllerDelegate,UISearchResultsUpdating, UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSString * searchQuery;
    NSMutableArray* searchResults;NSMutableArray* mainList;
    BOOL isFilltered;
    NSDictionary *searchHandler;
    NSMutableDictionary * selectedOption;
    
    DSFirstView * viewA;
    DSSecondView * viewB;
    DSThirdView * viewC;
    
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;



// Array of view controllers to switch between
@property (nonatomic, copy) NSArray *allViewControllers;

// Currently selected view controller
@property (nonatomic, strong) UIViewController *currentViewController;




@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *searchTable;

@end

@implementation DSViewController
- (void)viewWillAppear:(BOOL)animated {
    _segControl.tintColor=[UIColor whiteColor];
    [[UITextField
      appearanceWhenContainedInInstancesOfClasses:@[ [UISearchBar class] ]]
     setTextColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
     self.navigationController.navigationBar.shadowImage = [UIImage new];
    _searchTable.hidden=YES;
    [_searchBar removeFromSuperview];
    _searchBar = [[UISearchBar alloc]
                  initWithFrame:CGRectMake(
                                           10, 10,
                                           CGRectGetWidth(
                                                          self.navigationController.navigationBar.bounds) -
                                           20,
                                           30)];
    [self.navigationController.navigationBar addSubview:_searchBar];
    
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Search";
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    UITextField *textField = [_searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UITextField *searchTextField = [_searchBar valueForKey:@"_searchField"];
    if ([searchTextField
         respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        [searchTextField
         setAttributedPlaceholder:[[NSAttributedString alloc]
                                   initWithString:@"Search"
                                   attributes:@{
                                                NSForegroundColorAttributeName :
                                                    color
                                                }]];
    }
    
    [[UITextField
      appearanceWhenContainedInInstancesOfClasses:@[ [UISearchBar class] ]]
     setTextColor:[UIColor whiteColor]];
    [self.searchTable setDataSource:self];
    [self.searchTable setDelegate:self];

    _searchBar.delegate = self;
    
    _searchBar.showsCancelButton = YES;
    _searchBar.translucent = NO;
    _searchBar.tintColor = [UIColor whiteColor];
    searchTextField.textColor = [UIColor whiteColor];
    NSLog(@"search bar viewDidLoad");
    
   

    
    
    // Create the score view controller
    viewA = [self.storyboard instantiateViewControllerWithIdentifier:@"viewA"];
   
    // Create the penalty view controller
    viewB = [self.storyboard instantiateViewControllerWithIdentifier:@"viewB"];
   
     viewC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewC"];
   

    // Add A and B view controllers to the array
    self.allViewControllers = [[NSArray alloc] initWithObjects:viewA, viewB, viewC,nil];
    
    // Ensure a view controller is loaded
    self.segControl.selectedSegmentIndex = 0;
    [self cycleFromViewController:self.currentViewController toViewController:[self.allViewControllers objectAtIndex:self.segControl.selectedSegmentIndex]];
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"serach results updating!!");
}
#pragma mark - View controller switching and saving

- (void)cycleFromViewController:(UIViewController*)oldVC toViewController:(UIViewController*)newVC {
    
    // Do nothing if we are attempting to swap to the same view controller
    if (newVC == oldVC) return;
    
    // Check the newVC is non-nil otherwise expect a crash: NSInvalidArgumentException
    if (newVC) {
        
        // Set the new view controller frame (in this case to be the size of the available screen bounds)
        // Calulate any other frame animations here (e.g. for the oldVC)
        newVC.view.frame = CGRectMake(CGRectGetMinX(self.view.bounds), 40, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-20);
        [newVC.view layoutIfNeeded];
        [newVC.view setNeedsLayout];
        // Check the oldVC is non-nil otherwise expect a crash: NSInvalidArgumentException
        if (oldVC) {
            
            // Start both the view controller transitions
            [oldVC willMoveToParentViewController:nil];
            [self addChildViewController:newVC];
            
            // Swap the view controllers
            // No frame animations in this code but these would go in the animations block
            [self transitionFromViewController:oldVC
                              toViewController:newVC
                                      duration:0.25
                                       options:UIViewAnimationOptionLayoutSubviews
                                    animations:^{}
                                    completion:^(BOOL finished) {
                                        // Finish both the view controller transitions
                                        [oldVC removeFromParentViewController];
                                        [newVC didMoveToParentViewController:self];
                                        // Store a reference to the current controller
                                        self.currentViewController = newVC;
                                    }];
            
        } else {
            
            // Otherwise we are adding a view controller for the first time
            // Start the view controller transition
            [self addChildViewController:newVC];
            
            // Add the new view controller view to the ciew hierarchy
            [self.view addSubview:newVC.view];
            
            // End the view controller transition
            [newVC didMoveToParentViewController:self];
            
            // Store a reference to the current controller
            self.currentViewController = newVC;
        }
    }
}

- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    
    NSUInteger index = sender.selectedSegmentIndex;
    
    if (UISegmentedControlNoSegment != index) {
        UIViewController *incomingViewController = [self.allViewControllers objectAtIndex:index];
        [self cycleFromViewController:self.currentViewController toViewController:incomingViewController];
    }
    
}
    
    

- (void)viewWillDisappear:(BOOL)animated {
    [_searchBar resignFirstResponder];
//    [_searchBar setHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancel button clicked");
    [_searchBar resignFirstResponder];
    _searchTable.hidden=YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchTable.hidden=YES;
    searchQuery= [searchBar text];
    viewA.passedResult = searchQuery;
       viewB.passedResult = searchQuery;
    viewC.passedResult = searchQuery;
    if (_segControl.selectedSegmentIndex==0) {
        [viewA getImages:0];
    }else if (_segControl.selectedSegmentIndex==1){
        [viewB viewWillAppear:YES];

    }else{
        [viewC viewWillAppear:YES];

    }
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
     _searchTable.hidden=NO;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   
    if(searchText.length == 0)
    {
        isFilltered = NO;
    }else
    {
    
        isFilltered = YES;
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[cd] %@",searchText];
        searchResults =[[NSMutableArray alloc]initWithArray:[mainList filteredArrayUsingPredicate:resultPredicate]];
    
    }
    [_searchTable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isFilltered)
    {
        return [searchResults count];
    }
    return [mainList count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(isFilltered)
    {
        selectedOption = searchResults[indexPath.row];
    }else
    {
        selectedOption = mainList[indexPath.row];
    }
    UIImageView * profilePic = (UIImageView *) [cell viewWithTag:1];
    UILabel * name = (UILabel *) [cell viewWithTag:2];
    UILabel * email = (UILabel *) [cell viewWithTag:3];
    name.text = [NSString stringWithFormat:@"%@",[selectedOption objectForKey:@"firstname"]];
    email.text = [NSString stringWithFormat:@"%@",[selectedOption objectForKey:@"label"]];
//    NSString * profileImage = [selectedOption objectForKey:@"value"];
    profilePic.layer.cornerRadius = profilePic.frame.size.width/2;
    profilePic.clipsToBounds=YES;
    //[FAUtilityManager removeCacheForURL:profileImage];
    
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isFilltered) {
        selectedOption = [[NSMutableDictionary alloc]initWithDictionary:searchResults[indexPath.row]];
        searchHandler = searchResults[indexPath.row];
    } else {
        selectedOption = [[NSMutableDictionary alloc]initWithDictionary:mainList[indexPath.row]];
        
    }
   }




@end

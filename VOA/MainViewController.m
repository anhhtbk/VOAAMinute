//
//  MainViewController.m
//  VOA
//
//  Created by VMio69 on 6/18/16.
//  Copyright © 2016 VMio69. All rights reserved.
//

#import "MainViewController.h"
#import "TFHpple.h"
#import "Config.h"
#import "Item.h"
#import "MasterViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *homeTableView;

    NSMutableArray *data;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadHomeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadHomeView{
    
    NSURL *homeUrl = [NSURL URLWithString:URL_HOME];
    
    NSData *htmlData = [NSData dataWithContentsOfURL:homeUrl options:NSDataReadingMappedAlways error:nil];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQuerry = @"//div[@class='menu']/ul/li/a";
    NSArray *nodes = [parser searchWithXPathQuery:xpathQuerry];
    
    NSMutableArray *newData = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in nodes) {
        Item *item = [Item new];
        [newData addObject:item];
        
        item.title = [[element firstChild] content];
        item.url = [element objectForKey:@"href"];
    }
    
    data = newData;
    [homeTableView reloadData];
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"homeCellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Item *thisItem = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = thisItem.title;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"gotoMasterViewSegueId" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoMasterViewSegueId"]) {
        Item *selectedItem = [data objectAtIndex:homeTableView.indexPathForSelectedRow.row];
        MasterViewController *masterView = segue.destinationViewController;
        masterView.masterUrl = selectedItem.url;
    }
}

@end

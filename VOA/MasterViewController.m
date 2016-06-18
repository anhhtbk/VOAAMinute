//
//  MasterViewController.m
//  VOA
//
//  Created by VMio69 on 6/18/16.
//  Copyright © 2016 VMio69. All rights reserved.
//

#import "MasterViewController.h"
#import "TFHpple.h"
#import "Config.h"
#import "Item.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *masterTableView;
    NSMutableArray *data;
}
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadMasterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMasterView{
    NSURL *masterUrl = [NSURL URLWithString:_masterUrl];
    
    NSData *htmlData = [NSData dataWithContentsOfURL:masterUrl options:NSDataReadingMappedAlways error:nil];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQuerry = @"//div[@class='row']/ul/li";
    NSArray *nodes = [parser searchWithXPathQuery:xpathQuerry];
    
    NSMutableArray *newData = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in nodes) {
        Item *item = [Item new];
        [newData addObject:item];
        
        for (TFHppleElement *child in element.children) {
            if ([child.tagName isEqualToString:@"h4"]) {
                item.title = [[child firstChild] content];
            }
            if ([child.tagName isEqualToString:@"img"]) {
                item.image = [child objectForKey:@"src"];
            }
        }
        
        
        item.url = [element objectForKey:@"href"];
    }
    
    data = newData;
    [masterTableView reloadData];
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"masterCellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Item *thisItem = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = thisItem.url;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"gotoDetailiewSegueId" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"gotoDetailiewSegueId"]) {
        Item *selectedItem = [data objectAtIndex:masterTableView.indexPathForSelectedRow.row];
        MasterViewController *masterView = segue.destinationViewController;
        masterView.masterUrl = selectedItem.url;
    }
}
@end

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
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

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
    
    NSString *xpathQuerry = @"//div[@class='media-block with-date width-img size-3']";
    NSArray *nodes = [parser searchWithXPathQuery:xpathQuerry];
    
    NSMutableArray *newData = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in nodes) {
        Item *item = [Item new];
        [newData addObject:item];
        for (TFHppleElement *child in element.children) {
            if ([child.tagName isEqualToString:@"a"]) {
                for (TFHppleElement *childChild in [child childrenWithTagName:@"div"]) {
                    for (TFHppleElement *ccc in [childChild childrenWithTagName:@"img"]) {
                        item.image = [ccc objectForKey:@"src"];
                        break;
                    }
                }
            }
            if ([child.tagName isEqualToString:@"div"]) {
                for (TFHppleElement *cc in [child childrenWithTagName:@"a"]) {
                    item.url = [URL_HOME stringByAppendingString:[cc objectForKey:@"href"]];
                    for (TFHppleElement *ccc in [cc childrenWithTagName:@"h4"]) {
                        for (TFHppleElement *c4 in [ccc childrenWithTagName:@"span"]) {
                            item.title = [[c4 content] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@: ", self.title] withString:@""];
                            break;
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
    data = newData;
    [masterTableView reloadData];
    masterTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:201];
    Item *thisItem = [data objectAtIndex:indexPath.row];
    [imageView setImageWithURL:[NSURL URLWithString:thisItem.image]];
    cell.textLabel.text = thisItem.title;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
        DetailViewController *detailView = segue.destinationViewController;
        detailView.detailUrl = selectedItem.url;
        detailView.title = selectedItem.title;
    }
}
@end

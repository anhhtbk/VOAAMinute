//
//  DetailViewController.m
//  VOA
//
//  Created by VMio69 on 6/18/16.
//  Copyright © 2016 VMio69. All rights reserved.
//

#import "DetailViewController.h"
#import "VKVideoPlayer.h"
#import "TFHpple.h"
#import "Config.h"

@interface DetailViewController () <VKVideoPlayerDelegate>
{
    IBOutlet UIView *playerView;
    VKVideoPlayer *vkPlayer;
    NSURL *urlVideo;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    vkPlayer = [[VKVideoPlayer alloc] initWithVideoPlayerView:[VKVideoPlayerView new]];
    vkPlayer.delegate = self;
    vkPlayer.view.frame = playerView.bounds;
    [playerView addSubview:vkPlayer.view];
    [self loadVideo];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:urlVideo];
    track.hasNext = YES;
    [vkPlayer loadVideoWithTrack:track];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadVideo{
    NSURL *masterUrl = [NSURL URLWithString:_detailUrl];
    
    NSData *htmlData = [NSData dataWithContentsOfURL:masterUrl options:NSDataReadingMappedAlways error:nil];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQuerry = @"//head/meta";
    NSArray *nodes = [parser searchWithXPathQuery:xpathQuerry];
    
    for (TFHppleElement *element in nodes) {
        if ([[element objectForKey:@"name"] isEqualToString:@"twitter:player:stream"]) {
            urlVideo = [NSURL URLWithString:[element objectForKey:@"content"]];
        }
        
    }
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            [self.navigationController setNavigationBarHidden:YES animated:YES];
             vkPlayer.view.frame = CGRectMake(0, 0, 568, 320);
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self.navigationController setNavigationBarHidden:YES animated:YES];
             vkPlayer.view.frame = CGRectMake(0, 0, 568, 320);
            break;
        case UIInterfaceOrientationPortrait:
            [self.navigationController setNavigationBarHidden:NO animated:YES];
             vkPlayer.view.frame = playerView.bounds;
            break;
        default:
            break;
    }
}

@end

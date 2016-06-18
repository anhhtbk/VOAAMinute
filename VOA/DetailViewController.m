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
//#import "VideoPlayerKit.h"

@interface DetailViewController () <VKVideoPlayerDelegate>
{
    IBOutlet UIView *playerView;
    VKVideoPlayer *vkPlayer;
//    VideoPlayerKit *playerKit;
    NSURL *urlVideo;
    IBOutlet UITextView *noteTextView;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    vkPlayer = [[VKVideoPlayer alloc] initWithVideoPlayerView:[VKVideoPlayerView new]];
    vkPlayer.delegate = self;
    vkPlayer.view.frame = playerView.bounds;
    vkPlayer.view.fullscreenButton.hidden = NO;
    [playerView addSubview:vkPlayer.view];
    
    
    [self loadVideo];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    keyboardToolbar.barStyle = UIBarStyleDefault;
    keyboardToolbar.items = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelWithKeyBoard)],
                             [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyBoard)],
                             nil];
    [keyboardToolbar sizeToFit];
    noteTextView.inputAccessoryView = keyboardToolbar;
    
    
}

-(void)cancelWithKeyBoard{
    [self.view endEditing:YES];
}

-(void)doneWithKeyBoard{
    [self.view endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    VKVideoPlayerTrack *track = [[VKVideoPlayerTrack alloc] initWithStreamURL:urlVideo];
//    track.hasNext = YES;
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
    if (!urlVideo) {
        xpathQuerry = @"//div[@class='player-and-links']/div/a";
        nodes = [parser searchWithXPathQuery:xpathQuerry];
        for (TFHppleElement *element in nodes) {
            urlVideo = [NSURL URLWithString:[element objectForKey:@"href"]];
        }
    }
}
//
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    switch (toInterfaceOrientation) {
//        case UIInterfaceOrientationLandscapeLeft:
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//             vkPlayer.view.frame = CGRectMake(0, 0, 568, 320);
//            break;
//        case UIInterfaceOrientationLandscapeRight:
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//             vkPlayer.view.frame = CGRectMake(0, 0, 568, 320);
//            break;
//        case UIInterfaceOrientationPortrait:
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//             vkPlayer.view.frame = playerView.bounds;
//            break;
//        default:
//            break;
//    }
//}

@end

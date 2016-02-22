//
//  GlobeViewController.m
//  RIM
//
//  Created by Jerald Abille on 2/22/16.
//  Copyright © 2016 Mikelsoft.com. All rights reserved.
//

#import "GlobeViewController.h"
#import <MaplyMBTileSource.h>

@interface GlobeViewController ()

@end

@implementation GlobeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.clearColor = [UIColor darkGrayColor];
    self.frameInterval = 3;
    [self clearLights];
    
    MaplyMBTileSource *tileSource = [[MaplyMBTileSource alloc] initWithMBTiles:@"Map-Raster"];
    MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    layer.handleEdges = self != nil;
    layer.coverPoles = self != nil;
    layer.drawPriority = 100;
    
    [self addLayer:layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

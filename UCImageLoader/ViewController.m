//
//  ViewController.m
//  UCImageLoader
//
//  Created by yu chung hyun on 2014. 10. 14..
//  Copyright (c) 2014년 yu chung hyun. All rights reserved.
//

#import "ViewController.h"
#import "UCImageLoader.h"
#import "UIImageView+UCImageLoaderAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITableView *tableView = [[[UITableView alloc] initWithFrame:[self.view bounds]] autorelease];
    [self.view addSubview:tableView];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if(!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"] autorelease];
        [cell.imageView setContentMode:UIViewContentModeScaleToFill];
    }
  
    UIImage *placeHolder = [UIImage imageNamed:@"placeHolder.png"];
    [[cell imageView] setImage:placeHolder];
    [[cell imageView] setNeedsLayout];
    
    [cell.imageView setImageURLString:[self makeImageUrl:indexPath]];
    
    return cell;
}


- (NSString *) makeImageUrl:(NSIndexPath *)indexPath
{
    NSArray *arr = @[@"abstract",@"animals",@"business",@"cats",@"city",@"food",@"nightlife",@"fashion",@"people",@"nature",@"sports",@"technics",@"transport"];
    NSString *category = [arr objectAtIndex:(indexPath.row % [arr count])];
    NSInteger index = indexPath.row % 10 + 1;
    NSString *imageUrl = [NSString stringWithFormat:@"http://lorempixel.com/400/200/%@/%d/image%d/",category,index,indexPath.row];
    
    return imageUrl;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

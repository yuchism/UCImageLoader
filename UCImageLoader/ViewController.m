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


@interface MyCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation MyCell


- (void)dealloc {
    [_imgView release];
    [super dealloc];
}
@end


@interface ViewController ()

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.tableView registerClass:[MyCell class] forCellReuseIdentifier:@"mycell"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];

  
    [[cell imageView] setImage:[UIImage imageNamed:@"placeholder"]];
    [[cell imageView] setNeedsLayout];
    [[cell imageView] setContentMode:UIViewContentModeScaleAspectFit];
    
    [cell.imageView setImageURLString:[self makeImageUrl:indexPath]];
    
    return cell;
}


- (NSString *) makeImageUrl:(NSIndexPath *)indexPath
{
    NSArray *arr = @[@"abstract",@"animals",@"business",@"cats",@"city",@"food",@"nightlife",@"fashion",@"people",@"nature",@"sports",@"technics",@"transport"];
    NSString *category = [arr objectAtIndex:(indexPath.row % [arr count])];
    NSInteger index = indexPath.row % 10 + 1;
    NSString *imageUrl = [NSString stringWithFormat:@"http://lorempixel.com/50/50/%@/%ld/image%ld/",category,index,indexPath.row];
    
    return imageUrl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end

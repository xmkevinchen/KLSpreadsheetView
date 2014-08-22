//
//  KLSpreadsheetViewController.m
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/21/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import "KLSpreadsheetViewController.h"
#import "KLCell.h"
#import <QuartzCore/QuartzCore.h>

@interface KLSpreadsheetViewController ()

@end

@implementation KLSpreadsheetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.spreadsheetView registerNib:[UINib nibWithNibName:@"KLCell" bundle:nil] forCellReuseIdentifier:@"KLCell"];
    self.spreadsheetView.backgroundColor = [UIColor clearColor];
    [self.spreadsheetView reloadData];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.spreadsheetView setNeedsLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KLSpreadsheetDataSource

- (NSUInteger)numberOfRowsInSpreadsheetView:(KLSpreadsheetView *)spreadsheetView {
    return 20;
}

- (NSUInteger)numberOfColumnsInSpreadsheetView:(KLSpreadsheetView *)spreadsheetView {
    return 10;
}

- (KLSpreadsheetViewCell *)spreadsheetView:(KLSpreadsheetView *)spreadsheetView cellForItemAtIndex:(NSIndexPath *)indexPath {
    KLCell *cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"KLCell" forIndexPath:indexPath];
    
    cell.label.text = [indexPath description];
//    cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    cell.layer.borderWidth = 0.5f;
    
    return cell;
}

#pragma mark - KLSpreadsheetDelegate

- (CGFloat)spreadsheetView:(KLSpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    return 30.0f;
}

- (CGFloat)spreadsheetView:(KLSpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    return 100.0f;
}

@end

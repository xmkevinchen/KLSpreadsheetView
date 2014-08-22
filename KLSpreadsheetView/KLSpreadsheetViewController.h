//
//  KLSpreadsheetViewController.h
//  KLSpreadsheetView
//
//  Created by Kevin Chen on 8/21/14.
//  Copyright (c) 2014 KnightLord Universe Technolegies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLSpreadsheetView.h"

@interface KLSpreadsheetViewController : UIViewController <KLSpreadsheetDataSource, KLSpreadsheetDelegate>

@property (weak, nonatomic) IBOutlet KLSpreadsheetView *spreadsheetView;

@end

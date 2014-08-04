//
//  CollageViewController.h
//  KodeTest
//
//  Created by Artem Kondrashov on 23.07.14.
//  Copyright (c) 2014 KODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollageViewController : PhotoCollectionViewController

@property (weak, nonatomic) IBOutlet UIButton *btnPrint;

- (IBAction)pressPrint:(id)sender;

@end

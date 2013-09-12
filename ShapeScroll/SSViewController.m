//
//  SSViewController.m
//  ShapeScroll
//
//  Created by Satoru Takahashi on 2013/09/08.
//  Copyright (c) 2013年 Satoru Takahashi. All rights reserved.
//

#import "SSViewController.h"
#import "SSShapeModel.h"
#import "SSShapeView.h"

@interface SSViewController ()

@end

@implementation SSViewController

const int SHAPE_NUMBER = 200;
NSTimer *timer;
NSMutableArray *shapeModels;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeLocations];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target: self
                                           selector:@selector(ticker:) userInfo: nil
                                            repeats: YES ];
}

- (void)initializeLocations
{
    self.view.backgroundColor = [UIColor whiteColor];

    shapeModels = [[NSMutableArray alloc] init];
    for (int i = 0; i < SHAPE_NUMBER; i++) {
        SSShapeModel *model = [[SSShapeModel alloc] init];

        int size = rand() % 80 + 20;
        model.location = CGRectMake(
                                     rand() % (int)([UIScreen mainScreen].bounds.size.width),
                                     rand() % (int)([UIScreen mainScreen].bounds.size.height + size * 2) - size * 2,
                                     size,
                                     size);
        model.move = CGPointMake(0, (float)(rand() % 100 + 10) / 100.0);
        
        SSShapeView *view = [[SSShapeView alloc] initWithFrame:model.location];
        view.center = model.location.origin;
        view.color = [UIColor colorWithRed:0.0 green:1.0 blue:0.7 alpha:0.1];
        view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        
        model.view = view;
        
        [self.view addSubview:model.view];
        
        [shapeModels addObject:model];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ticker:(NSTimer*)timer
{
    for (int i = 0; i < SHAPE_NUMBER; i++) {
        SSShapeModel *model = [shapeModels objectAtIndex:i];
        CGRect location = model.location;
        location.origin.y += model.move.y;
        if (location.origin.y > [UIScreen mainScreen].bounds.size.height + location.size.height) {
            location.origin.y -= [UIScreen mainScreen].bounds.size.height + location.size.height * 2;
        }
        model.view.center = location.origin;
        model.location = location;
        [shapeModels replaceObjectAtIndex:i withObject:model];
    }
}

@end

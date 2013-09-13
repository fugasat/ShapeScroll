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
CGPoint scrollMove;
CGPoint touchLocation;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeLocations];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.0166f target: self
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
                                     rand() % (int)([UIScreen mainScreen].bounds.size.width + size * 2) - size * 2,
                                     rand() % (int)([UIScreen mainScreen].bounds.size.height + size * 2) - size * 2,
                                     size,
                                     size);
        model.move = CGPointMake(0, (float)(rand() % 100 + 10) / 100.0);
        model.moveRange = CGPointMake(
                                      1 - (float)(rand() % 90) / 100,
                                      1 - (float)(rand() % 90) / 100);
        
        SSShapeView *view = [[SSShapeView alloc] initWithFrame:model.location];
        view.center = model.location.origin;
        float colorRange = (float)(rand() % 100) / 200;
        NSLog(@"c=%f",colorRange);
        view.color = [UIColor colorWithRed:0.0 green:1.0 - colorRange blue:0.5 + colorRange alpha:0.1];
        view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        
        model.view = view;
        
        [self.view addSubview:model.view];
        
        [shapeModels addObject:model];
    }
    
    touchLocation.x = -1;
    touchLocation.y = -1;
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
        model = [self moveModel:model scrollMove:scrollMove];
        [shapeModels replaceObjectAtIndex:i withObject:model];
    }
    
    scrollMove.x = [self adjustMove:scrollMove.x];
    scrollMove.y = [self adjustMove:scrollMove.y];
}

- (SSShapeModel*)moveModel:(SSShapeModel*)model scrollMove:(CGPoint)scrollMove
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;

    CGRect location = model.location;
    location.origin.x = [self adjustLocation:location.origin.x locationSize:location.size.width
                                        move:model.move.x moveRange:model.moveRange.x
                                  scrollMove:scrollMove.x
                                  screenSize:screenSize.width];
    location.origin.y = [self adjustLocation:location.origin.y locationSize:location.size.height
                                        move:model.move.y moveRange:model.moveRange.y
                                  scrollMove:scrollMove.y
                                  screenSize:screenSize.height];

    model.view.center = location.origin;
    model.location = location;
    return model;
}

- (float)adjustLocation:(float)locationOrigin locationSize:(float)locationSize
                   move:(float)move moveRange:(float)moveRange
             scrollMove:(float)scrollMove screenSize:(float)screenSize
{
    int screenFullSize = screenSize + locationSize * 2;
    float tempOrigin = screenFullSize + locationOrigin + (move + scrollMove) * moveRange + locationSize;
    return tempOrigin - (screenFullSize * (int)(tempOrigin / screenFullSize)) - locationSize;
}

- (float)adjustMove:(float)move
{
    if (move > 0 || move < 0) {
        move = move * 0.97;
        if (move > -0.01 && move < 0.01) {
            move = 0;
        }
    }
    return move;
}

- (void)scrollMoveReset
{
    scrollMove.x = 0;
    scrollMove.y = 0;
}

// タッチイベントを取る
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self scrollMoveReset];
    touchLocation = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint currentLocation = [[touches anyObject] locationInView:self.view];
    scrollMove.x = currentLocation.x - touchLocation.x;
    scrollMove.y = currentLocation.y - touchLocation.y;
    touchLocation = currentLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end

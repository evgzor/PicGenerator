//
//  NumberPicGenerator.m
//  PicGenerator
//
//  Created by admin on 26.04.15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "NumberPicGenerator.h"
#import "UtilsHelper.h"

#define MAX_COUNT 9

@interface NumberPicGenerator()

@property NSUInteger indexNumber;

@end

@implementation NumberPicGenerator
{
    NSMutableArray* _delegates;
    NSTimer *_timer;
    NSUInteger _indexCount;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _delegates = [@[] mutableCopy];
        _indexCount = 1;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillGoInBackground:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillGoInForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        return self;
    }
    return nil;
}

-(void)dealloc
{
    if (_delegates.count) {
        [_delegates removeAllObjects];
    }
    _delegates = nil;
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addDelegate:(id<NumberPicGeneratorDelegate>)delegate
{
    if (![_delegates containsObject:delegate]){
        [_delegates addObject:delegate];
    }
}

-(void)remooveDelagate:(id<NumberPicGeneratorDelegate>)delegate
{
    if ([_delegates containsObject:delegate]) {
        [_delegates removeObject:delegate];
    }
}


#pragma mark - Control process generation functions
-(void)start
{
    if (_isStarted) {
        return;
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval: .5f
                                                  target: self
                                                selector:@selector(onTick)
                                                userInfo: nil repeats:YES];
    _isStarted = YES;
    [_delegates applySelector:@selector(updateState) withArgument:nil];
}

-(void)pause
{
    [_timer invalidate];
    _timer = nil;
    _isStarted = NO;
    [_delegates applySelector:@selector(updateState) withArgument:nil];
    }

#pragma mark - Timer processing

-(void)onTick
{
    _indexCount++;
    _indexCount = (_indexCount > MAX_COUNT) ? 1 : _indexCount;
    
    UIImage* image = [self getImageFromText:[@(_indexCount) stringValue]];
    
    if (_indexCount % 2)
    {
        
        [_delegates applySelector:@selector(unevenUpdatedImage:) withArgument:image];
    }
    else
    {
        [_delegates applySelector:@selector(evenUpdatedIdmage:) withArgument:image];
    }
}


#pragma mark - BackGround notification processing

-(void)appWillGoInBackground: (NSNotification*)notif
{
    UIImage* image = [self getImageFromText:@"B"];
    
    [_delegates applySelector:@selector(unevenUpdatedImage:) withArgument:image];
    [_delegates applySelector:@selector(evenUpdatedIdmage:) withArgument:image];
    
    
    [self pause];
    
}


-(void) appWillGoInForeground: (NSNotification*)notif
{
    
    
}

#pragma mark - private function
-(UIImage*)getImageFromText:(NSString*)text
{
    UIImage* image = [UIImage imageWithColor:[UIColor clearColor] andSize:[UIApplication sharedApplication].keyWindow.bounds.size];
    return [image drawText:text atPoint:CGPointMake(0., 0.) withFontSize:450 andTextColor:[UIColor brownColor] andBackgroundColor:[UIColor yellowColor]];
}

@end

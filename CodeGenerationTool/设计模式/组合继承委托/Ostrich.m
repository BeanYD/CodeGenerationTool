//
//  Ostrich.m
//  CodeGenerationTool
//
//  Created by mac on 2021/11/19.
//  Copyright © 2021 dingbinbin. All rights reserved.
//

#import "Ostrich.h"

@interface Ostrich () <Tweetable, EggLayable>

@property (strong) TweetAbility *tweetAbility;
@property (strong) EggLayAbility *eggLayAbility;

@end

@implementation Ostrich

- (instancetype)init {
    if (self = [super init]) {
        _tweetAbility = [TweetAbility new];
        _eggLayAbility = [EggLayAbility new];
    }
    
    return self;
}

- (void)tweet {
    [_tweetAbility tweet];
}

- (void)layEgg {
    [_eggLayAbility layEgg];
}

@end

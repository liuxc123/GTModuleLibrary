//
//  GTPageStateManager.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTPageStateManager.h"

@implementation GTPageStateManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configDefault];
    }
    return self;
}

- (void)configDefault {
    self.pageStateType = GTPageStateTypeNone;
    self.emptyDataOffset = 10;
    self.loadingOffset = 10;
    self.networkErrorOffset = 10;
}



@end

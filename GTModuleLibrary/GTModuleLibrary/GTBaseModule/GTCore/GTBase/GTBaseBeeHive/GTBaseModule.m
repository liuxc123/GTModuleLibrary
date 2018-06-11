//
//  GTBaseModule.m
//  GTModuleLibrary
//
//  Created by liuxc on 2018/6/11.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "GTBaseModule.h"

@implementation GTBaseModule

-(void)modInit:(BHContext *)context
{
    switch (context.env) {
        case BHEnvironmentDev:
        {
            //
        }
            break;

        case BHEnvironmentTest:
        {
            //
        }
            break;

        case BHEnvironmentProd:
        {
            //
        }
            break;

        default:
            break;
    }
}

- (void)modSetUp:(BHContext *)context
{
    NSLog(@"BaseModule setup");
}

@end

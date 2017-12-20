//
//  LocationManager.m
//  定位
//
//  Created by 木子女乔 on 2016/12/26.
//  Copyright © 2016年 木子女乔. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager


+(LocationManager *)shareInstance
{
    static LocationManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[LocationManager alloc] init];
        manager._locationManager = [[CLLocationManager alloc] init];
        //设置iOS设备是否可暂停定位来节省电池的电量。如果该属性设为“YES”，则当iOS设备不再需要定位数据时，iOS设备可以自动暂停定位。  如果不设置为NO，只能在后台运行15分钟后就会处于挂起状态。
        manager._locationManager.pausesLocationUpdatesAutomatically = NO;
        //这是iOS9中针对后台定位推出的新属性 不设置的话 可是会出现顶部蓝条的哦(类似热点连接)
        if ([manager._locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]) {
            // 若不设置，默认为NO。不会后台进行定位。
            [manager._locationManager setAllowsBackgroundLocationUpdates:YES];
        }
    });
    return manager;
}

- (void)startLocation
{
    [self._locationManager startUpdatingLocation];
}

@end

//
//  LocationManager.h
//  定位
//
//  Created by 木子女乔 on 2016/12/26.
//  Copyright © 2016年 木子女乔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

@property (nonatomic,strong)CLLocationManager *_locationManager;


+ (LocationManager *)shareInstance;

- (void)startLocation;
@end

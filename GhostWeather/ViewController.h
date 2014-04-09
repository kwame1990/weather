//
//  ViewController.h
//  GhostWeather
//
//  Created by xx on 14-3-17.
//  Copyright (c) 2014年 sxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>


@interface ViewController :UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UITextField *text;

@property (weak, nonatomic) IBOutlet NSTimer *timer,*timer1;

@property (nonatomic)NSMutableArray * cityid;

@property (nonatomic) int jindu ,positioned_error;

@property (nonatomic) NSString * sublocality, *state, *nowcityid, *nowcityname, *appid, *superkey, *dateTime, *nowlocality, *nowcity;

@property (nonatomic)NSDictionary *read_wind_dic,*read_weather_dic,*observe_weather,*index_weather,*forecast3d_weather;
//当前天气效果以及时间
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *label_t;
@property (weak, nonatomic) IBOutlet UILabel *labs;
@property (weak, nonatomic) IBOutlet UILabel *labz;
@property (weak, nonatomic) IBOutlet UILabel *labweather;
@property (weak, nonatomic) IBOutlet UILabel *labdwd;
@property (weak, nonatomic) IBOutlet UILabel *labwind;
@property (weak, nonatomic) IBOutlet UILabel *labzsjb;
@property (weak, nonatomic) IBOutlet UILabel *labsd;
@property (weak, nonatomic) IBOutlet UILabel *labfh1;
@property (weak, nonatomic) IBOutlet UILabel *labfh2;




//未来两天
@property (weak, nonatomic) IBOutlet UILabel *next_day1;
@property (weak, nonatomic) IBOutlet UILabel *next_day2;
@property (weak, nonatomic) IBOutlet UIImageView *next_day1_image;
@property (weak, nonatomic) IBOutlet UIImageView *next_day2_image;
@property (weak, nonatomic) IBOutlet UILabel *labtomo1;
@property (weak, nonatomic) IBOutlet UILabel *labtomo2;
@property (weak, nonatomic) IBOutlet UILabel *fh1;
@property (weak, nonatomic) IBOutlet UILabel *fh2;

@property (weak, nonatomic) IBOutlet UILabel *fh3;
@property (weak, nonatomic) IBOutlet UILabel *fh4;

@property (weak, nonatomic) IBOutlet UILabel *labwd1;
@property (weak, nonatomic) IBOutlet UILabel *labwd2;


@property (weak, nonatomic) IBOutlet UILabel *labzs1;
@property (weak, nonatomic) IBOutlet UILabel *labzs2;

@property (weak, nonatomic) IBOutlet UILabel *cyzs;

@property (weak, nonatomic) IBOutlet UILabel *rcrlsj;









@end

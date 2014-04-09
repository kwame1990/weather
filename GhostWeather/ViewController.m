//
//  ViewController.m
//  GhostWeather
//
//  Created by xx on 14-3-17.
//  Copyright (c) 2014年 sxw. All rights reserved.
//

#import "ViewController.h"
#import "CUSFlashLabel.h"
#import "FMDB.h"
#import "AppDelegate.h"



@implementation CLLocationManager (TemporaryHack)

//- (void)hackLocationFix
//{
//    //CLLocation *location = [[CLLocation alloc] initWithLatitude:42 longitude:-50];
//    float latitude = 40.0357;
//    float longitude = 116.3033;  //这里可以是任意的经纬度值
//    CLLocation *location= [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    [[self delegate] locationManager:self didUpdateToLocation:location fromLocation:nil];
//}
//
//- (void)startUpdatingLocation
//{
//    [self performSelector:@selector(hackLocationFix) withObject:nil afterDelay:0.1];
//}

@end

@interface ViewController ()

@end

@implementation ViewController
{
    CLLocationManager *locationManager;
    CLLocation *checkinLocation;
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appid = [NSString stringWithString:@"f7e3ef"];
    self.positioned_error = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 8
                                                  target: self
                                                selector: @selector(handleTimer:)
                                                userInfo: nil
                                                 repeats: YES];
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval: 1
                                                  target: self
                                                selector: @selector(label_time:)
                                                userInfo: nil
                                                 repeats: YES];
    [locationManager startUpdatingLocation];
    [self weatherTime];
    [self setupLocationManager];
    [self UI_Set];
    	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)enter_down:(id)sender//输入查询
{

    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"we.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSLog(@"open db file ok!");
    NSLog(@"==%@",self.text.text);
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM citys where name like '%@%%'",self.text.text];
    
    FMResultSet *result = [db executeQuery:sql];

    int r1 = 0 ;
    NSString * r;
    while ([result next])
    {
        r1 = 1;
        NSLog(@"cityname:%@     citynum %@",[result stringForColumn:@"name"],r = [result stringForColumn:@"city_num"]);
        self.nowcityid = r;
        [self.cityid addObject:r];
        ;
    }
    
    if (r1 == 0)
    {
        self.text.text =@"";
        self.text.placeholder  = @"您查找的城市不存在，请重新输入";
    }
    else
    {
        self.forecast3d_weather = [self weather:@"forecast3d"];
        self.observe_weather = [self weather:@"observe"];
        self.index_weather = [self weather:@"index"];
        
        [self display_now];
        [self display_coming];
    }
    
    [db close];
   

}

- (void) UI_Set//界面
{
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"天气1.jpg"]]];
    //图片大小根据屏幕自动适应
    UIImage *img_m = [UIImage imageNamed:@"天气1.jpg"];
    UIImage *img_a;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    [img_m drawInRect:CGRectMake(0, 0, width, height)];
    img_a = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:img_a];
    //webView 背景透明
    // [self.webview setBackgroundColor:[UIColor clearColor]];
    //[self.webview setOpaque:NO];
    //text 属性修改
    self.text.borderStyle = UITextBorderStyleRoundedRect;
    
    self.text.autocorrectionType = UITextAutocorrectionTypeYes;
    
    self.text.placeholder = @"请输入要查询的城市";
    
    self.text.returnKeyType = UIReturnKeyDone;
    
    self.text.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.text setBackgroundColor:[UIColor whiteColor]];
    
    //label流光效果
    self.title = @"TheWeather";
    UIView *view = self.view;
    CGFloat x = 20;
    CUSFlashLabel *label = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(x, 90, 300, 20)];
    [label setText:@"城 市 :"];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setContentMode:UIViewContentModeTop];
    [label startAnimating];
    [view addSubview:label];
    
    CUSFlashLabel *label1 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(x, 120, 300, 20)];
    [label1 setText:@"天 气 :"];
    [label1 setFont:[UIFont systemFontOfSize:15]];
    [label1 setContentMode:UIViewContentModeTop];
    [label1 startAnimating];
    [view addSubview:label1];
    
    CUSFlashLabel *label2 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(x, 150, 300, 20)];
    [label2 setText:@"温 度 :"];
    [label2 setFont:[UIFont systemFontOfSize:15]];
    [label2 setContentMode:UIViewContentModeTop];
    [label2 startAnimating];
    [view addSubview:label2];
    
    CUSFlashLabel *label3 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(x, 180, 300, 20)];
    [label3 setText:@"风 向 :"];
    [label3 setFont:[UIFont systemFontOfSize:15]];
    [label3 setContentMode:UIViewContentModeTop];
    [label3 startAnimating];
    [view addSubview:label3];

    CUSFlashLabel *label5 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(x, 210, 420, 20)];
    [label5 setText:@"未来两天:"];
    [label5 setFont:[UIFont systemFontOfSize:15]];
    [label5 setContentMode:UIViewContentModeTop];
    [label5 startAnimating];
    [view addSubview:label5];
    
    CUSFlashLabel *label7 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(x, 320, 420, 20)];
    [label7 setText:@"穿衣指数:"];
    [label7 setFont:[UIFont systemFontOfSize:15]];
    [label7 setContentMode:UIViewContentModeTop];
    [label7 startAnimating];
    [view addSubview:label7];
    
    CUSFlashLabel *label9 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(180, 180, 300, 20)];
    [label9 setText:@"空气湿度:"];
    [label9 setFont:[UIFont systemFontOfSize:15]];
    [label9 setContentMode:UIViewContentModeTop];
    [label9 startAnimating];
    [view addSubview:label9];
    
    CUSFlashLabel *label6 = [[CUSFlashLabel alloc]initWithFrame:CGRectMake(x, 430, 300, 20)];
    [label6 setText:@"日出日落时间:"];
    [label6 setFont:[UIFont systemFontOfSize:15]];
    [label6 setContentMode:UIViewContentModeTop];
    [label6 startAnimating];
    [view addSubview:label6];
}

- (void) weatherTime//获得系统时间传入接口
{
    NSDate *  senddate=[NSDate date];
        
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddHHmm"];
    
    self.dateTime = [dateformatter stringFromDate:senddate];
}

- (void) setupLocationManager//定位
{
    if ([CLLocationManager locationServicesEnabled]) {//判断手机是否可以定位
         NSLog( @"Starting CLLocationManager" );
        locationManager = [[CLLocationManager alloc] init];//初始化位置管理器
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精度
        locationManager.distanceFilter = 1000.0f;//设置距离筛选器
        [locationManager startUpdatingLocation];//启动位置管理器
    }
    else {
        NSLog( @"Cannot Starting CLLocationManager" );
        locationManager.delegate = self;
        locationManager.distanceFilter = 1000.0f;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
    }
}


-(void) handleTimer: (NSTimer *) timer//定时器判断定位是否成功
{
   
    if (self.positioned_error == 0)
    {
         NSLog(@"重新定位");
       // [locationManager startUpdatingLocation];
        [self setupLocationManager];
    }
    else
        if (self.positioned_error == 1)
        {
            [self.timer invalidate];
        }
}

- (void) label_time : (NSTimer *) timer1//当前系统时间
{
   // NSLog(@"****************************");
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy年MM月dd日 EEEE             HH:mm:ss"];
    
    
    self.label_t.text = [dateformatter stringFromDate:senddate];
}


//打印出地理位置
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    checkinLocation = newLocation;
    
    NSLog(@"Are positioned...");
    //定位城市通过CLGeocoder
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark * placemark in placemarks)
         {
             NSLog(@"Country = %@", placemark.country);
             NSLog(@"Postal Code = %@", placemark.postalCode);
             NSLog(@"Locality = %@", placemark.locality);
             self.nowlocality = placemark.locality;
             NSLog(@"dic State = %@", [placemark.addressDictionary objectForKey:@"State"]);//市
             self.state = [placemark.addressDictionary objectForKey:@"State"];
             NSLog(@"dic SubLocality= %@", [placemark.addressDictionary objectForKey:@"SubLocality"]);//区
             self.sublocality =[placemark.addressDictionary objectForKey:@"SubLocality"];
             NSLog(@"dic Thoroughfare = %@", [placemark.addressDictionary objectForKey:@"Thoroughfare"]);
             
             NSLog(@"dic SubThoroughfare= %@", [placemark.addressDictionary objectForKey:@"SubThoroughfare"]);
             
             NSLog(@"dic Street = %@", [placemark.addressDictionary objectForKey:@"Street"]);
             
             NSLog(@"dic Name = %@", [placemark.addressDictionary objectForKey:@"Name"]);//地点
             
             if (self.sublocality != NULL)
             {
                 self.nowcityname = self.sublocality;
             }
             else
             {
                 if(self.nowlocality != NULL)
                     self.nowcityname = self.nowlocality;
                 else
                     self.nowcityname = self.state;
             }
             
             self.nowcityid = [self serch_id : self.nowcityname];
             self.forecast3d_weather = [self weather:@"forecast3d"];
             self.observe_weather = [self weather:@"observe"];
             self.index_weather = [self weather:@"index"];
             
             [self display_now];
             [self display_coming];
             
//             NSLog(@"%@",self.forecast3d_weather);
//             NSLog(@"%@",self.observe_weather);
//             NSLog(@"%@",self.index_weather);
        
             self.positioned_error = 1;
     }
     }];
    
}

-(NSString *)serch_id : (NSString *) cityname//sql城市定位数据库
{
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"we.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSLog(@"open db file ok!");
    NSLog(@"%@",cityname);
   
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM citys where name like '%%%@%%'",cityname];
    
    FMResultSet *result = [db executeQuery:sql];
    NSString * r;
    self.cityid = [[NSMutableArray alloc]init];
    NSLog(@"%@",self.cityid);
    while ([result next])
    {
        NSLog(@"cityname:%@     citynum %@",[result stringForColumn:@"name"],r = [result stringForColumn:@"city_num"]);
        self.nowcityid = r;
        [self.cityid addObject:r];
        ;
    }
    [db close];
    return r;
    

}

- (NSDictionary *) weather : (NSString*)type//天气接口
{
    NSError * error;
    NSString *urlstring = [NSString stringWithFormat:@"http://webapi.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=f7e3efc31407db6d",self.nowcityid,type,self.dateTime];
    NSLog(@"=======%@",type);
    NSLog(@"=======%@",self.nowcityid);
    NSLog(@"=======%@",self.dateTime);
    
    NSString * key = [self hmacSha1:@"3edbe9_SmartWeatherAPI_4ff3e05" text:urlstring];
    
    NSString *skey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.superkey = skey;
    
    NSString * surl = [NSString stringWithFormat:@"http://webapi.weather.com.cn/data/?areaid=%@&type=%@&date=%@&appid=%@&key=%@",self.nowcityid,type,self.dateTime,self.appid,self.superkey];

   
    NSURL * url = [NSURL URLWithString:surl];
    //NSLog(@"%@",url);
    NSString *string = [NSString stringWithContentsOfURL:url encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8) error:&error];
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
 
   // NSLog(@"%@",Dic);

    return Dic;

    
}

-(NSString *) hmacSha1:(NSString*)key text:(NSString*)text//哈稀算法转换公钥
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    int i;
    for(i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    NSData *data1 = [NSData dataWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    NSString * key1 = [data1 base64Encoding];
    
    return key1;
}

- (void) weather_wind_dic//天气／风力字典
{
    NSString * weather1 = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"weather.txt"];
    NSString * wind1 = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"wind.txt"];
    
    self.read_weather_dic = [NSDictionary dictionaryWithContentsOfFile:weather1];
    self.read_wind_dic = [NSDictionary dictionaryWithContentsOfFile:wind1];
   // NSLog(@"%@",self.read_wind_dic);
}

- (void) display_now
{
    [self weather_wind_dic];
    self.labz.text = self.forecast3d_weather[@"c"][@"c3"];
    self.labs.text = self.forecast3d_weather[@"c"][@"c7"];
    self.labdwd.text = self.observe_weather[@"l"][@"l1"];
    self.labwind.text = self.read_wind_dic[self.observe_weather[@"l"][@"l3"]];
    self.labzsjb.text = self.index_weather[@"i"][0][@"i4"];
    NSLog(@"====%@====",self.index_weather[@"i"][0][@"i4"]);
    self.labsd.text = self.observe_weather[@"l"][@"l2"];
    self.labfh2.text = @"℃";
    self.labfh1.text = @"%";
    
    
    UIImage *img;
 
    if (self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][0][@"fa"]] == NULL)
    {
        self.labweather.text = self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][0][@"fb"]];
                                
        NSString *filename =[NSString stringWithFormat:@"1%@.png",self.forecast3d_weather[@"f"][@"f1"][0][@"fb"]];
        NSString * f = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:filename];
        img = [UIImage imageWithContentsOfFile:f];
        self.image_view.image = img;
    }
   else
   {
       self.labweather.text = self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][0][@"fa"]];
       NSString * str = [NSString stringWithFormat :@"%@.png",self.forecast3d_weather[@"f"][@"f1"][0][@"fa"]];
     
       NSString * filename = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:str];
       img = [UIImage imageWithContentsOfFile:filename];
       
       self.image_view.image = img;
   }
    
    
}

- (void) display_coming
{
    [self weather_wind_dic];
    self.labtomo1.text = @"明天:";
    self.labtomo2.text = @"后天:";
    self.fh1.text = @"℃ -";
    self.fh2.text = @"℃ -";
    self.fh3.text = @"℃";
    self.fh4.text = @"℃";
    self.next_day1.text =self.forecast3d_weather[@"f"][@"f1"][1][@"fd"];
    self.next_day2.text =self.forecast3d_weather[@"f"][@"f1"][2][@"fd"];
    self.labwd1.text = self.forecast3d_weather[@"f"][@"f1"][1][@"fc"];
    self.labwd2.text = self.forecast3d_weather[@"f"][@"f1"][1][@"fc"];
    UIImage *img;
    
    if (self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][0][@"fa"]]  == NULL)
    {
        self.labzs1.text = self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][1][@"fb"]];
        NSString *filename =[NSString stringWithFormat:@"1%@.png",self.forecast3d_weather[@"f"][@"f1"][0][@"fb"]];
        NSString * f = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:filename];
        img = [UIImage imageWithContentsOfFile:f];
        self.next_day1_image.image = img;
    }
    else
    {
        self.labzs1.text = self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][1][@"fa"]];
        NSString *filename =[NSString stringWithFormat:@"%@.png",self.forecast3d_weather[@"f"][@"f1"][0][@"fb"]];
        NSString * f = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:filename];
        img = [UIImage imageWithContentsOfFile:f];
        
        self.next_day1_image.image = img;
    }
    UIImage *im;
    
    if ( self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][0][@"fa"]] == NULL)
    {
        self.labzs2.text = self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][2][@"fb"]];
        NSString *filename =[NSString stringWithFormat:@"1%@.png",self.forecast3d_weather[@"f"][@"f1"][0][@"fb"]];
        NSString * f = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:filename];
        img = [UIImage imageWithContentsOfFile:f];
        self.next_day2_image.image = img;
    }
    else
    {
        self.labzs2.text = self.read_weather_dic[self.forecast3d_weather[@"f"][@"f1"][2][@"fa"]];
        NSString *filename =[NSString stringWithFormat:@"%@.png",self.forecast3d_weather[@"f"][@"f1"][0][@"fb"]];
        NSString * f = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:filename];
        img = [UIImage imageWithContentsOfFile:f];
        self.next_day2_image.image = img;
    }

    self.cyzs.lineBreakMode = UILineBreakModeWordWrap;
    self.cyzs.numberOfLines = 4;
    self.cyzs.text = self.index_weather[@"i"][0][@"i5"];
    NSLog(@"%@",self.index_weather[@"i"][0][@"i5"]);
    self.rcrlsj.text = self.forecast3d_weather[@"f"][@"f1"][0][@"fi"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

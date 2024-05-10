//
//  Constants.h
//  SupApp
//
//  Created by SmartGladiator on 19/01/16.
//  Copyright (c) 2016 Smart Gladiator. All rights reserved.
//

//#define BASE_URL @"http://ec2-54-144-60-83.compute-1.amazonaws.com/loadproof/api/v1"//Site
//#define BASE_URL @"https://api.loadproof.us/api/v1"//Live pre-pro
//#define BASE_URL @"http://ec2-54-204-9-153.compute-1.amazonaws.com/api/v1"//Site
#define BASE_URL @"https://api.loadproof.us/api/v1"//PROD
#define SITEM_URL @"https://api.loadproof.us/"//siteMaintenance
#define TIMEZONE_URL @"https://api.geoapify.com/v1/geocode/reverse?"//timezone
#define TIMEZONE_KEY @"211328a5405e470783a797ee672d35ee"

#define API_GET_USER_NAME @"user_name_validation"
#define API_GET_USER_NAME_AND_USER_PIN @"user_pin_login_temp"
#define API_TO_UPLOAD_IMAGE @"upload_image_in_bucket"
#define API_TO_UPLOAD_LOAD_CENTRIC_IMAGE @"upload_load_centric_image_in_bucket"
#define API_TO_DRIVER_UPLOAD_IMAGE @"upload_extend_image_in_bucket"
#define API_TO_QUALITY_ISSUE @"quality_email"
#define API_TO_ADDON_MAIL @"addon_email_alert"
#define API_TO_ADDON5 @"addon_file_json_output"
#define API_TO_LASTSEEN @"device_last_seen_activity"
#define API_TO_LOGOUT @"device_logout"
#define API_TO_OFFLINE_DEVICE_LOG @"offline_device_logs"
#define API_TO_UPLOAD_LOOPING_IMAGE @"upload_looping_image_in_bucket"
#define API_TO_DRIVER_SITE_VALIDATION @"qr_generator_link"
#define API_TO_GET_CENTRIC_DATA @"qr_generator_link_lp_user"

#define Red [UIColor colorWithRed:200.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.9f]
#define PaleRed [UIColor colorWithRed:188.0f/255.0f green:38.0f/255.0f blue:25.0f/255.0f alpha:0.3f]
#define PaleGreen [UIColor colorWithRed:0 green:28.0f/255.0f blue:0 alpha:0.3f ]
#define Green [UIColor colorWithRed:0 green:150.0f/255.0f blue:0 alpha:0.9f ]
#define Blue [UIColor colorWithRed: 0.11 green: 0.65 blue: 0.71 alpha: 1.0f ]
#define PaleBlue [UIColor colorWithRed: 0.23 green: 0.48 blue: 0.53 alpha: 1.00]
#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
#define paleBlue [UIColor colorWithRed: 0.29 green: 0.64 blue: 0.66 alpha: 1.00]
#define Purple [UIColor colorWithRed: 0.67 green: 0.34 blue: 0.64 alpha: 1.00]
#define Orange [UIColor colorWithRed: 0.93 green: 0.51 blue: 0.00 alpha: 1.00]
#define Lavender [UIColor colorWithRed: 0.65 green: 0.60 blue: 0.97 alpha: 1.00]
#define Gold [UIColor colorWithRed: 0.85 green: 0.65 blue: 0.13 alpha: 1.00]




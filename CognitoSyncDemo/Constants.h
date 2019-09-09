//
//  Constants.h
//  SupApp
//
//  Created by SmartGladiator on 19/01/16.
//  Copyright (c) 2016 Smart Gladiator. All rights reserved.
//


//#define LOAD_PROOF_PROD

//#ifdef LOAD_PROOF_PROD

//#define BASE_URL @"http://52.87.170.191/loadproof/api/v1"
//Development...
//#define BASE_URL @"http://52.87.170.191/loadproof_development/loadproof/api/v1/"

//Production
#define BASE_URL @"http://ec2-52-87-170-191.compute-1.amazonaws.com/loadproof/api/v1"
//#else

//#define BASE_URL @"http://52.87.170.191/test_environment/loadproof/api/v1"
#define API_GET_USER_NAME @"user_name_validation.php"
#define API_GET_USER_NAME_AND_USER_PIN @"user_pin_login_temp.php"
#define API_TO_UPLOAD_IMAGE @"upload_image_in_bucket.php"
#define IS_STANDARD_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_IOS_7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7)




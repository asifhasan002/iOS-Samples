//
//  Default.h
//  JigsawPuzzle
//
//  Created by XOR Geek 03 on 1/2/17.
//  Copyright © 2017 XOR Geek 03. All rights reserved.
//

#ifndef Default_h
#define Default_h

//drawer external url

#define ANNOUNCEMENT_URL        @"https://www.shibusawa.or.jp/english/museum/news.html"
#define MUSEUM_URL              @"https://www.shibusawa.or.jp/english/museum/index.html"
#define EVENT_INFO_URL          @"https://www.shibusawa.or.jp/english/museum/special/index.html"
#define FACEBOOK_PAGE_URL       @"https://www.facebook.com/ShibusawaEiichiMemorialFoundation/"
#define TERMS_OF_USE_URL        @"https://www.shibusawa.or.jp/english/outline/index.html"
#define FAQ_URL                 @"https://www.shibusawa.or.jp/english/museum/visit.html"

//original image split according to row and columns (ROW*COLUMN = imgage pieces)
#define ROW                     5
#define COLUMN                  5

//initial tag values of images in different conditions
#define TAGVALUE                100
#define BACKTAGVALUE            1000
#define DISABLETAGVALUE         10000

//
#define AUTO_MATCH              1

//nsuser default key
#define CHECKIN_STATUS_KEY      @"check_in_status"
#define CHECKIN_ID_KEY          @"check_in_id"

#define TUTORIAL_STATUS_KEY     @"tutorial_status"

//Local notification time
#define CLOSING_TIME_HOURS      12
#define CLOSING_TIME_MINUTES    56
#define CLOSING_TEST_TIME       60

//static webpages name
#define KNOW_MAKER_PAGE         @"know_maker"
#define THREE_BUILDING_PAGE     @"three_building"
#define SHIBUSAWA_USE_PAGE      @"shibusawa_use"

//map default info
#define DEFAULT_LATITUDE        35.749172
#define DEFAULT_LONGITUDE       139.739746
#define DEFAULT_ZOOM_LEVEL      18
#define DISTANCE_FILTER         10
#define POINT_DISTANCE          20
#define MARKER_DEFAULT_WIDTH    21.50f
#define MARKER_DEFAULT_HEIGHT   38.50f
#define MARKER_ENLARGE_WIDTH    43.0f
#define MARKER_ENLARGE_HEIGHT   77.0f

#define DEFAULT_ZERO            0

//database constant
#define DATABASE_NAME           @"shibusawa_walker_db.sqlite"

#define GUIDE_POINT_TABLE       @"guide_point_table"
//#define GUIDE_POINT_TABLE       @"guide_point_sample_table"

#define ID                      @"id"
#define NAME                    @"name"
#define IMAGE_NAME              @"image_name"
#define LATITUDE                @"latitude"
#define LONGITUDE               @"longitude"
#define DESCRIPTION             @"description"

#define CHECKIN_TABLE           @"checkin_table"
#define CHECKIN_POINT_NAME      @"checkin_point_name"
#define CHECKIN_TIME            @"checkin_time"
#define CHECKOUT_TIME           @"checkout_time"



#endif /* Default_h */

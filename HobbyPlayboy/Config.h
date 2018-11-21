//
//  Config.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 8/8/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define DEBUG_LEVEL DEBUG_LEVEL_BRIEF

#define DEBUG_LEVEL_NONE 0
#define DEBUG_LEVEL_BRIEF 1
#define DEBUG_LEVEL_FULL 2

#if DEBUG_LEVEL == DEBUG_LEVEL_NONE
/* No debug information */
#elseif DEBUG_LEVEL == DEBUG_LEVEL_BRIEF
/* Brief debug information */
#elseif DEBUG_LEVEL == DEBUG_LEVEL_FULL
/* Full debug information */
#endif

//Gallery Browsing Related
#define BROWSING_AUTO_SCROLL_SPEED_FAST 3.0
#define BROWSING_AUTO_SCROLL_SPEED_MEDIUM 5.0
#define BROWSING_AUTO_SCROLL_SPEED_SLOW 8.0

#define ANIMATION_DURATION 0.3
#define BACKGROUND_COLOR_ALPHA 0.85

#endif /* Config_h */

//
//  WPBaseHeader.h
//  Pods
//
//  Created by wupeng on 2019/9/22.
//

#ifndef WPBaseHeader_h
#define WPBaseHeader_h

#ifdef __OBJC__

#import "WPCommonMacros.h"
#undef CMWeak
#define CMWeak(...) @weakify(__VA_ARGS__)
#define CMWeakSelf CMWeak(self)

#undef CMStrong
#define CMStrong(...) @strongify(__VA_ARGS__)
#define CMStrongSelf CMStrong(self)

#endif

#endif /* WPBaseHeader_h */

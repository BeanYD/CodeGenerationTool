# Copyright (c) 2012 The WebRTC project authors. All Rights Reserved.
#
# Use of this source code is governed by a BSD-style license
# that can be found in the LICENSE file in the root of the source
# tree. An additional intellectual property rights grant can be found
# in the file PATENTS.  All contributing project authors may
# be found in the AUTHORS file in the root of the source tree.

SWFPLAYER_PATH := $(call my-dir)

MY_SWFPLAYER_PATH := ..

include $(SWFPLAYER_PATH)/$(MY_SWFPLAYER_PATH)/../opensource/tinyxml/Android.mk
include $(SWFPLAYER_PATH)/$(MY_SWFPLAYER_PATH)/../opensource/jpeg/Android.mk
include $(SWFPLAYER_PATH)/$(MY_SWFPLAYER_PATH)/SwfView/SwfView/Android.mk

LOCAL_PATH := $(call my-dir)



include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := SwfView
LOCAL_MODULE_TAGS := optional

LOCAL_WHOLE_STATIC_LIBRARIES := \
					libucgameswf			\
#					libucnet			\
#					libucwcc			\
#					libucpdu			\
#					libucpingpdu	\
					
#third_party	libjpeg_turbo \
#third_party	libcommon_video \
#third_party	libvpx \
#third_party	libvpx_arm_neon \
#modules\bitrate_controller\include	libbitrate_controller \
#system_wrappers\source\android libcpu_features_android \
#modules\bitrate_controller libremote_bitrate_estimator \
#webrtc\test\channel_transport	libudp_transport \
#webrtc\test\channel_transport	libchannel_transport \
#webrtc\modules    libaudioproc_debug_proto \
#third_party\protobuf    libprotobuf_lite \
    


LOCAL_SHARED_LIBRARIES := \
    uctinyxml \
	ucjpeg	\


LOCAL_LDLIBS := \
    -lgcc \
    -llog \
    -lGLESv1_CM \
    -lOpenSLES \
    -lz 	\
	
LOCAL_PRELINK_MODULE := false

include $(BUILD_SHARED_LIBRARY)


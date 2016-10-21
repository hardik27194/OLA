LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)


LOCAL_MODULE    := lua
LOCAL_SRC_FILES := lapi.c lauxlib.c lbaselib.c lcode.c ldblib.c ldebug.c ldo.c ldump.c lfunc.c lgc.c linit.c liolib.c llex.c lmathlib.c lmem.c loadlib.c lobject.c lopcodes.c loslib.c lparser.c lstate.c lstring.c lstrlib.c ltable.c ltablib.c ltm.c lundump.c lvm.c lzio.c lfs.c luasocket.c timeout.c buffer.c io.c auxiliar.c options.c inet.c tcp.c udp.c except.c select.c usocket.c mime.c  
  
LOCAL_LDLIBS    := -ld -lm

include $(BUILD_STATIC_LIBRARY)

SYSROOT = /opt/local/var/iPhoneOS4.3.sdk
CC = arm-apple-darwin10-gcc
LD = $(CC)
CFLAGS = -isysroot $(SYSROOT) \
	 -Wall \
	 -DTARGET_OS_IPHONE=1 \
	 -c
LDFLAGS = -isysroot $(SYSROOT) \
	  -w \
	  -F/System/Library/PrivateFrameworks \
	  -lobjc

SERVER_LIBS = -lsubstrate \
	   -framework Foundation \
	   -framework StoreServices \
	   -framework AppSupport

CLIENT_LIBS = -framework Foundation \
	      -framework AppSupport

TOOL_LIBS = -framework Foundation \
	    -lipodimportclient

CODESIGN = ldid -S
HEADERS = ipodimport.h
TARGETS = ipodimportserver.dylib libipodimportclient.dylib addtoipod

all: $(TARGETS)

ipodimportserver.dylib: server.o
	$(LD) $(LDFLAGS) $(SERVER_LIBS) -o $@ -dynamiclib $^

libipodimportclient.dylib: client.o
	$(LD) $(LDFLAGS) $(CLIENT_LIBS) -o $@ -dynamiclib -install_name /usr/lib/$@ $^
	cp $@ $(SYSROOT)/usr/lib/
	cp $(HEADERS) $(SYSROOT)/usr/include/

addtoipod: addtoipod.o
	$(LD) $(LDFLAGS) $(TOOL_LIBS) -o $@ $^
	$(CODESIGN) $@

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $<

CC = arm-apple-darwin10-gcc
LD = $(CC)
CFLAGS = -isysroot /opt/local/var/iPhoneOS4.3.sdk \
	 -Wall \
	 -DTARGET_OS_IPHONE=1 \
	 -c
LDFLAGS = -isysroot /opt/local/var/iPhoneOS4.3.sdk \
	  -w \
	  -dynamiclib \
	  -F/System/Library/PrivateFrameworks \
	  -lobjc \
	  -lsubstrate \
	  -framework CoreFoundation \
	  -framework Foundation \
	  -framework AppSupport \
	  -framework StoreServices

all: ipodimportserver.dylib libipodimportclient.dylib

ipodimportserver.dylib: server.o
	$(LD) $(LDFLAGS) -o $@ $^

libipodimportclient.dylib: client.o
	$(LD) $(LDFLAGS) -o $@ -install_name /usr/lib/$@ $^

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $<

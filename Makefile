TARGET=TextFieldWidget
VERSION=1.0
ARCHIVENAME=TextFieldWidget
ARCHIVE=$(ARCHIVENAME)-$(VERSION).tar.gz


all: $(TARGET).swf $(TARGET)Config.swf

$(TARGET)Config.swf: build/config.swf conf/config.xml 
	swfmill simple conf/config.xml $(TARGET)Config.swf

$(TARGET).swf:  build/classes.swf conf/widget.xml 
	swfmill simple conf/widget.xml $(TARGET).swf

build/classes.swf:  $(TARGET).as
	mtasc -swf build/classes.swf -header 320:240:12 $(TARGET).as

build/config.swf: $(TARGET)Config.as
	mtasc -swf build/config.swf -header 320:240:12 $(TARGET)Config.as

$(ARCHIVE): $(TARGET).swf $(TARGET)Config.swf
	tar --exclude=.svn --exclude=$(ARCHIVE) -czvf $(ARCHIVE) ../TextFieldWidget

clean:
	rm -f build/* $(TARGET).swf $(TARGET)Config.swf $(ARCHIVE)

run: all
	scp $(TARGET).swf 192.168.0.117:/var/www
	flashplayer.debug http://192.168.0.117/$(TARGET).swf

config: all
	scp $(TARGET)Config.swf 192.168.0.117:/var/www
	flashplayer.debug http://192.168.0.117/$(TARGET)Config.swf

release: $(ARCHIVE)

prereqs:
	sudo apt-get install swfmill mtasc

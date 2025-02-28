LIB=execinfo
SRCS=stacktraverse.c execinfo.c
OBJS=$(SRCS:.c=.o)
CFLAGS=-Wall -fPIC -I.
LDFLAGS=-shared
TARGET=libexecinfo.so
HEADERS = execinfo.h
PREFIX ?= /usr
LIBDIR ?= $(PREFIX)/lib
INCLUDEDIR ?= $(PREFIX)/include

all: $(TARGET)

$(TARGET): $(OBJS)
        $(CC) $(LDFLAGS) -o $(TARGET) $(OBJS) -lm

%.o: %.c
        $(CC) $(CFLAGS) -c $< -o $@

clean:
        rm -f $(OBJS) $(TARGET)
        rm -f $(TARGET) *.o

install: $(TARGET) $(HEADERS)
        # Erstelle Verzeichnisse, falls sie nicht existieren
        mkdir -p $(DESTDIR)$(LIBDIR)
        mkdir -p $(DESTDIR)$(INCLUDEDIR)
        # Kopiere die Bibliothek und erstelle Symlinks
        install -m 755 $(TARGET) $(DESTDIR)$(LIBDIR)/$(TARGET).1.0
        ln -sf $(TARGET).1.0 $(DESTDIR)$(LIBDIR)/$(TARGET)
        ln -sf $(TARGET).1.0 $(DESTDIR)$(LIBDIR)/$(TARGET).1
        # Kopiere die Header-Datei
        install -m 644 $(HEADERS) $(DESTDIR)$(INCLUDEDIR)/

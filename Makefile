LIB=execinfo
SRCS=stacktraverse.c execinfo.c
OBJS=$(SRCS:.c=.o)

# Standardmäßig den System-Compiler verwenden, kann aber durch Cross-Compiler überschrieben werden
CC ?= gcc
AR ?= ar
RANLIB ?= ranlib
LD ?= ld

CFLAGS ?= -Wall -fPIC -I.
LDFLAGS ?= -shared
TARGET=libexecinfo.so
STATIC_TARGET=libexecinfo.a

HEADERS = execinfo.h
PREFIX ?= /usr
LIBDIR ?= $(PREFIX)/lib
INCLUDEDIR ?= $(PREFIX)/include

all: $(TARGET) $(STATIC_TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJS) -lm

$(STATIC_TARGET): $(OBJS)
	$(AR) rcs $(STATIC_TARGET) $(OBJS)
	$(RANLIB) $(STATIC_TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET) $(STATIC_TARGET)
	rm -f *.o

install: $(TARGET) $(STATIC_TARGET) $(HEADERS)
	# Erstelle Verzeichnisse, falls sie nicht existieren
	mkdir -p $(DESTDIR)$(LIBDIR)
	mkdir -p $(DESTDIR)$(INCLUDEDIR)

	# Installiere die Shared Library und erstelle Symlinks
	install -m 755 $(TARGET) $(DESTDIR)$(LIBDIR)/$(TARGET).1.0
	ln -sf $(TARGET).1.0 $(DESTDIR)$(LIBDIR)/$(TARGET)
	ln -sf $(TARGET).1.0 $(DESTDIR)$(LIBDIR)/$(TARGET).1

	# Installiere die Static Library
	install -m 644 $(STATIC_TARGET) $(DESTDIR)$(LIBDIR)/

	# Kopiere die Header-Datei
	install -m 644 $(HEADERS) $(DESTDIR)$(INCLUDEDIR)/

CFLAGS = -Wall -Wextra -g
LDFLAG =
CC = gcc

INCLUDE = -I../include
OBJDIR = ./obj
BINDIR = ../bin

LIB_SRC = shell.c

TARGETS = $(patsubst %.c,$(BINDIR)/%,$(wildcard main.c))
OBJS = $(patsubst %.c,$(OBJDIR)/%.o,$(wildcard *.c))

LIBS = $(patsubst %.c,$(OBJDIR)/%.o,$(LIB_SRC))
LIBS_OBJS = $(LIBS) $(OBJS)

.PHONY: all lib clean

all:$(LIBS) $(OBJS) $(TARGETS) bin

bin: $(BINDIR)/main

$(BINDIR)/main: $(LIBS) $(OBJDIR)/main.o
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ $^

# $(BINDIR)/nobuffering: $(OBJDIR)/my_stdio.o $(OBJDIR)/nobuffering.o
# 	$(CC) $(CFLAGS) $(INCLUDE) -o $@ $^

$(LIBS_OBJS): $(OBJDIR)/%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDE) -o $@ -c $^


clean:
	rm -f $(OBJDIR)/* $(BINDIR)/*

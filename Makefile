PROJ_DIR = $(shell pwd)

CPPCHECKEXE=cppcheck
CPPLINTEXE=cpplint

INCDIRS:=

SRCS:=$(shell find src/ -type f -name '*.cpp')
OBJS:=$(addprefix obj/,$(notdir $(SRCS:.cpp=.o)))
EXE=bin/hello_world

CXXFLAGS:=-Wall -Wextra -pedantic -Werror -Weffc++ --std=c++11
CXXFLAGS+=$(INCDIRS)

CPPLINT_FILTER:=--filter=-legal/copyright,-readability/streams

obj/%.o: src/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	$(RM) obj/* bin/*

ifeq ($(SANITIZE), thread)
	CXXFLAGS += -fPIC -fPIE -fsanitize=thread
	LDFLAGS += -fsanitize=thread -fPIE
	LDLIBS += -pie
else
ifeq ($(SANITIZE), address)
	CXXFLAGS += -fsanitize=address
	LDFLAGS += -fsanitize=address
endif
endif

cppcheck:
	$(CPPCHECKEXE) $(INCDIRS) --enable=all --force src/

cpplint:
	$(CPPLINTEXE) $(CPPLINT_FILTER) $(SRCS)

debug: CXXFLAGS += -g
debug: CXXFLAGS += -fsanitize=undefined
debug: LDFLAGS += -fsanitize=undefined
debug: $(EXE)

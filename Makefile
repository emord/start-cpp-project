PROJ_DIR = $(shell pwd)

INCDIRS=

SRCS=$(shell find src/ -type f -name '*.cpp')
OBJS=$(addprefix obj/,$(notdir $(SRCS:.cpp=.o)))
EXE=bin/hello_world

CXXFLAGS=-Wall -Wextra -pedantic -Werror -Weffc++ --std=c++11
CXXFLAGS+=$(INCDIRS)

obj/%.o: src/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	$(RM) obj/* bin/*

cppcheck:
	cppcheck $(INCDIRS) --enable=all --force src/

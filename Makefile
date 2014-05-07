PROJ_DIR = $(shell pwd)

SRCS=$(shell find src/ -type f -name '*.cpp')
OBJS=$(addprefix obj/,$(notdir $(SRCS:.cpp=.o)))
EXE=bin/hello_world

CXXFLAGS=-Wall -Wextra -pedantic -Werror -Weffc++ --std=c++11

obj/%.o: src/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	$(RM) obj/* bin/*

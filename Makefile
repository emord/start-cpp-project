PROJECT_DIR = $(shell pwd)

CPPCHECKEXE=cppcheck
CPPLINTEXE=cpplint
SIMIANEXE=simian

INCDIRS:=-I src/include

SRCS:=$(shell find src/ -type f -name '*.cpp' ! -path 'src/test/*')
OBJS:=$(addprefix obj/,$(notdir $(SRCS:.cpp=.o)))
EXE=bin/hello_world

TEST_SRCS:=$(shell find test/src/ -type f -name '*.cpp')
TEST_OBJS:=$(addprefix test/obj/,$(notdir $(TEST_SRCS:.cpp=.o)))
TESTS:=$(addprefix test/bin/,$(notdir $(TEST_SRCS:_unittest.cpp=.test)))

CXXFLAGS:=-Wall -Wextra -pedantic -Werror -Weffc++ --std=c++11
CXXFLAGS+=$(INCDIRS)

CPPLINT_FILTER:=--filter=-legal/copyright,-readability/streams

all: $(EXE)

obj/%.o: src/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

gtest: LDLIBS += -lgtest -lgtest_main
gtest: $(TESTS)

test/obj/%.o: test/src/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

test/bin/%.test: obj/%.o test/obj/%_unittest.o
	$(CXX) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	$(RM) obj/*.o test/obj/* test/bin/* $(EXE)

ifeq ($(SANITIZE), thread)
	CXXFLAGS += -fPIC -fPIE -fsanitize=thread
	LDFLAGS += -fsanitize=thread -fPIE LDLIBS += -pie
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

simian:
	$(SIMIANEXE) **/*.cpp **/*.hpp

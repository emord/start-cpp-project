#include "hello_world.hpp"
#include "gtest/gtest.h"

TEST(HelloWorld, Return) {
    EXPECT_STREQ(ret_string().c_str(), "Hello world");
}

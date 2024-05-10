section .text
extern strchr
extern strstr

global main
main:
    TEST

    FUNC strchr
    EXPECT_STR_INDEX 0, "abc", %eval('a')
    EXPECT_STR_INDEX 1, "abc", %eval('b')
    EXPECT_STR_INDEX 2, "abc", %eval('c')
    EXPECT_NULL "abc", %eval('d')
    EXPECT_STR_INDEX 3, "abc", 0
    EXPECT_STR_INDEX 0, "", 0
    DONE

    FUNC strstr
    EXPECT_STR_INDEX 0, "abc", "ab"
    EXPECT_STR_INDEX 1, "abc", "bc"
    EXPECT_NULL "abc", "ac"
    EXPECT_STR_INDEX 0, "abc", ""
    EXPECT_STR_INDEX 0, "", ""
    EXPECT_NULL "", "a"
    DONE

    END_TEST
ret

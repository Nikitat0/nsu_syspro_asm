section .text
extern strchr

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
    END_TEST
    ret

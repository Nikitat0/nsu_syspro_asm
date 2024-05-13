section .text
extern strlen
extern strcat
extern strcmp
extern strchr
extern strstr
extern strspn
extern strcspn

global main
main:
    TEST

    FUNC strlen
    EXPECT_INT 6, "abcdef"
    EXPECT_INT 0, ""
    DONE

    FUNC strcmp
    EXPECT_INT 0, "", ""
    EXPECT_INT 0, "abcdef", "abcdef"
    EXPECT_INT %eval(-'a'), "", "abc"
    EXPECT_INT %eval('a'), "abc", ""
    EXPECT_INT %eval('a' - 'd'), "abc", "def"
    DONE

    FUNC strcat
    EXPECT_STRING "abcdef", strcat_1, "def"
    EXPECT_STRING "def", strcat_2, "def"
    EXPECT_STRING "", strcat_3, ""
    DONE

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

    FUNC strspn
    EXPECT_INT 3, "foo123", "abcdefghijklmnopqrstuvwxyz"
    EXPECT_INT 0, "123foo", "abcdefghijklmnopqrstuvwxyz"
    EXPECT_INT 6, "abcdef", "abcdefabcdef"
    DONE

    FUNC strcspn
    EXPECT_INT 0, "foo123", "abcdefghijklmnopqrstuvwxyz"
    EXPECT_INT 3, "123foo", "abcdefghijklmnopqrstuvwxyz"
    EXPECT_INT 3, "123", "abcdefghijklmnopqrstuvwxyz"
    EXPECT_INT 0, "abcdef", "abcdefabcdef"
    EXPECT_INT 3, "one word", " "
    DONE

    END_TEST
ret

section .data
    strcat_1: db "abc", 0, 0, 0, 0
    strcat_2: db 0, 0, 0, 0
    strcat_3: db 0

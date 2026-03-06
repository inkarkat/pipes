#!/usr/bin/env bats

load fixture

@test "no diff when file is unchanged" {
    run -0 processEachFile --diff --exec "${changeNoneCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output ''
}

@test "show traditional diff when first file is changed" {
    run -0 processEachFile --diff --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<'EOF'
1c1
< FOO
---
> Fi
EOF
}

@test "show unified diff when first file is changed" {
    origDate="$(stat --format=%y "$FILE1")"
    run -0 processEachFile --diff -u --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
--- $FILE1 ${origDate}
+++ $FILE1 $(stat --format=%y "$FILE1")
@@ -1 +1 @@
-FOO
+Fi
EOF
}

@test "show unified diff when first file is changed with backup" {
    origDate="$(stat --format=%y "$FILE1")"
    run -0 processEachFile --backup .bak --delta-via backup --diff -u --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
--- ${FILE1}.bak ${origDate}
+++ $FILE1 $(stat --format=%y "$FILE1")
@@ -1 +1 @@
-FOO
+Fi
EOF
}

@test "show unified diff when first file is changed with passed labels" {
    run -0 processEachFile --diff -u --label 'original' --label 'modified' --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_output - <<EOF
--- original
+++ modified
@@ -1 +1 @@
-FOO
+Fi
EOF
}

@test "show unified diff when both files are changed" {
    run -0 processEachFile --diff -u --exec "${changeAllCommand[@]}" \; "$FILE1" "$FILE2"
    assert_line -n -8 "@@ -1 +1 @@"
    assert_line -n -7 "-FOO"
    assert_line -n -6 "+Fi"
    assert_line -n -3 "@@ -1 +1 @@"
    assert_line -n -2 "-fox"
    assert_line -n -1 "+fix"
}

@test "show messages and unified diff when first file is changed" {
    run -0 processEachFile --message-subject SUBJECT --diff -u --exec "${changeFirstCommand[@]}" \; "$FILE1" "$FILE2"
    assert_line -n -5 "@@ -1 +1 @@"
    assert_line -n -4 "-FOO"
    assert_line -n -3 "+Fi"
    assert_line -n -2 "SUBJECT changed $FILE1"
    assert_line -n -1 "Successfully performed SUBJECT on $FILE2 without changing it"
}

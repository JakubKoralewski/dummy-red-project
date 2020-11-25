Red []
#include %login.red

new-test-case: function [
    "Creates a test case"
    input-text [string!]
    success-val [logic!]
    text-val [string!]
] [
    comment {
        Using object data structure
    }
    return object [
        input: input-text
        success: success-val
        text: text-val
    ]
]
comment {
    Using a list ("block" in Red)
}
test-cases: reduce [
    new-test-case rejoin append/dup [] "." 7 false password-result/too-short
    new-test-case rejoin append/dup [] "." 21 false password-result/too-long
    new-test-case "x.xxxxxxxxx" false password-result/no-uppercase
    new-test-case "XX.XXXXXXXX" false password-result/no-lowercase
    new-test-case "111.A1111111111" false password-result/no-lowercase
    new-test-case "111.1111111111" false password-result/no-letters
    new-test-case "xxxxxxxxxxxxD" false password-result/no-special
    new-test-case "xxxxxxxxxxxxD." true password-result/success 
]
num-failed: 0
num-passed: 0
num-tests: length? test-cases
foreach test-case test-cases [
    ; run function to test
    rv: is-valid-password test-case/input

    rv-bool: first rv
    rv-text: second rv
    test-success: true
    print-fail: function [test-case message] [
        print rejoin ["❌ Test case """  test-case/input """ failed. " message]
    ]
    if rv-bool <> test-case/success [
        print-fail test-case "Incorrect bool return."
        test-success: false
    ]
    if rv-text <> test-case/text [
        print-fail test-case "Incorrect text return."
        test-success: false
    ]
    either test-success [
        print rejoin ["✅ Test case " test-case]
        print newline
        num-passed: num-passed + 1
    ] [
        print "Expected test case: "
        probe test-case
        print "Got output: "
        print rejoin ["success: " rv-bool]
        print rejoin ["text: " rv-text]
        print newline
        num-failed: num-failed + 1
    ]
]

print rejoin ["Out of all " num-tests ":"]
print rejoin ["Passed: " num-passed]
if num-failed <> 0 [print rejoin ["Failed: " num-failed]]
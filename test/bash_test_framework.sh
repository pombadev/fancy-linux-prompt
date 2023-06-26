# source this script to make tests with bash

function test_start {
    if [[ -n "$btf_name" ]]
    then
        test_fail "Did not encounter test_end"
        test_end
    fi
    btf_name="$1"
    echo -e "TEST: $btf_name"
    btf_pass=false
    btf_fail=false
    btf_there_were_failures=false
    btf_there_were_passes=false
}

function test_end {
    echo -n "TEST: $btf_name: "
    if $btf_fail
    then 
        echo "FAIL"
        btf_there_were_failures=true
    else
        if $btf_pass
        then
            echo "Pass"
        else
            echo "FAIL"
            btf_there_were_failures=true
        fi
    fi
    btf_name=""
    echo
}

function test_summary {
    echo -n "Summary: "
    if $btf_there_were_failures 
    then
        echo "FAIL: There were failures"
        exit 1
    else    
        if $btf_there_were_passes
        then
            echo "PASS: All OK"
        else
            echo "FAIL: Nothing found"
            exit 1
        fi
    fi
}

function test_info {
    echo "    : $btf_name: $@"
}

function test_pass {
    echo "Pass: $btf_name: $@"
    btf_pass=true
    btf_there_were_passes=true

}
function test_fail {
    echo "FAIL: $btf_name: $@"
    btf_fail=true
    btf_there_were_failures=true
}

# test_direcs=("Testcase1" "Testcase2" "Testcase3" "Testcase4")
test_direcs=("Testcase4")

for ((i=0; i<${#test_direcs[@]}; i++)); do
    echo "Directory ${test_direcs[i]}" >&2
    file_count=$(find "${test_direcs[i]}" -type f | wc -l)
    echo "Found $file_count files" >&2
    test_count=$(($file_count/2))
    echo "Running $test_count comparison" >&2

    outputDir="./${test_direcs[i]}Diff"

    echo "" >&2

    did_we_pass=1
    is_there_diff=0
    for ((j=1; j<=test_count; j++)); do
        target1="./${test_direcs[i]}/Version$j.1.txt"
        target2="./${test_direcs[i]}/Version$j.2.txt"
        output="${outputDir}/Version${j}Diff.txt"
        echo "Target1: ${target1}" >&2
        echo "Target2: ${target2}" >&2

        if cmp -s "$target1" "$target2"; then
            echo "No Diff" >&2
        else
            echo "Diff found, Output: ${output}" >&2
            result=$(diff -u ${target1} ${target2})
            echo $result > "./tmp.txt"

            # Diff fount, check the following:
            # Directory exists
            # Output matches ours
            is_there_diff=1
            if [ -d "$outputDir" ]; then
                if cmp -s "$output" "./tmp.txt"; then
                    echo "Comparison passed" >&2
                else
                    echo "Issue: Output does not match!" >&2
                    did_we_pass=0
                fi
            else
                echo "Issue: Directory $outputDir does not exist!" >&2
                did_we_pass=0
            fi
        fi

        if ((did_we_pass==0)); then
            j=99999999
        fi
    done

    if ((is_there_diff==0 && did_we_pass!=0)); then
        if [ -d "$outputDir" ]; then
            echo "Issue: Directory $outputDir exists when it should not!" >&2
            did_we_pass=0
        fi
    fi

    if ((did_we_pass==0)); then
        echo "${test_direcs[i]}: FAIL"
        exit 1
    else
        echo "${test_direcs[i]}: PASS"
        exit 0
    fi
done

exit 0

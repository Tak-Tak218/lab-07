test_direcs=("Testcase1" "Testcase2" "Testcase3" "Testcase4")
# test_direcs=("Testcase1")

for ((i=0; i<${#test_direcs[@]}; i++)); do
    echo "Directory ${test_direcs[i]}"
    file_count=$(find "${test_direcs[i]}" -type f | wc -l)
    echo "Found $file_count files"
    test_count=$(($file_count/2))
    echo "Running $test_count comparison"

    outputDir="./${test_direcs[i]}Diff"

    if [ -d "$outputDir" ]; then
        echo "Directory $outputDir exists."
        $(rm -rf $outputDir)
    else
        echo "Directory $outputDir does not exist."
    fi
    echo ""

    for ((j=1; j<=test_count; j++)); do
        target1="./${test_direcs[i]}/Version$j.1.txt"
        target2="./${test_direcs[i]}/Version$j.2.txt"
        output="${outputDir}/Version${j}Diff.txt"
        echo "Target1: ${target1}"
        echo "Target2: ${target2}"

        if cmp -s "$target1" "$target2"; then
            echo "No Diff"
        else
            echo "Diff found, Output: ${output}"
            result=$(diff -u ${target1} ${target2})

            $(mkdir $outputDir)
            echo $result > $output
        fi
    done
done

exit 0

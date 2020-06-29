cd jenkins; 

ls -l 

# below is placeholder change when implemented
apikey=8c72d8fb43426aaee5bdeffba5e5efe66bdce62c 

 

if [ -e jenkins/gitCheckScript.sh ] 

then 

 # run in codebase 

 echo "PR CHECKER is running from <enter application name>" 

 jenkins/gitCheckScript.sh -a apikey 

else 

# run locally 

    echo "PR CHECKER script did not exist in <application name> codebase so running from jenkins" 

    latestCommit= 

    lastPrReview= 

    approvedReview="APPROVED" 

    pullNumber=$ghprbPullId 

    authorCache= 

    pageCounter=1 

    acceptanceCounter=0 

    USER=shabariRepo

    APIKEY=$apikey 

    unset prCommits 

    unset prReviews 

 

    echo "***********************************************************************" 

    echo "Checking Git PR for Validity: Need at least 2 Approvals - each one with unique reviewer" 

 

    function usage() { 

        echo " USAGE: \n$0 -x [-h]\nWHERE:\n-x      indicates "run"\n-h      displays the help details" 

    } 

 

    while getopts ":x:h:p" flag ; do 

        case $flag in 

            x)       

                DEBUG="$OPTARG" 

                    ;; 

            h)   

                usage 

                exit 0 

                    ;; 

            p) 

                pullNumber="$OPTARG" 

                    ;; 

        esac 

    done 

    # this main function executes a call to the body function 

    function main() { 

        PullRequestChecker 

    } 

 

    function UpdateReviewsByPage(){ 

        # get all the state tags from PR reviews 

        #prReviews=() IFS=$'\n' && for commit in $(curl -k -u ${USER}:${APIKEY} https://github.corp..com/api/v3/repos/{owner}/{repo}/pulls/${pullNumber}/reviews?page=$1 2>/dev/null | json -ga user.login state submitted_at ); do  
        prReviews=() IFS=$'\n' && for commit in $(curl -k -u ${USER}:${APIKEY} https://api.github.com/repos/compassdigital/pulls/${pullNumber}/reviews?page=$1 2>/dev/null | json -ga user.login state submitted_at ); do  
            prReviews=( ${prReviews[@]} ${commit} );  

        done && IFS='' 

    } 

 

    # main body of work, script with logic there 

    function PullRequestChecker(){ 

        # get all the commits for the PR 

        # declare empty array and End of each element as new line 

        # curl with USERNAME & APIKEY (2>/dev/null : remove progress panel of JSON parsing), pipe to parse as array JSON looking for date 

        prCommits=() IFS=$'\n' && for commit in $(curl -k -u ${USER}:${APIKEY} https://api.github.com/repos/compassdigital/pulls/${pullNumber}/commits 2>/dev/null | json -a commit.author.date); 

                do  

                    prCommits=( ${prCommits[@]} "${commit}" ); 

        done && IFS='' 

        # get the latest commit by date (last element of the array) 

        latestCommit="${prCommits[-1]}" 

 

        # get the first page of the reviews 

        UpdateReviewsByPage $pageCounter; 

 

        # if prReviews is empty then exit 

        if [ -n "$prReviews" ]; then  

            echo "Reviews exist in the PR# $pullNumber, for branch $ghprbSourceBranch.  proceeding to next step."; 

        else  

            echo "There were no reviews found in the PR# $pullNumber, for branch $ghprbSourceBranch."; 

            echo "***********************************************************************"; 

            exit 1;  

        fi 

 

        # get all the pages of the reviews if the pages are large 

        while [ $pageCounter -lt 4 ] 

        do 

            # the acceptanceCounter will increment when the author is NOT the same as the previous author and has accepted 

            #acceptanceCounter=0  

            authorCache= && for element in "${prReviews[@]}" ; do  

                datehere=$(cut -d " " -f 3 <<< "$element")  

                author=$(cut -d " " -f 1 <<< "$element")  

                state=$(cut -d " " -f 2 <<< "$element"); 

                if [[ "$datehere" > $latestCommit ]]; then  

                    if [[ "$state" = "${approvedReview}" && "$author" != "$authorCache" ]]; then  

                        authorCache="$author";  

                        acceptanceCounter=$((acceptanceCounter+1));  

                        echo $acceptanceCounter;   

                        echo "$author has $state the change on -- $datehere";  

                    fi;  

                fi;  

            done; 

             

            if [[ $acceptanceCounter > 1 ]]; then 

                break; 

            else 

                pageCounter=$((pageCounter+1)); 

                UpdateReviewsByPage $pageCounter; 

            fi; 

        done 

 

         

        # basically counter is the number of unique reviews with accepted status 

        # if the counter is > 1 then we're good or (2) 

        if [[ $acceptanceCounter > 1 ]]; then  

            echo "--- There are $acceptanceCounter ACCEPTED Reviews ..change is good to go for $pullNumber, for branch $ghprbSourceBranch!"; 

            echo "***********************************************************************"; 

            exit 0;  

        else  

            echo "--- There are currently, $acceptanceCounter ACCEPTED Reviews. 2 Unique approvals needed for the check to pass.  $pullNumber, for branch $ghprbSourceBranch."; 

            echo "***********************************************************************"; 

            exit 1;  

        fi; 

    } 

    # 

    # call to the function that starts the work 

    # 

    main 

    echo "***********************************************************************" 

fi 
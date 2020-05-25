#!/bin/bash

###### Remove old list of links
rm topPosts.txt
touch topPosts.txt

username="username"
password="password"
publickey=""
secretkey=""
subredditname="pics"

##### Get oauth token
oauth=$(curl -X POST --user-agent "fetchSubredditImages:v0.1 (by )" -d "grant_type=password&username=${username}&password=${password}" --user "${publickey}:${secretkey}" https://www.reddit.com/api/v1/access_token)
accToken=$(echo $oauth | grep -oEi '[^"]{36}')
echo $oauth

##### Get posts from Reddit API
count=0
totalImages=0
after=""
while [ $totalImages -lt 500 ]; do
	len=${#after}
	if [ $len -lt 1 ]; then
		posts=$(curl -H "Authorization: bearer ${accToken}" -A "fetchSubredditImages:v0.1 (by /u/unrestive)" https://oauth.reddit.com/r/${subredditname}/top?t=all&limit=100)
		#echo $posts | python topPosts.py >> topPosts.txt
	else
		count=$((count + 100))
		posts=$(curl -H "Authorization: bearer $accToken" -A "fetchSubredditImages:v0.1 (by /u/unrestive)" "https://oauth.reddit.com/r/${subredditname}/top?count=${count}&after=${after}&t=all&limit=100")
	fi

	echo $posts | python topPosts.py >> topPosts.txt

	totalImages=$(cat topPosts.txt | grep -ic "http")
	after="$(echo $posts | grep -oEi 't3_(.{6})' | awk '{print $1;exit}')"
done

##### Replace gifv with gif in file and fetch images with WGET
##### This method only supports getting images from imgur, tumblr, gfycat and redditmedia
sed -i -e 's/gifv/gif/g' topPosts.txt
wget -nd -r -l1 -P images -H -Dhttp://i.imgur.com/ https://i.imgur.com/ *.redditmedia.com/ *.media.tumblr.com/ https://thumbs.gfycat.com/ -A jpg,gif,png,mp4 -e robots=off --timeout=15 --tries=1 -i topPosts.txt

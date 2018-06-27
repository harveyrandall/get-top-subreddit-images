import sys, json

posts = json.load(sys.stdin)

for post in posts['data']['children']:
	try:
		if post['data']['post_hint'] == "rich:video" or post['data']['post_hint'] == "link" or post['data']['post_hint']:
			url = post['data']['url']
			
			if url.find("://imgur.com") != -1:
				url = url.replace("/imgur", "/i.imgur") + ".jpg"
			if url.find("com/a/") != -1 and url.find("gallery") == -1:
				url = url.replace("a/", "") + ".jpg"
			if url.find("&amp;") != -1:
				url = url.replace("&amp;", "&")
			if url.find("//gfycat") != -1 and url.find(".mp4") == -1:
				url = url.replace("//gfycat", "//thumbs.gfycat")
				url = url + "-mobile.mp4"

			print(url)	
			
	except:
		pass

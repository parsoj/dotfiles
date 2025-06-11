# Objectives

I want to have a script that can identify links passed in on stdin, and properly markdown-format them if a link is detected. 

for now I just want to handle these 3 cases

<pseudo code>
if a link is detected:
	
	if the link seems to be a youtube link: 	
		1.  Take a YouTube URL as input (either as a command line argument or interactively)
		2. Extract the video title using YouTube's oEmbed API (https://www.youtube.com/oembed?url=VIDEO_URL&format=json)
		3. if the result is a success, Output the result as a markdown link in the format: [Video Title](URL)
		

	if the link is not a youtube link, or the oEmbed extraction failed: 

		1.  fall back to parsing the HTML head section for Open Graph or title tags
		2. Output the result as a markdown link in the format: [Video Title](URL)

if a link is not detected:
	- just pass the text through to stdout as normal


</pseudo code>


make sure to Handle errors gracefully with informative messages




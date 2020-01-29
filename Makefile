default: build_image

get_demo:
	svn checkout https://github.com/chrundle/python-SuiteOPT/trunk/Demo

build_image:
	sudo docker build -f Dockerfile \
	--cache-from suiteopt-test:latest \
	-t suiteopt-test:latest \
	--compress .

#-------------------------------------
# Remove Demo
#-------------------------------------

remove_demo:
	- rm -rf Demo
    


default: image

image:
	sudo docker build -f Dockerfile \
	--cache-from suiteopt-test:latest \
	-t suiteopt-test:latest \
	--compress .

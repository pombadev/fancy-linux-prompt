test:
	docker pull ubuntu
	docker build --tag less-fancy-test .
	mkdir -p ../git-status-output
	docker run -ti --mount type=bind,source="$$PWD/../git-status-output",target=/home/lf-user/out less-fancy-test  

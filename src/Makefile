.PHONY: php56 php70 php71 clean push

php56:
	cp php56/_Dockerfile php56/Dockerfile
	cat base/Dockerfile >> php56/Dockerfile
	docker build --no-cache -f php56/Dockerfile -t briefbote/webbuild:56 .

php70:
	cp php70/_Dockerfile php70/Dockerfile
	cat base/Dockerfile >> php70/Dockerfile
	docker build --no-cache -f php70/Dockerfile -t briefbote/webbuild:70 .

php71:
	cp php71/_Dockerfile php71/Dockerfile
	cat base/Dockerfile >> php71/Dockerfile
	docker build --no-cache -f php71/Dockerfile -t briefbote/webbuild:71 -t briefbote/webbuild:latest .

all: php56 php70 php71

push:
	docker push briefbote/webbuild:56
	docker push briefbote/webbuild:70
	docker push briefbote/webbuild:71
	docker push briefbote/webbuild:latest

clean:
	-docker rmi -f briefbote/webbuild:56
	-docker rmi -f briefbote/webbuild:70
	-docker rmi -f briefbote/webbuild:71
	-docker rmi -f briefbote/webbuild:latest

.PHONY: php55 php56 php70 clean push
php55:
	cp php55/_Dockerfile php55/Dockerfile
	cat base/Dockerfile >> php55/Dockerfile
	docker build --no-cache -f php55/Dockerfile -t briefbote/webbuild:55 .
#	docker build -f php55-ruby/Dockerfile -t briefbote/webbuild:55-ruby .

php56:
	cp php56/_Dockerfile php56/Dockerfile
	cat base/Dockerfile >> php56/Dockerfile
	docker build --no-cache -f php56/Dockerfile -t briefbote/webbuild:56 .
#	docker build -f php56-ruby/Dockerfile -t briefbote/webbuild:56-ruby .

php70:
	cp php70/_Dockerfile php70/Dockerfile
	cat base/Dockerfile >> php70/Dockerfile
	docker build --no-cache -f php70/Dockerfile -t briefbote/webbuild:70 -t briefbote/webbuild:latest .
#	docker build -f php70-ruby/Dockerfile -t briefbote/webbuild:70-ruby .

all:	php55 php56 php70

push:
	docker push briefbote/webbuild:55
	docker push briefbote/webbuild:56
	docker push briefbote/webbuild:70
	docker push briefbote/webbuild:latest
#	docker push briefbote/webbuild:55-ruby
#	docker push briefbote/webbuild:56-ruby
#	docker push briefbote/webbuild:70-ruby

clean:
	-docker rmi -f briefbote/webbuild:55
	-docker rmi -f briefbote/webbuild:56
	-docker rmi -f briefbote/webbuild:70
	-docker rmi -f briefbote/webbuild:55-ruby
	-docker rmi -f briefbote/webbuild:56-ruby
	-docker rmi -f briefbote/webbuild:70-ruby
	-docker rmi -f briefbote/webbuild:latest

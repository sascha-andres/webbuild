.PHONY: php55
php55:
	docker build --no-cache -f php55/Dockerfile -t briefbote/webbuild:55 .
	docker push briefbote/webbuild:55

.PHONY: php56
php56:
	docker build --no-cache -f php56/Dockerfile -t briefbote/webbuild:56 .
	docker push briefbote/webbuild:56

.PHONY: php70
php70:
	docker build --no-cache -f php70/Dockerfile -t briefbote/webbuild:70 -t briefbote/webbuild:latest .
	docker push briefbote/webbuild:70
	docker push briefbote/webbuild:latest

.PHONY: clean
clean:
	-docker rmi -f briefbote/webbuild:55
	-docker rmi -f briefbote/webbuild:56
	-docker rmi -f briefbote/webbuild:70
	-docker rmi -f briefbote/webbuild:latest

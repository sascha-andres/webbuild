.PHONY: php56 php70 php71 php72 clean push

NAMESPACE ?= briefbote

php56:
	cp php56/_Dockerfile php56/Dockerfile
	cat base/Dockerfile >> php56/Dockerfile
	docker build --no-cache -f php56/Dockerfile -t $(NAMESPACE)/webbuild:56 .

php70:
	cp php70/_Dockerfile php70/Dockerfile
	cat base/Dockerfile >> php70/Dockerfile
	docker build --no-cache -f php70/Dockerfile -t $(NAMESPACE)/webbuild:70 .

php71:
	cp php71/_Dockerfile php71/Dockerfile
	cat base/Dockerfile >> php71/Dockerfile
	docker build --no-cache -f php71/Dockerfile -t $(NAMESPACE)/webbuild:71 .

php72:
	cp php72/_Dockerfile php72/Dockerfile
	cat base/Dockerfile >> php72/Dockerfile
	docker build --no-cache -f php72/Dockerfile -t $(NAMESPACE)/webbuild:72 -t $(NAMESPACE)/webbuild:latest .

all: php56 php70 php71 php72

push:
	docker push $(NAMESPACE)/webbuild:56
	docker push $(NAMESPACE)/webbuild:70
	docker push $(NAMESPACE)/webbuild:71
	docker push $(NAMESPACE)/webbuild:72
	docker push $(NAMESPACE)/webbuild:latest

clean:
	-docker rmi -f $(NAMESPACE)/webbuild:56
	-docker rmi -f $(NAMESPACE)/webbuild:70
	-docker rmi -f $(NAMESPACE)/webbuild:71
	-docker rmi -f $(NAMESPACE)/webbuild:72
	-docker rmi -f $(NAMESPACE)/webbuild:latest

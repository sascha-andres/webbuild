.PHONY: php56 php70 php71 clean push

php56:
	cd src && make php56

php70:
	cd src && make php70

php71:
	cd src && make php71

php72:
	cd src && make php72

all: php56 php70 php71 php72

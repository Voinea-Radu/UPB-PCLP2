
all: build

build:
	cd src && make

clean:
	cd src && make clean
	rm -rf functional

pack:
	zip -FSr 315CA_VoineaRadu_TEMA1.zip README Makefile src/

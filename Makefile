SOURCES=vistecture.go
VERSION=2.0.5

.PHONY: all templates darwin linux windows default

default: darwin

all: darwin linux windows

templates:
	packr2
	echo "package web \n import _ \"github.com/intercloud/vistecture/packrd\"" > controller/web/web-packr.go
	mkdir -p build-artifacts
	zip -qr build-artifacts/templates.zip templates

darwin: $(SOURCES) templates
	GOOS=darwin go build -o build-artifacts/vistecture $(SOURCES)

linux: $(SOURCES) templates
	GOOS=linux go build -o build-artifacts/vistecture-linux $(SOURCES)

windows: $(SOURCES) templates
	GOOS=windows go build -o build-artifacts/vistecture.exe $(SOURCES)

dockerpublish:
	docker build --no-cache -t intercloud/vistecture .
	docker tag intercloud/vistecture:latest intercloud/vistecture:$(VERSION)
	docker push intercloud/vistecture:latest
	docker push intercloud/vistecture:$(VERSION)

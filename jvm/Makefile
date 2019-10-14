JAVAS = $(wildcard *.java)
CLASSES = $(JAVAS:.java=.class)

USERID = $(shell id -u)

all: $(CLASSES)

%.class: %.java
	docker-compose run --rm -u $(USERID) jdk javac $^

clean:
	rm -f *.class

.PHONY: all clean

JAVAC=javac
JPL_JAR?=$(firstword $(wildcard /opt/homebrew/Cellar/swi-prolog/*/libexec/lib/swipl/lib/jpl.jar /usr/local/Cellar/swi-prolog/*/libexec/lib/swipl/lib/jpl.jar))

.PHONY: all check-jpl java run clean

all: java

check-jpl:
	@test -n "$(JPL_JAR)" || (echo "Erro: indique o caminho do jpl.jar com make JPL_JAR=/caminho/para/jpl.jar" && exit 1)

java: check-jpl
	mkdir -p java/bin
	$(JAVAC) -encoding UTF-8 -cp "$(JPL_JAR)" -d java/bin java/src/*.java

run: java
	java -cp "java/bin:$(JPL_JAR)" Aplicacao

clean:
	rm -rf java/bin boletins

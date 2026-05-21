JAVAC=javac
JAVA=java
JPL_JAR?=$(firstword $(wildcard /usr/share/java/jpl.jar /usr/lib/swi-prolog/lib/jpl.jar /opt/homebrew/Cellar/swi-prolog/*/libexec/lib/swipl/lib/jpl.jar /usr/local/Cellar/swi-prolog/*/libexec/lib/swipl/lib/jpl.jar))
SWIPL_LIB?=/usr/lib/swi-prolog/lib/x86_64-linux

.PHONY: all check-jpl java run clean

all: java

check-jpl:
	@test -n "$(JPL_JAR)" || (echo "Erro: indique o caminho do jpl.jar com make JPL_JAR=/caminho/para/jpl.jar" && exit 1)

java: check-jpl
	mkdir -p java/bin
	$(JAVAC) -encoding UTF-8 -cp "$(JPL_JAR)" -d java/bin java/src/*.java

run: java
	LD_LIBRARY_PATH="$(SWIPL_LIB):$$LD_LIBRARY_PATH" $(JAVA) -Djava.library.path="$(SWIPL_LIB)" -cp "java/bin:$(JPL_JAR)" Aplicacao

clean:
	rm -rf java/bin bin boletins

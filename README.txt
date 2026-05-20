e-Folio B - Linguagens de Programacao
=====================================

Objetivo
--------
Aplicacao Java integrada com uma base de conhecimento Prolog atraves da biblioteca JPL7.
A logica de consulta, inferencia, gestao dinamica e persistencia esta em Prolog.
O Java apresenta menus, recolhe dados do utilizador e invoca os predicados Prolog.

Estrutura
---------
base_conhecimento.pl      Factos persistentes da base de conhecimento.
prolog/regras.pl          Regras Prolog, consultas, listagens e operacoes de gestao.
java/src/Aplicacao.java   Ponto de entrada da aplicacao.
java/src/Menu.java        Menu interativo.
java/src/IntegradorProlog.java  Integracao com Prolog via JPL7.
relatorio/relatorio.md    Relatorio base do trabalho.

Requisitos
----------
- Java JDK.
- SWI-Prolog com JPL7 instalado.
- O ficheiro jpl.jar deve estar disponivel no classpath.
- A biblioteca nativa do SWI-Prolog deve estar visivel para o Java, se a instalacao exigir
  configuracao de `java.library.path`, `LD_LIBRARY_PATH` ou `DYLD_LIBRARY_PATH`.

Em algumas instalacoes macOS via Homebrew, o JPL pode estar em:
   /usr/local/Cellar/swi-prolog/<versao>/libexec/lib/swipl/lib/jpl.jar

ou em Apple Silicon:
   /opt/homebrew/Cellar/swi-prolog/<versao>/libexec/lib/swipl/lib/jpl.jar

Compilacao
----------
Indique o caminho correto para o jpl.jar:

   make JPL_JAR=/caminho/para/jpl.jar

Tambem pode compilar manualmente:

   mkdir -p java/bin
   javac -encoding UTF-8 -cp "/caminho/para/jpl.jar" -d java/bin java/src/*.java

Execucao
--------
Execute a aplicacao com o jpl.jar no classpath:

   java -cp "java/bin:/caminho/para/jpl.jar" Aplicacao

Opcionalmente pode indicar outro ficheiro de base:

   java -cp "java/bin:/caminho/para/jpl.jar" Aplicacao /caminho/para/base_conhecimento.pl

Teste Prolog isolado
--------------------
Antes de testar a interface Java, pode validar a logica diretamente no SWI-Prolog:

   swipl

Depois, dentro do interpretador:

   consult('base_conhecimento.pl').
   listar_em_risco(L).
   listar_participativos(L).
   listar_bons(L).
   listar_acima_media(L).
   media_turma(M).
   dados_aluno(1, Nome, Participacoes, Media, Estado).

As listagens obrigatorias devolvem IDs sem duplicados. A interface Java usa predicados
detalhados adicionais para apresentar tambem nome, participacoes, media e estado.

Funcionalidades
---------------
1. Listar alunos em risco.
2. Listar alunos participativos.
3. Listar alunos com bom desempenho.
4. Listar alunos acima da media da turma.
5. Consultar aluno por ID.
6. Adicionar aluno.
7. Atualizar media de aluno.
8. Atualizar participacao no forum.
9. Remover aluno da base de conhecimento.
10. Bonus: listar alunos em observacao.
11. Mostrar media da turma.

Notas
-----
As operacoes de adicionar, atualizar e remover persistem os factos no ficheiro
base_conhecimento.pl. A base Prolog e a unica fonte de verdade da aplicacao.

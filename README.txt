e-Folio B - Linguagens de Programacao
=====================================

Objetivo
--------
Este projeto implementa uma aplicacao Java integrada com uma base de conhecimento
Prolog atraves da biblioteca JPL7.

A logica principal do sistema fica em Prolog: consultas, inferencia, listagens,
gestao dinamica dos alunos e persistencia da base de conhecimento. O Java fica
responsavel pela interface de consola, pela recolha dos dados introduzidos pelo
utilizador e pela chamada dos predicados Prolog.

O trabalho parte dos resultados do e-Folio A, mas reorganiza a solucao para o
modelo pedido no e-Folio B: Prolog como fonte principal da logica e Java como
camada de interacao.

Estrutura
---------
A estrutura atual do projeto e a seguinte:

   prolog/sistema.pl              Ficheiro principal de carregamento do sistema Prolog.
   prolog/base_conhecimento.pl    Factos persistentes da base de conhecimento.
   prolog/regras.pl               Regras Prolog, consultas, listagens e operacoes de gestao.
   java/src/Aplicacao.java        Ponto de entrada da aplicacao Java.
   java/src/Menu.java             Menu interativo e submenus.
   java/src/IntegradorProlog.java Integracao com Prolog atraves de JPL7.
   java/bin/                      Pasta gerada na compilacao Java.
   relatorio/                     Pasta destinada ao relatorio do trabalho.
   Makefile                       Comandos de compilacao e execucao.
   README.txt                     Este ficheiro.

O ficheiro mais importante para iniciar o Prolog e:

   prolog/sistema.pl

Este ficheiro carrega a base de conhecimento e as regras, evitando a confusao de
carregar apenas os factos ou apenas os predicados.

Requisitos
----------
- Java JDK.
- SWI-Prolog.
- Biblioteca JPL7.
- Ficheiro jpl.jar disponivel no classpath.
- Biblioteca nativa do SWI-Prolog visivel para o Java.

Em Linux/Codespaces, pode ser necessario instalar:

   sudo apt update
   sudo apt install swi-prolog swi-prolog-java -y

Para localizar o jpl.jar:

   find /usr -name jpl.jar 2>/dev/null

Em algumas instalacoes Linux, o caminho pode ser:

   /usr/share/java/jpl.jar

Em macOS via Homebrew, pode estar em:

   /usr/local/Cellar/swi-prolog/<versao>/libexec/lib/swipl/lib/jpl.jar

ou, em Apple Silicon:

   /opt/homebrew/Cellar/swi-prolog/<versao>/libexec/lib/swipl/lib/jpl.jar

Compilacao
----------
A forma recomendada e usar o Makefile:

   make clean
   make

Se o Makefile nao encontrar automaticamente o jpl.jar, indicar o caminho:

   JPL_JAR=$(find /usr -name jpl.jar 2>/dev/null | head -n 1)
   make clean
   make JPL_JAR="$JPL_JAR"

Tambem e possivel compilar manualmente:

   JPL_JAR=$(find /usr -name jpl.jar 2>/dev/null | head -n 1)
   mkdir -p java/bin
   javac -encoding UTF-8 -cp "$JPL_JAR" -d java/bin java/src/*.java

Execucao
--------
Usando o Makefile:

   make run

Ou, indicando explicitamente o jpl.jar:

   JPL_JAR=$(find /usr -name jpl.jar 2>/dev/null | head -n 1)
   make run JPL_JAR="$JPL_JAR"

Execucao manual em Linux/Codespaces:

   JPL_JAR=$(find /usr -name jpl.jar 2>/dev/null | head -n 1)
   export LD_LIBRARY_PATH=/usr/lib/swi-prolog/lib/x86_64-linux:$LD_LIBRARY_PATH
   java -Djava.library.path=/usr/lib/swi-prolog/lib/x86_64-linux -cp "java/bin:$JPL_JAR" Aplicacao

Por defeito, a aplicacao Java carrega:

   prolog/sistema.pl

Se for necessario, pode ser passado outro ficheiro Prolog como argumento:

   java -cp "java/bin:$JPL_JAR" Aplicacao prolog/sistema.pl

Teste Prolog isolado
--------------------
Antes de testar a interface Java, pode validar a logica diretamente no SWI-Prolog.
Na raiz do projeto:

   swipl

Dentro do interpretador:

   consult('prolog/sistema.pl').

Depois podem ser testados os predicados principais:

   listar_em_risco(L).
   listar_participativos(L).
   listar_bons(L).
   listar_acima_media(L).
   listar_em_observacao(L).
   media_turma(M).
   dados_aluno(1, Nome, Participacoes, Media, Estado).

Tambem podem ser testadas consultas individuais:

   em_risco(2).
   participativo(1).
   bom_desempenho(3).
   acima_media(3).

Para sair do SWI-Prolog:

   halt.

Funcionalidades da aplicacao Java
---------------------------------
O menu principal esta organizado por grupos funcionais:

1. Listar alunos.
2. Consultar aluno por ID.
3. Adicionar aluno.
4. Atualizar dados de aluno.
5. Remover aluno da base de conhecimento.
6. Mostrar media da turma.
0. Sair.

A opcao "Listar alunos" abre um submenu com:

1. Alunos em risco.
2. Alunos participativos.
3. Alunos com bom desempenho.
4. Alunos acima da media da turma.
5. Bonus: alunos em observacao.
0. Voltar ao menu principal.

A opcao "Atualizar dados de aluno" abre outro submenu com:

1. Atualizar media.
2. Atualizar participacao no forum.
0. Voltar ao menu principal.

Persistencia
------------
As operacoes de adicionar, atualizar e remover alunos sao feitas em Prolog.
Depois de cada uma dessas operacoes, os factos sao regravados no ficheiro:

   prolog/base_conhecimento.pl

A separacao entre ficheiros ficou assim:

- prolog/base_conhecimento.pl guarda os factos persistentes;
- prolog/regras.pl guarda a logica e os predicados;
- prolog/sistema.pl carrega tudo e serve como ponto unico de entrada.

Esta organizacao evita que as regras sejam apagadas quando a base de conhecimento
e atualizada durante a execucao.

Notas de teste
--------------
Para testar a persistencia, pode ser usado um aluno temporario:

1. Adicionar aluno com ID 99 e nome "Teste Aluno".
2. Consultar o aluno 99.
3. Atualizar a media do aluno 99 para 15.
4. Atualizar a participacao do aluno 99 para 4.
5. Consultar novamente o aluno 99.
6. Remover o aluno 99.
7. Confirmar que o aluno 99 ja nao existe.

No final, e recomendado confirmar o estado do repositorio:

   git status

Idealmente, deve aparecer que nao ha alteracoes pendentes.

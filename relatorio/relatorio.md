# Relatorio - e-Folio B

## Objetivo

Este trabalho evolui o sistema do e-Folio A para uma solucao baseada em Prolog e Java. A base
de conhecimento Prolog representa os resultados ja processados dos alunos, incluindo media,
participacao no forum e estado final. A aplicacao Java funciona como interface com o utilizador
e invoca os predicados Prolog atraves da biblioteca JPL7.

## Organizacao da solucao

- `base_conhecimento.pl`: contem os factos persistentes da aplicacao.
- `prolog/regras.pl`: contem os predicados de inferencia, listagem, gestao dinamica e persistencia.
- `java/src/Aplicacao.java`: ponto de entrada da aplicacao.
- `java/src/Menu.java`: apresenta o menu e recolhe dados do utilizador.
- `java/src/IntegradorProlog.java`: encapsula a comunicacao com Prolog via JPL7.

Esta organizacao separa a logica da interface. O Prolog decide os resultados e gere os factos;
o Java apenas controla o fluxo de interacao.

## Predicados implementados

Foram implementadas as consultas basicas:

- `em_risco(X)`: verdadeiro quando o aluno tem media inferior a 10 ou menos de 3 participacoes.
- `participativo(X)`: verdadeiro quando o aluno tem pelo menos 3 participacoes no forum.
- `bom_desempenho(X)`: verdadeiro quando o aluno tem media maior ou igual a 10.

Para a inferencia baseada na turma, o predicado `media_turma(M)` calcula dinamicamente a media
aritmetica dos factos `media/2`. O predicado `acima_media(X)` compara a media individual com
esse valor calculado.

As listagens usam `findall/3`:

- `listar_em_risco(L)`
- `listar_participativos(L)`
- `listar_bons(L)`
- `listar_acima_media(L)`

## Gestao dinamica

A base declara como dinamicos os predicados `aluno/2`, `forum/2`, `tarefa/2`, `quiz/2`,
`media/2` e `estado/2`. Foram implementadas operacoes para adicionar aluno, atualizar media,
atualizar participacao e remover todos os factos associados a um aluno.

Sempre que uma operacao altera a base, o predicado `guardar_base/0` reescreve
`base_conhecimento.pl`, mantendo a persistencia dos factos.

## Integracao Java-Prolog

A classe `IntegradorProlog` carrega `base_conhecimento.pl` com `consult/1` e executa consultas
atraves de objetos `Query` da biblioteca JPL7. O menu Java disponibiliza todas as funcionalidades
pedidas no enunciado:

1. Listar alunos em risco.
2. Listar alunos participativos.
3. Listar alunos com bom desempenho.
4. Listar alunos acima da media da turma.
5. Consultar aluno por ID.
6. Adicionar aluno.
7. Atualizar media de aluno.
8. Atualizar participacao de aluno.
9. Remover aluno.
10. Executar a funcionalidade bonus.

## Bonus

Foi implementado `em_observacao(X)`, que identifica alunos com media positiva mas participacao
insuficiente. A funcionalidade tambem esta disponivel no menu Java atraves da opcao de listagem
de alunos em observacao.

## Testes propostos

Consultas Prolog a testar no SWI-Prolog:

```prolog
consult('base_conhecimento.pl').
listar_em_risco(L).
listar_participativos(L).
listar_bons(L).
media_turma(M).
listar_acima_media(L).
dados_aluno(1, Nome, Forum, Media, Estado).
```

Fluxos Java a testar:

- Abrir o menu e executar as quatro listagens principais.
- Consultar um aluno existente e um aluno inexistente.
- Adicionar um aluno novo e confirmar que aparece em `base_conhecimento.pl`.
- Atualizar a media e a participacao e verificar que nao ficam factos duplicados.
- Remover um aluno e confirmar que todos os seus factos associados desaparecem.

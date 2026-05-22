% Regras de inferencia e gestao dinamica do e-Folio B.

:- dynamic ficheiro_base/1.

ficheiro_base('base_conhecimento.pl').

set_ficheiro_base(Caminho) :-
    retractall(ficheiro_base(_)),
    assertz(ficheiro_base(Caminho)).

em_risco(Id) :-
    aluno(Id, _),
    (
        media(Id, Media),
        Media < 10
    ;
        forum(Id, Participacoes),
        Participacoes < 3
    ).

participativo(Id) :-
    aluno(Id, _),
    forum(Id, Participacoes),
    Participacoes >= 3.

bom_desempenho(Id) :-
    aluno(Id, _),
    media(Id, Media),
    Media >= 10.

media_turma(MediaTurma) :-
    findall(Media, media(_, Media), Medias),
    Medias \= [],
    sum_list(Medias, Soma),
    length(Medias, Quantidade),
    MediaTurma is Soma / Quantidade.

acima_media(Id) :-
    aluno(Id, _),
    media(Id, Media),
    media_turma(MediaTurma),
    Media >= MediaTurma.

listar_em_risco(Lista) :-
    findall(Id, em_risco(Id), Resultado),
    sort(Resultado, Lista).

listar_participativos(Lista) :-
    findall(Id, participativo(Id), Resultado),
    sort(Resultado, Lista).

listar_bons(Lista) :-
    findall(Id, bom_desempenho(Id), Resultado),
    sort(Resultado, Lista).

listar_acima_media(Lista) :-
    findall(Id, acima_media(Id), Resultado),
    sort(Resultado, Lista).

aluno_resumo(Id, aluno(Id, Nome, Participacoes, Media, Estado)) :-
    dados_aluno(Id, Nome, Participacoes, Media, Estado).

detalhar_alunos(Ids, Detalhes) :-
    maplist(aluno_resumo, Ids, Detalhes).

listar_em_risco_detalhado(Detalhes) :-
    listar_em_risco(Ids),
    detalhar_alunos(Ids, Detalhes).

listar_participativos_detalhado(Detalhes) :-
    listar_participativos(Ids),
    detalhar_alunos(Ids, Detalhes).

listar_bons_detalhado(Detalhes) :-
    listar_bons(Ids),
    detalhar_alunos(Ids, Detalhes).

listar_acima_media_detalhado(Detalhes) :-
    listar_acima_media(Ids),
    detalhar_alunos(Ids, Detalhes).

dados_aluno(Id, Nome, Participacoes, Media, Estado) :-
    aluno(Id, Nome),
    valor_forum(Id, Participacoes),
    valor_media(Id, Media),
    valor_estado(Id, Estado).

valor_forum(Id, Participacoes) :-
    forum(Id, Participacoes), !.
valor_forum(_, 0).

valor_media(Id, Media) :-
    media(Id, Media), !.
valor_media(_, 0).

valor_estado(Id, Estado) :-
    estado(Id, Estado), !.
valor_estado(_, sem_estado).

adicionar_aluno(Id, Nome) :-
    integer(Id),
    Id > 0,
    atom(Nome),
    \+ aluno(Id, _),
    assertz(aluno(Id, Nome)),
    assertz(forum(Id, 0)),
    assertz(media(Id, 0.0)),
    assertz(estado(Id, em_risco)),
    guardar_base.

atualizar_media(Id, NovaMedia) :-
    aluno(Id, _),
    number(NovaMedia),
    NovaMedia >= 0,
    NovaMedia =< 20,
    retractall(media(Id, _)),
    assertz(media(Id, NovaMedia)),
    atualizar_estado(Id),
    guardar_base.

atualizar_participacao(Id, Participacoes) :-
    aluno(Id, _),
    integer(Participacoes),
    Participacoes >= 0,
    retractall(forum(Id, _)),
    assertz(forum(Id, Participacoes)),
    atualizar_estado(Id),
    guardar_base.

remover_aluno(Id) :-
    aluno(Id, _),
    retractall(aluno(Id, _)),
    retractall(forum(Id, _)),
    retractall(tarefa(Id, _)),
    retractall(quiz(Id, _)),
    retractall(media(Id, _)),
    retractall(estado(Id, _)),
    guardar_base.

atualizar_estado(Id) :-
    retractall(estado(Id, _)),
    (
        em_risco(Id)
    ->  assertz(estado(Id, em_risco))
    ;   assertz(estado(Id, aprovado))
    ).

% Bonus: identifica alunos com media positiva, mas participacao insuficiente.
em_observacao(Id) :-
    aluno(Id, _),
    media(Id, Media),
    forum(Id, Participacoes),
    Media >= 10,
    Participacoes < 3.

listar_em_observacao(Lista) :-
    findall(Id, em_observacao(Id), Resultado),
    sort(Resultado, Lista).

listar_em_observacao_detalhado(Detalhes) :-
    listar_em_observacao(Ids),
    detalhar_alunos(Ids, Detalhes).

guardar_base :-
    ficheiro_base(Caminho),
    open(Caminho, write, Stream),
    escrever_cabecalho(Stream),
    escrever_factos(Stream, aluno/2),
    escrever_factos(Stream, forum/2),
    escrever_factos(Stream, tarefa/2),
    escrever_factos(Stream, quiz/2),
    escrever_factos(Stream, media/2),
    escrever_factos(Stream, estado/2),
    close(Stream).

escrever_cabecalho(Stream) :-
    write(Stream, '% BASE DE CONHECIMENTO - E-FOLIO B'), nl(Stream), nl(Stream),
    forall(
        member(Predicado, [aluno/2, forum/2, tarefa/2, quiz/2, media/2, estado/2]),
        (write(Stream, ':- dynamic '), write(Stream, Predicado), write(Stream, '.'), nl(Stream))
    ),
    nl(Stream).

escrever_factos(Stream, Predicado/Aridade) :-
    functor(Clausula, Predicado, Aridade),
    forall(clause(Clausula, true), portray_clause(Stream, Clausula)),
    nl(Stream).

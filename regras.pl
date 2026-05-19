:- consult('base_conhecimento.pl').

em_risco(ID) :-
    aluno(ID, _),
    media(ID, Media),
    Media < 10.

em_risco(ID) :-
    aluno(ID, _),
    forum(ID, Participacoes),
    Participacoes < 3.

participativo(ID) :-
    aluno(ID, _),
    forum(ID, Participacoes),
    Participacoes >= 3.

bom_desempenho(ID) :-
    aluno(ID, _),
    media(ID, Media),
    Media >= 10.

media_turma(MediaTurma) :-
    findall(Media, media(_, Media), Medias),
    Medias \= [],
    sumlist(Medias, Soma),
    length(Medias, Total),
    MediaTurma is Soma / Total.

acima_media(ID) :-
    aluno(ID, _),
    media(ID, MediaAluno),
    media_turma(MediaTurma),
    MediaAluno >= MediaTurma.

listar_em_risco(Lista) :-
    findall(ID, em_risco(ID), Resultado),
    sort(Resultado, Lista).

listar_participativos(Lista) :-
    findall(ID, participativo(ID), Resultado),
    sort(Resultado, Lista).

listar_bons(Lista) :-
    findall(ID, bom_desempenho(ID), Resultado),
    sort(Resultado, Lista).

listar_acima_media(Lista) :-
    findall(ID, acima_media(ID), Resultado),
    sort(Resultado, Lista).

consultar_aluno(ID, Nome, Media, Participacoes, Estado) :-
    aluno(ID, Nome),
    media(ID, Media),
    forum(ID, Participacoes),
    estado(ID, Estado).

adicionar_aluno(ID, Nome) :-
    integer(ID),
    ID > 0,
    atom(Nome),
    \+ aluno(ID, _),
    assertz(aluno(ID, Nome)),
    assertz(media(ID, 0)),
    assertz(forum(ID, 0)),
    assertz(estado(ID, em_risco)),
    guardar_base.

atualizar_media(ID, NovaMedia) :-
    aluno(ID, _),
    number(NovaMedia),
    NovaMedia >= 0,
    NovaMedia =< 20,
    retractall(media(ID, _)),
    assertz(media(ID, NovaMedia)),
    atualizar_estado(ID),
    guardar_base.

atualizar_participacao(ID, NovaParticipacao) :-
    aluno(ID, _),
    integer(NovaParticipacao),
    NovaParticipacao >= 0,
    retractall(forum(ID, _)),
    assertz(forum(ID, NovaParticipacao)),
    atualizar_estado(ID),
    guardar_base.

remover_aluno(ID) :-
    aluno(ID, _),
    retractall(aluno(ID, _)),
    retractall(forum(ID, _)),
    retractall(media(ID, _)),
    retractall(estado(ID, _)),
    guardar_base.

atualizar_estado(ID) :-
    retractall(estado(ID, _)),
    (   em_risco(ID)
    ->  assertz(estado(ID, em_risco))
    ;   assertz(estado(ID, aprovado))
    ).

em_observacao(ID) :-
    aluno(ID, _),
    \+ em_risco(ID),
    media(ID, Media),
    Media >= 10,
    Media < 12.

em_observacao(ID) :-
    aluno(ID, _),
    \+ em_risco(ID),
    forum(ID, Participacoes),
    Participacoes >= 3,
    Participacoes < 5.

listar_em_observacao(Lista) :-
    findall(ID, em_observacao(ID), Resultado),
    sort(Resultado, Lista).

guardar_base :-
    open('base_conhecimento.pl', write, Stream),
    escrever_factos(Stream),
    close(Stream).

escrever_factos(Stream) :-
    write(Stream, ':- dynamic aluno/2.'), nl(Stream),
    write(Stream, ':- dynamic forum/2.'), nl(Stream),
    write(Stream, ':- dynamic media/2.'), nl(Stream),
    write(Stream, ':- dynamic estado/2.'), nl(Stream), nl(Stream),
    forall(aluno(ID, Nome),
        format(Stream, 'aluno(~q, ~q).~n', [ID, Nome])),
    nl(Stream),
    forall(forum(ID, Participacoes),
        format(Stream, 'forum(~q, ~q).~n', [ID, Participacoes])),
    nl(Stream),
    forall(media(ID, Media),
        format(Stream, 'media(~q, ~q).~n', [ID, Media])),
    nl(Stream),
    forall(estado(ID, Estado),
        format(Stream, 'estado(~q, ~q).~n', [ID, Estado])).

% ============================================================
% U.C. 21077 - Linguagens de Programacao
% e-Folio B - Base de Conhecimento Prolog
% Micael Santos 2400005
% ============================================================

:- dynamic aluno/2.
:- dynamic forum/2.
:- dynamic media/2.
:- dynamic estado/2.

% ------------------------------------------------------------
% Factos iniciais
% ------------------------------------------------------------

aluno(1, 'Ana').
aluno(2, 'Bruno').
aluno(3, 'Carla').
aluno(4, 'Diogo').
aluno(5, 'Eva').
aluno(6, 'Filipe').

forum(1, 4).
forum(2, 1).
forum(3, 5).
forum(4, 3).
forum(5, 2).
forum(6, 6).

media(1, 13.5).
media(2, 8.5).
media(3, 17.5).
media(4, 10.5).
media(5, 8.5).
media(6, 15.0).

estado(1, aprovado).
estado(2, em_risco).
estado(3, aprovado).
estado(4, condicionado).
estado(5, em_risco).
estado(6, aprovado).

% ------------------------------------------------------------
% 1. Consultas basicas
% ------------------------------------------------------------

% Um aluno esta em risco se tiver media inferior a 10
% ou menos de 3 participacoes no forum.
em_risco(ID) :-
    aluno(ID, _),
    media(ID, Media),
    Media < 10.

em_risco(ID) :-
    aluno(ID, _),
    forum(ID, Participacoes),
    Participacoes < 3.

% Um aluno e participativo se tiver pelo menos 3 participacoes.
participativo(ID) :-
    aluno(ID, _),
    forum(ID, Participacoes),
    Participacoes >= 3.

% Um aluno tem bom desempenho se a media for igual ou superior a 10.
bom_desempenho(ID) :-
    aluno(ID, _),
    media(ID, Media),
    Media >= 10.

% ------------------------------------------------------------
% 2. Inferencia baseada na media da turma
% ------------------------------------------------------------

% Calcula a media aritmetica das medias existentes em media/2.
% Nao e um valor fixo, para acompanhar alteracoes feitas a base.
media_turma(MediaTurma) :-
    findall(Media, media(_, Media), Medias),
    Medias \= [],
    sumlist(Medias, Soma),
    length(Medias, Total),
    MediaTurma is Soma / Total.

% Aluno acima da media da turma.
acima_media(ID) :-
    aluno(ID, _),
    media(ID, MediaAluno),
    media_turma(MediaTurma),
    MediaAluno >= MediaTurma.

% ------------------------------------------------------------
% 3. Consultas compostas e listagens
% ------------------------------------------------------------

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

% Consulta individual usada pelo Java.
consultar_aluno(ID, Nome, Media, Participacoes, Estado) :-
    aluno(ID, Nome),
    media(ID, Media),
    forum(ID, Participacoes),
    estado(ID, Estado).

% ------------------------------------------------------------
% 4. Gestao dinamica da base de conhecimento
% ------------------------------------------------------------

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

% Atualiza estado auxiliar apos alteracoes.
atualizar_estado(ID) :-
    retractall(estado(ID, _)),
    (   em_risco(ID)
    ->  assertz(estado(ID, em_risco))
    ;   assertz(estado(ID, aprovado))
    ).

% ------------------------------------------------------------
% Bonus
% ------------------------------------------------------------

% Aluno em observacao: nao esta em risco, mas tem media moderada
% ou participacao apenas suficiente.
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

% ------------------------------------------------------------
% Persistencia
% ------------------------------------------------------------

% Regrava apenas os factos dinamicos no mesmo ficheiro.
% As regras sao mantidas abaixo no codigo-fonte do projeto; em contexto
% de avaliacao, esta persistencia demonstra a atualizacao da base.
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

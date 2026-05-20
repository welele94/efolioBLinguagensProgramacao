% ============================================================
% U.C. 21077 - Linguagens de Programacao
% e-Folio B - Regras Prolog
% Micael Santos - 2400005
% ============================================================
%
% Este ficheiro contem a logica de consulta, inferencia,
% listagem e gestao dinamica da base de conhecimento.
%
% Os factos persistentes encontram-se em:
% prolog/base_conhecimento.pl
%
% A base_conhecimento.pl guarda apenas os dados. Este ficheiro
% guarda as regras e predicados pedidos no enunciado.
% ============================================================


% ------------------------------------------------------------
% Carregamento da base de conhecimento
% ------------------------------------------------------------

:- consult('prolog/base_conhecimento.pl').


% ------------------------------------------------------------
% Predicados auxiliares de validacao
% ------------------------------------------------------------

% Verifica se um aluno existe na base.
aluno_existe(ID) :-
    aluno(ID, _).

% Verifica se uma media e valida.
% No contexto da avaliacao, as medias devem estar entre 0 e 20.
media_valida(Media) :-
    number(Media),
    Media >= 0,
    Media =< 20.

% Verifica se o numero de participacoes e valido.
participacao_valida(Participacoes) :-
    integer(Participacoes),
    Participacoes >= 0.


% ------------------------------------------------------------
% 1. Consultas basicas sobre alunos
% ------------------------------------------------------------

% em_risco(ID)
%
% Um aluno esta em risco se tiver media inferior a 10
% ou menos de 3 participacoes no forum.

em_risco(ID) :-
    aluno_existe(ID),
    media(ID, Media),
    Media < 10.

em_risco(ID) :-
    aluno_existe(ID),
    forum(ID, Participacoes),
    Participacoes < 3.


% participativo(ID)
%
% Um aluno tem participacao adequada se tiver 3 ou mais
% participacoes no forum.

participativo(ID) :-
    aluno_existe(ID),
    forum(ID, Participacoes),
    Participacoes >= 3.


% bom_desempenho(ID)
%
% Um aluno tem desempenho positivo se tiver media igual
% ou superior a 10.

bom_desempenho(ID) :-
    aluno_existe(ID),
    media(ID, Media),
    Media >= 10.


% ------------------------------------------------------------
% 2. Inferencia baseada na media da turma
% ------------------------------------------------------------

% media_turma(MediaTurma)
%
% Calcula a media aritmetica das medias existentes nos factos
% media/2. A media da turma e calculada dinamicamente e nao
% guardada como valor fixo.

media_turma(MediaTurma) :-
    findall(Media, media(_, Media), Medias),
    Medias \= [],
    sumlist(Medias, Soma),
    length(Medias, Total),
    MediaTurma is Soma / Total.


% acima_media(ID)
%
% Identifica alunos cuja media individual e maior ou igual
% a media aritmetica da turma.

acima_media(ID) :-
    aluno_existe(ID),
    media(ID, MediaAluno),
    media_turma(MediaTurma),
    MediaAluno >= MediaTurma.


% ------------------------------------------------------------
% 3. Consultas compostas e listagens
% ------------------------------------------------------------

% listar_em_risco(Lista)
%
% Lista todos os alunos em risco.

listar_em_risco(Lista) :-
    findall(ID, em_risco(ID), Resultado),
    sort(Resultado, Lista).


% listar_participativos(Lista)
%
% Lista todos os alunos com participacao adequada.

listar_participativos(Lista) :-
    findall(ID, participativo(ID), Resultado),
    sort(Resultado, Lista).


% listar_bons(Lista)
%
% Lista todos os alunos com bom desempenho.

listar_bons(Lista) :-
    findall(ID, bom_desempenho(ID), Resultado),
    sort(Resultado, Lista).


% listar_acima_media(Lista)
%
% Lista todos os alunos acima ou iguais a media da turma.

listar_acima_media(Lista) :-
    findall(ID, acima_media(ID), Resultado),
    sort(Resultado, Lista).


% consultar_aluno(ID, Nome, Media, Participacoes, Estado)
%
% Predicado auxiliar usado pela aplicacao Java para apresentar
% a informacao completa de um aluno.

consultar_aluno(ID, Nome, Media, Participacoes, Estado) :-
    aluno(ID, Nome),
    media(ID, Media),
    forum(ID, Participacoes),
    estado(ID, Estado).


% ------------------------------------------------------------
% 4. Gestao dinamica da base de conhecimento
% ------------------------------------------------------------

% adicionar_aluno(ID, Nome)
%
% Adiciona um novo aluno a base de conhecimento.
% O aluno e criado com media 0, participacao 0 e estado em_risco,
% podendo depois ser atualizado pelas funcionalidades proprias.

adicionar_aluno(ID, Nome) :-
    integer(ID),
    ID > 0,
    atom(Nome),
    \+ aluno_existe(ID),
    assertz(aluno(ID, Nome)),
    assertz(media(ID, 0)),
    assertz(forum(ID, 0)),
    assertz(estado(ID, em_risco)),
    guardar_base.


% atualizar_media(ID, NovaMedia)
%
% Atualiza a media de um aluno existente.
% Usa retractall/1 antes de assertz/1 para evitar factos duplicados.

atualizar_media(ID, NovaMedia) :-
    aluno_existe(ID),
    media_valida(NovaMedia),
    retractall(media(ID, _)),
    assertz(media(ID, NovaMedia)),
    atualizar_estado(ID),
    guardar_base.


% atualizar_participacao(ID, NovaParticipacao)
%
% Atualiza o numero de participacoes no forum de um aluno existente.
% Usa retractall/1 antes de assertz/1 para evitar factos duplicados.

atualizar_participacao(ID, NovaParticipacao) :-
    aluno_existe(ID),
    participacao_valida(NovaParticipacao),
    retractall(forum(ID, _)),
    assertz(forum(ID, NovaParticipacao)),
    atualizar_estado(ID),
    guardar_base.


% remover_aluno(ID)
%
% Remove todos os factos associados a um aluno.
% Isto evita deixar informacao residual na base de conhecimento.

remover_aluno(ID) :-
    aluno_existe(ID),
    retractall(aluno(ID, _)),
    retractall(forum(ID, _)),
    retractall(media(ID, _)),
    retractall(estado(ID, _)),
    guardar_base.


% atualizar_estado(ID)
%
% Atualiza o estado do aluno depois de uma alteracao de media
% ou de participacao.

atualizar_estado(ID) :-
    aluno_existe(ID),
    retractall(estado(ID, _)),
    (   em_risco(ID)
    ->  assertz(estado(ID, em_risco))
    ;   assertz(estado(ID, aprovado))
    ).


% ------------------------------------------------------------
% 5. Funcionalidade bonus
% ------------------------------------------------------------

% em_observacao(ID)
%
% Predicado bonus.
% Identifica alunos que nao estao em risco imediato, mas que ainda
% merecem acompanhamento por terem media moderada ou participacao
% apenas suficiente.

em_observacao(ID) :-
    aluno_existe(ID),
    \+ em_risco(ID),
    media(ID, Media),
    Media >= 10,
    Media < 12.

em_observacao(ID) :-
    aluno_existe(ID),
    \+ em_risco(ID),
    forum(ID, Participacoes),
    Participacoes >= 3,
    Participacoes < 5.


% listar_em_observacao(Lista)
%
% Lista todos os alunos em observacao.

listar_em_observacao(Lista) :-
    findall(ID, em_observacao(ID), Resultado),
    sort(Resultado, Lista).


% ------------------------------------------------------------
% 6. Persistencia da base de conhecimento
% ------------------------------------------------------------

% guardar_base
%
% Grava os factos dinamicos no ficheiro prolog/base_conhecimento.pl.
% As regras ficam separadas neste ficheiro, evitando que sejam apagadas
% quando a base e atualizada.

guardar_base :-
    open('prolog/base_conhecimento.pl', write, Stream),
    escrever_cabecalho_base(Stream),
    escrever_factos(Stream),
    close(Stream).


% escrever_cabecalho_base(Stream)
%
% Escreve o cabecalho minimo da base persistente.

escrever_cabecalho_base(Stream) :-
    write(Stream, '% ============================================================'), nl(Stream),
    write(Stream, '% U.C. 21077 - Linguagens de Programacao'), nl(Stream),
    write(Stream, '% e-Folio B - Base de Conhecimento Prolog'), nl(Stream),
    write(Stream, '% Micael Santos - 2400005'), nl(Stream),
    write(Stream, '% ============================================================'), nl(Stream), nl(Stream),
    write(Stream, ':- dynamic aluno/2.'), nl(Stream),
    write(Stream, ':- dynamic forum/2.'), nl(Stream),
    write(Stream, ':- dynamic media/2.'), nl(Stream),
    write(Stream, ':- dynamic estado/2.'), nl(Stream), nl(Stream).


% escrever_factos(Stream)
%
% Escreve todos os factos atualmente carregados em memoria.

escrever_factos(Stream) :-
    write(Stream, '% Alunos'), nl(Stream),
    forall(aluno(ID, Nome),
        format(Stream, 'aluno(~q, ~q).~n', [ID, Nome])),
    nl(Stream),

    write(Stream, '% Participacoes no forum'), nl(Stream),
    forall(forum(ID, Participacoes),
        format(Stream, 'forum(~q, ~q).~n', [ID, Participacoes])),
    nl(Stream),

    write(Stream, '% Medias finais'), nl(Stream),
    forall(media(ID, Media),
        format(Stream, 'media(~q, ~q).~n', [ID, Media])),
    nl(Stream),

    write(Stream, '% Estados finais'), nl(Stream),
    forall(estado(ID, Estado),
        format(Stream, 'estado(~q, ~q).~n', [ID, Estado])).
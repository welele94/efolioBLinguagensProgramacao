% ============================================================
% U.C. 21077 - Linguagens de Programacao
% e-Folio B - Base de Conhecimento Prolog
% Micael Santos - 2400005
% ============================================================
%
% Este ficheiro representa a base de conhecimento persistente
% do sistema. Os dados aqui presentes resultam do tratamento
% efetuado no e-Folio A, nomeadamente:
%
%   - identificacao dos alunos;
%   - numero de participacoes no forum;
%   - media final calculada;
%   - estado final atribuido.
%
% A logica de consulta, inferencia, listagem e gestao dinamica
% encontra-se no ficheiro regras.pl.
%
% Esta separacao evita que as regras sejam apagadas quando a
% base de dados e atualizada durante a execucao.
% ============================================================


% ------------------------------------------------------------
% Declaracao de predicados dinamicos
% ------------------------------------------------------------
%
% Estes predicados podem ser alterados em tempo de execucao
% atraves de assertz/1 e retractall/1, permitindo adicionar,
% atualizar ou remover informacao da base de conhecimento.

:- dynamic aluno/2.
:- dynamic forum/2.
:- dynamic media/2.
:- dynamic estado/2.


% ------------------------------------------------------------
% Alunos
% ------------------------------------------------------------
%
% aluno(ID, Nome).
%
% ID   - identificador numerico unico do aluno.
% Nome - nome completo do aluno.

aluno(1, 'Ana Silva').
aluno(2, 'Bruno Costa').
aluno(3, 'Carla Mendes').
aluno(4, 'Diogo Pereira').
aluno(5, 'Eduarda Santos').
aluno(6, 'Fabio Lopes').


% ------------------------------------------------------------
% Participacao no forum
% ------------------------------------------------------------
%
% forum(ID, Participacoes).
%
% Participacoes representa o numero total de participacoes
% relevantes no forum. Segundo o enunciado, um aluno tem
% participacao adequada quando este valor e maior ou igual a 3.

forum(1, 4).
forum(2, 1).
forum(3, 5).
forum(4, 2).
forum(5, 0).
forum(6, 0).


% ------------------------------------------------------------
% Media final
% ------------------------------------------------------------
%
% media(ID, MediaFinal).
%
% A media final foi calculada no e-Folio A e e agora usada
% como facto da base de conhecimento. No e-Folio B, estes
% valores sao usados para consultas como bom_desempenho/1,
% em_risco/1, media_turma/1 e acima_media/1.

media(1, 14.67).
media(2, 8.50).
media(3, 17.67).
media(4, 11.00).
media(5, 6.50).
media(6, 0.00).


% ------------------------------------------------------------
% Estado final
% ------------------------------------------------------------
%
% estado(ID, EstadoFinal).
%
% EstadoFinal representa a classificacao final obtida no
% e-Folio A. No e-Folio B, este facto serve como informacao
% complementar para consulta individual e persistencia.

estado(1, aprovado).
estado(2, em_risco).
estado(3, aprovado).
estado(4, condicionado).
estado(5, retido).
estado(6, retido).
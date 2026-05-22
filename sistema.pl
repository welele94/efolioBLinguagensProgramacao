% ============================================================
% U.C. 21077 - Linguagens de Programacao
% e-Folio B - Sistema Prolog
% Micael Santos - 2400005
% ============================================================
%
% Este e o ficheiro principal de carregamento do sistema.
% Ao consultar este ficheiro, sao carregados os factos persistentes
% e as regras de consulta, inferencia e gestao dinamica.
%
% Utilizacao no SWI-Prolog:
% ?- consult('sistema.pl').
% ============================================================

:- consult('base_conhecimento.pl').
:- consult('prolog/regras.pl').

% Define explicitamente o ficheiro onde as alteracoes devem ser persistidas.
:- set_ficheiro_base('base_conhecimento.pl').

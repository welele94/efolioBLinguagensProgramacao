<<<<<<<< HEAD:prolog/base_conhecimento.pl
% ============================================================
% U.C. 21077 - Linguagens de Programacao
% e-Folio B - Base de Conhecimento Prolog
% Micael Santos 2400005
% ============================================================

========
>>>>>>>> 833cbba736d65381bd1568607ba9ec80bd908cea:base_conhecimento.pl
:- dynamic aluno/2.
:- dynamic forum/2.
:- dynamic media/2.
:- dynamic estado/2.

aluno(1, 'Ana Silva').
aluno(2, 'Bruno Costa').
aluno(3, 'Carla Mendes').
aluno(4, 'Diogo Pereira').
aluno(5, 'Eduarda Santos').
aluno(6, 'Fabio Lopes').

forum(1, 4).
forum(2, 1).
forum(3, 5).
forum(4, 2).
forum(5, 0).
forum(6, 0).

media(1, 14.67).
media(2, 8.50).
media(3, 17.67).
media(4, 11.00).
media(5, 6.50).
media(6, 0.00).

estado(1, aprovado).
estado(2, em_risco).
estado(3, aprovado).
estado(4, condicionado).
estado(5, retido).
estado(6, retido).

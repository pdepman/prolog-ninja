persona(ada, 166, 60).
persona(beto, 166, 65).
persona(connie, 154, 50).
persona(dana, 180, 70).
persona(esteban, 193, 40).



%Parte B

algunoSuperaA(Persona):-
    persona(Persona, _, Fuerza),
    findall(Otro, (persona(Otro,_,FuerzaOtro), FuerzaOtro >= Fuerza), Otros),
    length(Otros, Longitud),
    Longitud > 0.



% El código resuelve el problema planteado? 

% No, porque el findall encuentra todas las personas cuya fuerza sea mayor o igual a la de la persona original,
% lo cual siempre va a incluir a la misma persona, y luego se verifica que la lista no sea vacia. 
% Por lo tanto, siempre va a ser true.


% El predicado algunoSuperaA es inversible?

% Si, porque se liga Persona con el predicado "persona", que es un hecho, los cuales son siempre inversibles.

% El predicado algunoSuperaA tiene problemas de declaratividad?

% Si, porque el uso de findall para armar una lista y luego verificar su longitud para saber 
% si alguna persona cumple una cierta condicion es una solucion innecesariamente procedural,
% porque en prolog se puede resolver de una forma mas declarativa:

algunoSuperaA2(Persona):-
    persona(Persona, _, Fuerza),
    persona(_, _, FuerzaSuperior),
    FuerzaSuperior > Fuerza.


% Parte C

obstaculo(aro(7), 14).
obstaculo(aro(15), 70).
obstaculo(barril(seco, 80), 10).
obstaculo(aro(15), 10).
obstaculo(barril(humedo, 50), 26).
obstaculo(aro(2), 27).
obstaculo(pared(5), 90).

laMetaEstaEn1(Metros):-
  obstaculo(_, Metros),
  findall(Obs, (obstaculo(Obs, OtrosMetros), OtrosMetros > Metros), Obstaculos),
  length(Obstaculos, 0).

laMetaEstaEn2(Metros):-
  forall(obstaculo(_, OtrosMetros), OtrosMetros < Metros).



%¿Ambas soluciones funcionan igual? 

% No, porque una usa findall y otra forall, los cuales funcionan distinto 
% No, porque la que usa forall no es inversible y la que usa findall si, por lo que funcionan distinto.
% Si, porque dan el mismo resultado.
% Si, porque ambos usan el motor de backtracking, por lo que en el fondo funcionan igual.

laMetaEstaEnDistinto(Metros):-
    not(hayObstaculoMasAdelante(Metros)).

hayObstaculoMasAdelante(Metros):-
    obstaculo(_, MetrosDelante),
    MetrosDelante > Metros.

% Parte D

% Es sencillo agregar un nuevo tipo de obstáculo sin modificar el código existente?

% Si, no hace falta modificar codigo existente, solo es necesario copiar y pegar puedeDarUnPaso, lo cual es sencillo.

% Hay conceptos del dominio que no están en el código?

% Si, falta plantear los conceptos de que una persona puede superar un obstaculo y el de la dificultad.

% Se perite logica?

% Si, se perite casi toda la logica en todos los predicados, solo cambiando la particularidad segun el tipo de obstaculo


puedeDarUnPaso(Persona, Desde, Hasta):-
    aperturaDeBrazosSuficiente(Persona, Desde, Hasta),
    puedeSuperarObstaculoEn(Persona, Hasta).


aperturaDeBrazosSuficiente(Persona, Desde, Hasta):-
    persona(Persona, Apertura, _),
    Apertura > Hasta - Desde.

puedeSuperarObstaculoEn(Persona, PosicionObstaculo):-
    persona(Persona, _, Fuerza),
    obstaculo(Obstaculo, PosicionObstaculo),
    fuerzaSuficientePara(Fuerza, Obstaculo).

fuerzaSuficientePara(Fuerza, Obstaculo):-
    dificultad(Obstaculo, Dificultad),
    Fuerza > Dificultad.


dificultad(aro(Grosor), Grosor).

dificultad(pared(Altura), Dificultad):-
    Dificultad is Altura * 3.


% version 1
dificultad(barril(humedo,Diametro), Dificultad):-
    Dificultad is 50 * Diametro / 10.

dificultad(barril(seco,Diametro), Dificultad):-
    Dificultad is 30 * Diametro / 10.

% version 2

dificultad(barril(Tipo,Diametro), Dificultad):-
    factorTipoBarril(Tipo, Factor),
    Dificultad is Factor * Diametro / 10.

factorTipoBarril(humedo, 50).
factorTipoBarril(seco, 30).


% Parte E

puedeGanarDesde(Persona, PosicionFinal):-
    persona(Persona, _, _),
    obstaculo(_, PosicionFinal),
    not(siguientePosicion(PosicionFinal, _)).

puedeGanarDesde(Persona, PosicionActual):-
    persona(Persona, _, _),
    obstaculo(_, PosicionActual),
    siguientePosicion(PosicionActual, PosicionSiguiente),
    puedeDarUnPaso(Persona, PosicionActual, PosicionSiguiente),
    puedeGanarDesde(Persona, PosicionSiguiente).

siguientePosicion(PosicionActual, PosicionSiguiente):-
    obstaculo(_, PosicionSiguiente),
    PosicionSiguiente > PosicionActual,
    not(hayObstaculoIntermedio(PosicionActual, PosicionSiguiente)).

hayObstaculoIntermedio(PosicionInicial, PosicionFinal):-
    obstaculo(_, PosicionIntermedia),
    PosicionIntermedia > PosicionInicial,
    PosicionIntermedia < PosicionFinal.

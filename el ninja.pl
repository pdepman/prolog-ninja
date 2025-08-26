persona(ada, 166, 60).
persona(beto, 166, 65).
persona(connie, 154, 50).
persona(dana, 180, 70).
persona(esteban, 193, 40).

%Parte B

algunoSuperaA(Persona):-
    persona(Persona, _, Fuerza),
    findall(Otro, (persona(Otro,_,FuerzaOtro), FuerzaOtro > Fuerza), Otros),
    length(Otros, Longitud),
    Longitud > 0.



% ¿El código resuelve el problema planteado? 

% Sí, resuelve el problema planteado. Encuentra todas las personas con más fuerza que la persona dada, arma una lista de Otros, y si su longitud es mayor que cero, es porque existe alguno que supera.

% ¿El predicado algunoSuperaA es inversible?

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

laMetaEstaEn1(Posicion):-
  obstaculo(_, Posicion),
  findall(Obs, (obstaculo(Obs, Pos), 
      Pos > Posicion), Obstaculos),
  length(Obstaculos, 0).

laMetaEstaEn2(Posicion):-
  forall(obstaculo(_, Pos), Posicion >= Pos).


%¿Ambas soluciones funcionan igual? Justificar conceptualmente usando ejemplos de consulta individuales y existenciales con sus respuestas en cada caso.

% No funcionan igual. laMetaEstaEn1 es cierto sólo para la posición en la que esté el último obstáculo,
% mientras que laMetaEstaEn2 es cierta para cualquier posición igual o superior al último obstáculo. 
% Consulta individual que ejemplifica la diferencia:
% ?- laMetaEstaEn1(100).
% false.
% ?- laMetaEstaEn2(100).
% true.
% Además, laMetaEstaEn1 es inversible pero la otra no.
% Consulta existencial que ejemplifica la diferencia:
% ?- laMetaEstaEn1(Meta).
% Meta = 90.
% ?- laMetaEstaEn2(Meta).
% Error: arguments are not sufficiently instantiated 
% El problema es el >=, al que llega sin ligar la variable Posicion.

laMetaEstaEn(Posicion):-
    obstaculo(_, Posicion),
    not(hayObstaculoMasAdelante(Posicion)).

hayObstaculoMasAdelante(Posicion):-
    obstaculo(_, PosicionDelante),
    PosicionDelante > Posicion.

% Parte D

% a) Es sencillo agregar un nuevo tipo de obstáculo sin cambiar el predicado puedeDarUnPaso.
% Falso, hay que agregar una cláusula al predicado. (Además, repetir mucha lógica)

% Hay conceptos del dominio que no están en el código.
% Verdadero, falta plantear los conceptos de que una persona puede superar un obstáculo y el de la dificultad.

% Se repite logica.
% Verdadero,  se repite casi toda la logica en todos los predicados, sólo cambiando la particularidad según el tipo de obstáculo. En particular la lógica que se repite son los conceptos de dominio del punto anterior.


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

dificultad(barril(Tipo,Diametro), Dificultad):-
    factorTipoBarril(Tipo, Factor),
    Dificultad is Factor * Diametro / 10.

factorTipoBarril(humedo, 50).
factorTipoBarril(seco, 30).

% Parte E

puedeGanarDesde(Persona, PosicionFinal):-
    puedeSuperarObstaculoEn(Persona, PosicionFinal), % por si arranca en el final
    laMetaEstaEn(PosicionFinal).

puedeGanarDesde(Persona, PosicionActual):-
    puedeDarUnPaso(Persona, PosicionActual, PosicionSiguiente),
    puedeGanarDesde(Persona, PosicionSiguiente).

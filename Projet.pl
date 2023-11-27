% exo 01

% Prédicat addh/3
addh([H, M], Minutes, [RHeure, RMinute]) :-
    TotalMinutes is H * 60 + M + Minutes,
    RHeure is TotalMinutes // 60 mod 24,
    RMinute is TotalMinutes mod 60.

% Prédicat affiche/1
affiche([H, M]) :-
    atomics_to_string([H, M], ':', Result),
    format('~|~`0t~w~2+', [Result]).

% exo 02

lig(Arret1, Arret2, _) :-  % Remove unused variable Ligne
    ligne(_, _, LArret, _, _),
    member([Arret1, _], LArret),
    member([Arret2, _], LArret).

ligtot(Arret1, Arret2, Ligne, Horaire) :-
    lig(Arret1, Arret2, Ligne),
    ligne(Ligne, _, _, LTrajet, _),
    member([Arret1, [HDepart, MDepart]], LTrajet),
    affiche([HDepart, MDepart]), % Fix here, using the modified affiche/1
    addh([HDepart, MDepart], 0, Horaire).

ligtard(Arret1, Arret2, Ligne, Horaire) :-
    lig(Arret1, Arret2, Ligne),
    ligne(Ligne, _, _, LTrajet, _),
    member([Arret2, [HArrivee, MArrivee]], LTrajet),
    affiche([HArrivee, MArrivee]), % Fix here, using the modified affiche/1
    addh([HArrivee, MArrivee], 0, Horaire).



% Facts representing bus lines
ligne(1, 'Ligne A', [[arret1, [8, 0]], [arret2, [8, 15]], [arret3, [8, 30]]], [[arret1, [8, 0]], [arret2, [8, 15]], [arret3, [8, 30]]], [monday, tuesday, wednesday, thursday, friday]).
ligne(2, 'Ligne B', [[arret1, [9, 0]], [arret3, [9, 15]], [arret4, [9, 30]]], [[arret1, [9, 0]], [arret3, [9, 15]], [arret4, [9, 30]]], [monday, wednesday, friday]).
% Add more bus lines as needed

% Facts representing stops
arret(arret1).
arret(arret2).
arret(arret3).
arret(arret4).
% Add more stops as needed

% Facts representing connections between stops
connexion(arret1, arret2).
connexion(arret2, arret3).
connexion(arret3, arret4).
% Add more connections as needed

% exo 03

itinTot(Arret1, Arret2, [HR, MR], Parcours) :-
    ligtot(Arret1, Arret2, Nom, _),
    ligne(Nom, _, _, [[HD, MD], _, _], _),
    addh([HD, MD], 0, [HDepart, MDepart]),
    HoraireDepart is HDepart * 60 + MDepart,
    HoraireDonne is HR * 60 + MR,
    (HoraireDonne < HoraireDepart ->
        Parcours = [HDepart, MDepart] % Fix here: use a list [HDepart, MDepart]
    ;
        false
    ).

itinTard(Arret1, Arret2, [HR, MR], Parcours) :-
    ligtard(Arret1, Arret2, Nom, _),
    ligne(Nom, _, _, [[HArrivee, MArrivee], _, _], _),
    addh([HArrivee, MArrivee], 0, [HArrive, MArrive]),
    HoraireArrivee is HArrive * 60 + MArrive,
    HoraireDonne is HR * 60 + MR,
    (HoraireDonne > HoraireArrivee ->
        Parcours = [HArrive, MArrive]
    ;
        false
    ).


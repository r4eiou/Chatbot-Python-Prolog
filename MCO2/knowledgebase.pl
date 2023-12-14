:- dynamic grandparent/2.

:- dynamic grandmother/2.
:- dynamic not_grandmother/2.

:- dynamic grandmotherT/2.

:- dynamic grandfather/2.
:- dynamic not_grandfather/2.

:- dynamic grandfatherT/2.

:- dynamic parent/2.
:- dynamic not_parent/2.

:- dynamic parentT/2.

:- dynamic auntle/2.

:- dynamic aunt/2.
:- dynamic not_aunt/2.

:- dynamic auntT/2.

:- dynamic uncle/2.
:- dynamic not_uncle/2.

:- dynamic uncleT/2.

:- dynamic mother/2.
:- dynamic not_mother/2.

:- dynamic motherT/2.

:- dynamic father/2.
:- dynamic not_father/2.

:- dynamic fatherT/2.

:- dynamic child/2.
:- dynamic not_child/2.

:- dynamic childT/2.

:- dynamic daughter/2.
:- dynamic not_daughter/2.

:- dynamic daughterT/2.

:- dynamic son/2.
:- dynamic not_son/2.

:- dynamic sonT/2.

:- dynamic siblings/2.
:- dynamic not_siblings/2.

:- dynamic siblingsT/2.

:- dynamic sister/2.
:- dynamic not_sister/2.

:- dynamic sisterT/2.

:- dynamic brother/2.
:- dynamic not_brother/2.

:- dynamic brotherT/2.

:- dynamic male/1.
:- dynamic female/1.

:- dynamic relatives/2.

:- dynamic twoparents/2.

relatives(X,Y) :- grandparent(X,Y) ; auntle(X,Y) ; parent(X,Y) ; child(X,Y) ; siblings(X,Y).

/*Sibling Rules*/
brother(X,Y) :- brotherT(X,Y).
brother(X,Y) :- male(X), siblingsT(X,Y).
brother(X,Y) :- (male(X), siblingsT(X,Z), siblings(Z,Y)), X\=Y.
brother(X,Y) :- (male(X), brotherT(Y,X)), X\=Y.
brotherT(X,Y) :- uncleT(X,Z), parentT(Y,Z).
brotherT(X,Y) :- uncleT(X,Z), childT(Z,Y).

sister(X,Y) :- sisterT(X,Y).
sister(X,Y) :- female(X), siblingsT(X,Y).
sister(X,Y) :- female(X), siblingsT(X,Z), siblings(Z,Y).
sister(X,Y) :- female(X), sisterT(Y,X).
sisterT(X,Y) :- auntT(X,Z), parentT(Y,Z).
sisterT(X,Y) :- auntT(X,Z), childT(Z,Y).

siblings(X,Y) :- (brother(X,Y) ; sister(X,Y)), X\=Y.
siblings(X,Y) :- siblingsT(X,Y) ; siblingsT(Y,X).
siblings(X,Y) :- siblingsT(X,Z), siblingsT(Z,Y), X\=Y.
siblings(X,Y) :- siblingsT(Y,Z), siblingsT(X,Z), X\=Y.
siblings(X,Y) :- parent(Z,X), parent(Z,Y), X\=Y.
siblings(X,Y) :- child(X,Z), child(Y,Z), X\=Y.
siblingsT(X,Y) :- (sisterT(X,Y); brotherT(X,Y)), X\=Y.

auntle(X,Y) :- uncleT(X,Y) ; auntT(X,Y).

uncle(X,Y) :- uncleT(X,Y).
uncle(X,Y) :- brother(X,Z), parentT(Z,Y).
uncle(X,Y) :- brother(X,Z), childT(Y,Z).

aunt(X,Y) :- auntT(X,Y).
aunt(X,Y) :- sister(X,Z), parentT(Z,Y).
aunt(X,Y) :- sister(X,Z), childT(Y,Z).

/*Parent Child Rules*/
parent(X,Y) :- parentT(X,Y).
parent(X,Y) :- childT(Y,X).
parent(X,Y) :- parentT(X,Z), siblingsT(Y,Z).
parent(X,Y) :- father(X,Y) ; mother(X,Y).
parent(X,Y) :- (grandparent(Z,Y), childT(X,Z)) ;
                (grandparent(X,Z), childT(Z,Y)).
parentT(X,Y) :- fatherT(X,Y) ; motherT(X,Y).

father(X,Y) :- fatherT(X,Y).
father(X,Y) :- male(X), parentT(X,Y).
father(X,Y) :- male(X), childT(Y,X).
father(X,Y) :- fatherT(X,Z), siblingsT(Y,Z).
father(X,Y) :- male(X), grandparent(X,Z), parentT(Y,Z).
father(X,Y) :- male(X), grandparent(X,Z), childT(Z,Y).

mother(X,Y) :- motherT(X,Y).
mother(X,Y) :- female(X), parentT(X,Y).
mother(X,Y) :- female(X), childT(Y,X).
mother(X,Y) :- motherT(X,Z), siblingsT(Y,Z).
mother(X,Y) :- female(X), grandparent(X,Z), parentT(Y,Z).
mother(X,Y) :- female(X), grandparent(X,Z), childT(Z,Y).

child(X,Y) :- childT(X,Y).
child(X,Y) :- parentT(Y,X).
child(X,Y) :- (grandparent(Z,X), parentT(Z,Y)) ;
                (grandparent(Y,Z), parentT(X,Z)).
childT(X,Y) :- sonT(X,Y) ; daughterT(X,Y).

son(X,Y) :- sonT(X,Y).
son(X,Y) :- male(X), childT(X,Y).
son(X,Y) :- male(X), parentT(Y,X).
son(X,Y) :- male(X), grandparent(Y,Z), parentT(X,Z).
son(X,Y) :- male(X), grandparent(Z,X), childT(Y,Z).

daughter(X,Y) :- daughterT(X,Y).
daughter(X,Y) :- female(X), childT(X,Y).
daughter(X,Y) :- female(X), parentT(Y,X).
daughter(X,Y) :- female(X), grandparent(Y,Z), parentT(X,Z).
daughter(X,Y) :- female(X), grandparent(Z,X), childT(Y,Z).

/*Grand Parent Rules*/
grandparent(X,Y) :- grandfatherT(X,Y) ; grandmotherT(X,Y).
grandparent(X,Y) :- grandfather(X,Y) ; grandmother(X,Y).

grandfather(X,Y) :- grandfatherT(X,Y).
grandfather(X,Y) :- male(X), parentT(X,Z), parentT(Z,Y).
grandfather(X,Y) :- male(X), childT(Y,Z), childT(Z,X).
grandfather(X,Y) :- male(X), parentT(X,Z), childT(Y,Z).
grandfather(X,Y) :- male(X), parentT(Z,Y), childT(Z,X).

grandmother(X,Y) :- grandmotherT(X,Y).
grandmother(X,Y) :- female(X), parentT(X,Z), parentT(Z,Y).
grandmother(X,Y) :- female(X), childT(Y,Z), childT(Z,X).
grandmother(X,Y) :- female(X), parentT(X,Z), childT(Y,Z).
grandmother(X,Y) :- female(X), parentT(Z,Y), childT(Z,X).

/*Checks for age*/
isOlder(X,Y) :- ascendant(X,Y).
isYounger(X,Y) :- descendant(X,Y).      

ascendant(X,Y) :- parent(X,Y).
ascendant(X,Y) :- parentT(X,Z), ascendant(Z,Y).
descendant(X,Y) :- child(X,Y).
descendant(X,Y) :- childT(X,Z), descendant(Z,Y).

/*Not Rules*/
not_brother(X,Y) :- sisterT(X,Y).
not_brother(X,Y) :- female(X); isOlder(X,Y); isYounger(X,Y).
not_brother(X,Y) :- X==Y.

not_sister(X,Y) :- brotherT(X,Y).
not_sister(X,Y) :- male(X); isOlder(X,Y); isYounger(X,Y).
not_sister(X,Y) :- X==Y.

not_siblings(X,Y) :- isOlder(X,Y) ; isYounger(X,Y).
not_siblings(X,Y) :- parent(X,Y) ; parent(Y,X).
not_siblings(X,Y) :- X==Y.

not_aunt(X,Y) :- (male(X) ; (parent(Z,Y), not_siblings(X,Z))); X==Y.
not_uncle(X,Y) :- female(X) ; (parent(Z,Y), not_siblings(X,Z)); X==Y.

not_parent(X,Y) :- isOlder(Y,X); isYounger(X,Y); siblingsT(X,Y).
not_parent(X,Y) :- uncle(Y,X) ; aunt(Y,X).

not_father(X,Y) :- female(X) ; isOlder(Y,X) ; grandparent(X,Y).
not_father(X,Y) :- Y==X ; father(_Z,Y) ; child(X,Y) ; mother(X,Y); siblingsT(X,Y).

not_mother(X,Y) :- Y==X ; 
                    mother(_Z,Y) ;
                    child(X,Y) ;
                    father(X,Y); 
                    siblingsT(X,Y).
                    
not_mother(X,Y) :- male(X) ; isOlder(Y,X) ; grandparent(X,Y).

not_child(X,Y) :- isOlder(X,Y) ; (childT(X,Z) , childT(Z,V), childT(V,Y)) ; grandparent(Y,X).
not_child(X,Y) :- X==Y.

not_son(X,Y) :- female(X); isOlder(X,Y).
not_son(X,Y) :- X==Y.

not_daughter(X,Y) :- male(X); isOlder(X,Y).
not_daughter(X,Y) :- X==Y.
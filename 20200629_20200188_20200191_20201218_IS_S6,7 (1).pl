%Yara Muhammad Saad      20200629
%Reem Mohamed Makram     20200188
%Reham Magdy Mahmoud     20200191
%Walaa Soudy  ibrahim           20201218

:-use_module(data).
:- discontiguous friendListCount/2.
%Q1
is_friend(X,Y):-friend(X, Y).
is_friend(Y,X):-friend(X, Y).
%Q2
friendList(P, L) :-
    friendListHelper(P,[],L).

member(X,[X|_]).
member(X,[_|T]):-member(X,T).

friendListHelper(P,Accepted,L) :-
    friend(P, F),
    \+ member(F,Accepted),!,
    friendListHelper(P,[F|Accepted],L).
friendListHelper(_, L, L).
%Q3
friendListCount(Person, Count) :-
    friendListCount(Person,[],0,Count),!.

friendListCount(Person,CheckedFriends,CurrentCount,Result) :-
    friend(Person, Friend),
    \+ member(Friend, CheckedFriends),
    % ensure that the same friend is not added twice
    NewCount is CurrentCount + 1,
    friendListCount(Person,[Friend | CheckedFriends],NewCount, Result).

friendListCount(_, _,FinalCount,FinalCount).

friendListCount(Person, 0) :-
    \+ friend(Person, _).
%Q4
peopleYouMayKnow(Y,X):-is_friend(Y,Z),is_friend(Z,X),not(is_friend(Y,X)),not(X=Y).
%Q6
peopleYouMayKnowList(Person, MutualFriendsList) :-
    peopleYouMayKnowCheck(Person, [], MutualFriendsList).

peopleYouMayKnowCheck(Person, List, MutualFriendsList) :-
    friend(Person,Z),
    (friend(L,Z);friend(Z,L)),
    L \= Person,
    \+ member(L, List), !,
    peopleYouMayKnowCheck(Person, [L|List], MutualFriendsList).

peopleYouMayKnowCheck(_, List, List).
%Q7
peopleYouMayKnow_indirect(X,W):-
    is_friend(X,Y),
    is_friend(Y,Z),
    is_friend(Z,W),
    not(is_friend(X,W)),
    not(X=W),
    not(peopleYouMayKnow(X,W)).

%Q5
peopleYouMayKnow(Person, N, SuggestedFriend) :-
    setof(Friend, friend(Person, Friend), Friends),
    findall(MutualFriend,
            (friend(Friend, MutualFriend),
             \+ friend(Person, MutualFriend),
             length([F1, F2], 2),
             select(F1, Friends, RemainingFriends),
             select(F2, RemainingFriends, _),
             friend(F1, MutualFriend),
             friend(F2, MutualFriend)),
            MutualFriends),
    length(MutualFriends, MutualFriendsCount),
    MutualFriendsCount >= N,
    nth0(0, MutualFriends, SuggestedFriend).





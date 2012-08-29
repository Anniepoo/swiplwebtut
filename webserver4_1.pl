:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).

% include this module, you have sessions
:- use_module(library(http/http_session)).


:- http_handler('/', say_hi, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

say_hi(_Request) :-
	nick_name(Nick),
	reply_html_page(
	   [title('Howdy')],
	   [h1('An Affirming Web Page'),
	    p('~w, we are glad your spirit is present with us'-[Nick])]).

%
% case for if we've already given them a nickname
nick_name(Nick) :-
	http_session_data(nick_name(Nick)),!.

nick_name(Nick) :-
	nick_list(NickList),
	random_member(Nick, NickList),
	http_session_assert(nick_name(Nick)).

nick_list([
    'Gentle One',
    'Blessed Spirit',
    'Wise Soul',
    'Wise One',
    'Beloved Friend'
	  ]).

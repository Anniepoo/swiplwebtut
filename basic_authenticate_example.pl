:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_authenticate)).

:- http_handler('/', manual_authentication_handler, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

% manually authenticate
manual_authentication_handler(Request) :-
	(   http_authenticate(basic(passwd), Request, _Fields)
	->  true
	;   throw(http_reply(authorise(basic, harbinger_realm)))
	),
	reply_html_page(
	   [title('Howdy')],
	    [\page_content(Request)]).

page_content(Request) -->
	{ format(atom(R), '~w', [Request]) },
	html([
	    h1('A Simple Web Page'),
	    p(['Howdy ', R])
	]).

:- http_handler('/easier', say_easier, [authentication(basic(passwd, unguent_realm))]).

say_easier(Request) :-
	reply_html_page(
	    title('say easier'),
	    \page_content(Request)).

add_uname_pw(Uname, PW) :-
	http_read_passwd_file(passwd, Users),
	crypt(PW, Hash),
	http_write_passwd_file(passwd, [passwd(Uname, Hash, []) | Users]).

% start the passwd file with user adminuser password adminpw
start_pw_file :-
	crypt(adminpw, Hash),
	atom_codes(AHash, Hash),
	http_write_passwd_file(passwd, [passwd(adminuser, AHash, [])]).


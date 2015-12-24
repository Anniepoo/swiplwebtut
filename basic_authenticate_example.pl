:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_authenticate)).

:- http_handler('/', say_hi, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

say_hi(Request) :-
	(   http_authenticate(basic(passwd), Request, _Fields)
	->  true
	;   throw(http_reply(authorise(basic, '/')))
	),
	reply_html_page(
	   [title('Howdy')],
	    [\page_content(Request)]).

page_content(_Request) -->
	html([
	    h1('A Simple Web Page'),
	    p('Howdy')
	]).


add_uname_pw(Uname, PW) :-
	http_read_passwd_file(passwd, Users),
	crypt(PW, Hash),
	http_write_passwd_file(passwd, [passwd(Uname, Hash, []) | Users]).

% start the passwd file with user adminuser password adminpw
start_pw_file :-
	crypt(adminpw, Hash),
	atom_codes(AHash, Hash),
	http_write_passwd_file(passwd, [passwd(adminuser, AHash, [])]).


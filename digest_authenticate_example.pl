:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_digest)).

%
%  lemon is the realm, passwd is the name of the password file
%
:- http_handler('/', say_hi, [authentication(digest(passwd, lemon))]).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

say_hi(Request) :-
	reply_html_page(
	   [title('Howdy')],
	    [\page_content(Request)]).

page_content(Request) -->
	{
           member(user(User), Request)
        },
	html([
	    h1('Authenticated'),
	    p(['Howdy ', User])
	]).

%
%  create a password file named passwd with
%  a single user, Bob, with password secret,
%  for realm lemon
%
create_pw_file :-
	http_digest_password_hash('Bob', lemon, secret, Hash),
	setup_call_cleanup(
	    open(passwd, write, Stream),
	    format(Stream, '~w:~w~n', ['Bob', Hash]),
	    close(Stream)
	).

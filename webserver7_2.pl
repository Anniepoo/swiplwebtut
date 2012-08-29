:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).

% http_reply_from_files is here
:- use_module(library(http/http_files)).
% http_404 is in here
:- use_module(library(http/http_dispatch)).
% html generation and mailman
:- use_module(library(http/html_write)).
% html_resource
:- use_module(library(http/html_head)).

% Finally! now we know why Annie keeps doing this
%
:- multifile http:location/3.
:- dynamic   http:location/3.

http:location(files, '/f', []).

% this serves files from the directory assets
% under the working directory
:- http_handler(files(.), serve_files, [prefix]).

serve_files(Request) :-
	 http_reply_from_files('assets', [], Request).
serve_files(Request) :-
	  http_404([], Request).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

:- http_handler(root(.), a_handler, []).

a_handler(_Request) :-
	reply_html_page(
	    [title('a page with style')],
	    [h1('A Page That Glitters'),
	     \html_requires(files('specialstyle.css')),
	     p('This para is green')]).

:- html_resource(files('specialstyle.css'), [requires(files('gradstyle.css'))]).

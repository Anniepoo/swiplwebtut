:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).

% http_reply_from_files is in here
:- use_module(library(http/http_files)).

% Finally! now we know why Annie keeps doing this
%
:- multifile http:location/3.
:- dynamic   http:location/3.

http:location(files, '/f', []).

% this serves files from the directory assets
% under the working directory
:- http_handler(files(.), http_reply_from_files('assets', []), [prefix]).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).





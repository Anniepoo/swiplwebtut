:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).

% Declare a handler, binding an HTTP path to a predicate.
% The notation root(hello_world) uses an alias-mechanism similar to
% absolute_file_name/3 and allows for moving parts of the server locations
% easily. See http_absolute_location/3.
:- http_handler(root(.), say_hi, []).

% And, just for clarity, define a second handler
% this one can by reached at http://127.0.0.1:8000/taco
:- http_handler(root(taco), say_taco, []).

% The predicate server(?Port) starts the server. It simply creates a
% number of Prolog threads and then returns to the toplevel, so you can
% (re-)load code, debug, etc.
server(Port) :-
        http_server(http_dispatch, [port(Port)]).

/* The implementation of /hello_world. The single argument provides the request
details, which we ignore for now. Our task is to write a CGI-Document:
a number of name: value -pair lines, followed by two newlines, followed
by the document content, The only obligatory header line is the
Content-type: <mime-type> header.
Printing can be done using any Prolog printing predicate, but the
format-family is the most useful. See format/2.   */

say_hi(_Request) :-
        format('Content-type: text/plain~n~n'),
        format('Hello World!~n').

say_taco(_Request) :-
        format('Content-type: text/plain~n~n'),
        format('Tacos are yummie!~n').


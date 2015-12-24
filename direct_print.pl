:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).

% Declare a handler, binding an HTTP path to a predicate.
% Here our path is / (the root) and the goal we'll query will be
% say_hi. The third argument is for options
:- http_handler('/', say_hi, []).

% The predicate server(+Port) starts the server. It simply creates a
% number of Prolog threads and then returns to the toplevel, so you can
% (re-)load code, debug, etc.
server(Port) :-
        http_server(http_dispatch, [port(Port)]).

/* The implementation of /. The single argument provides the request
details, which we ignore for now. Our task is to write a CGI-Document:
a number of name: value -pair lines, followed by two newlines, followed
by the document content, The only obligatory header line is the
Content-type: <mime-type> header.
Printing can be done using any Prolog printing predicate, but the
format-family is the most useful. See format/2.   */

say_hi(_Request) :-
        format('Content-type: text/html~n~n'),
        format('<html><head><title>Howdy</title></head><body><h2>A Simple Web Page</h2><p>With some text.</p></body></html>~n').

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).


:- use_module(library(http/http_log)).

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
Printing is done with reply_html_page, which handles the headers and
the head and body tags, the doctype, etc. */

say_hi(_Request) :-
	http_log('This works just like format ~w~n', ['Yeehaa']),
	reply_html_page(
	   [title('Howdy')],
	   [h1('A Simple Web Page'),
	    p('With some text')]).

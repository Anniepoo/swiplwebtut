:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).

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
Printing is done with print_html, which takes a list of tokens and
prints them. It attempts to 'reasonably' format html when it recognizes
tags. */

say_hi(_Request) :-
	phrase(
	    my_nonterm,
	    TokenizedHtml,
	    []),
        format('Content-type: text/html~n~n'),
	print_html(TokenizedHtml).

my_nonterm -->
	html([html([head([title('Howdy')]),
	           body([h1('A Simple Web Page'),
		      p('With some text')])])]).

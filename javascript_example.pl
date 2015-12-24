:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/js_write)).

:- http_handler('/', say_hi, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

/* The implementation of /. The single argument provides the request
details, which we ignore for now. Our task is to write a CGI-Document:
a number of name: value -pair lines, followed by two newlines, followed
by the document content, The only obligatory header line is the
Content-type: <mime-type> header.
Printing is done with reply_html_page, which handles the headers and
the head and body tags, the doctype, etc. */

say_hi(Request) :-
	reply_html_page(
	   [title('Howdy')],
	    [\page_content(Request)]).

page_content(_Request) -->
	{X = foo},
	html([
	    \html({|html(X)||<p>X</p>|}), % html quasiquote
	    \js_script({|javascript(X)|| console.log(X); |})
	]).


:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(anothermodule).

:- http_handler('/', say_hi, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

/* if you need a common style across pages, you can
   apply a 'style' */

say_hi(Request) :-
	reply_html_page(
	    tut_style,   % define the style of the page
	   [title('Howdy')],
	    [\page_content(Request)]).

page_content(_Request) -->
	html(
	   [
	    h2('Page Specific Header'),
	    p('with styling')
	   ]).


:- multifile
        user:body//2.

% Body will be included
user:body(tut_style, Body) -->
        html(body([ div(id(top), h1('The Simple Web Page Site')),
                    div(id(content), Body)
                  ])).

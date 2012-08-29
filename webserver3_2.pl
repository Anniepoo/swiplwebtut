:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).

% we need this module from the HTTP client library for http_read_data
:- use_module(library(http/http_client)).
:- http_handler('/', web_form, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

/*

browse http://127.0.0.1:8000/

This demonstrates handling POST requests
   */

web_form(_Request) :-
	reply_html_page(
	    title('POST demo'),
	    [
	     form([action='/landing', method='POST'], [
		p([], [
		  label([for=name],'Name:'),
		  input([name=name, type=textarea])
		      ]),
		p([], [
		  label([for=email],'Email:'),
		  input([name=email, type=textarea])
		      ]),
		p([], input([name=submit, type=submit, value='Submit'], []))
	      ])]).

:- http_handler('/landing', landing_pad, []).

landing_pad(Request) :-
        member(method(post), Request), !,
        http_read_data(Request, Data, []),
        format('Content-type: text/html~n~n', []),
	format('<p>', []),
        portray_clause(Data),
	format('</p><p>========~n', []),
	portray_clause(Request),
	format('</p>').



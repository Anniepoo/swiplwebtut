:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_parameters)).

:- http_handler('/', say_hi, []).

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

/*

browse http://127.0.0.1:8000/?baz=3&baz=4

This demonstrates handling parameters.
Not all type checking options are demonstrated, see
http://www.swi-prolog.org/pldoc/doc_for?object=section%283,%273.9%27,swi%28%27/doc/packages/http.html%27%29%29
   */

say_hi(Request) :-
	reply_html_page(
	   title('Howdy'),
	   [\page_content(Request)]).

page_content(Request) -->
	{
	 % catch because http_parameters throws if a param is invalid
	    catch(
	         http_parameters(Request,
				[
				 % default for a missing param
				 foo(Foo, [default(7)]),
				 % if bar param is missing Bar will be unbound
				 bar(Bar, [optional(true)]),
				 % allows the param to appear many times
				 % and binds Baz to a list of the occurances
				 % example.com/?baz=7&baz=9&baz=14
				 % nonneg here means each element must meet
				 % this criteria
				 % the list must contain at least one element
				 % or (annoyingly) it borts an error message
				 % (doesn't even throw)
				 baz(Baz, [list(nonneg)]),
				 mep(Mep, [length > 3, default(wimbly)])
				]),
	         _E,
	         fail),
	    !
	},
	html(
	   [
	    h1('Some Page'),
	    p('The body goes here'),
	    p('Foo is ~w'-Foo),
	    p('Bar is ~w'-Bar),
	    p('Baz is ~w'-Baz),
	    p('Mep is ~w'-Mep)
	   ]).

page_content(_Request) -->
	html(
	    [
	    h1('Oops!'),
	    p('Some parameter wasnt valid')
	    ]).


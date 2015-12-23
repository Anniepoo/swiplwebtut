:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(semweb/rdf_db)).
:- http_handler('/', say_hi, []).

:- rdf_register_prefix(elgin, 'http://theelginworks.com/rdf/').

:- setting(http:prefix, atom, '', "sdsf").

server(Port) :-
        http_server(http_dispatch, [port(Port)]).

/*
	Sometimes it's a lot easier to compute
	content in a place other than where it needs to be
	included in the html.
        A very common situation is including a page element
	that in turn requires something in the head, an extra
	css or js file, for example.
   for our example, lets say we have a nav bar we dynamicly generate
   and we want to have a small version of the nav bar at the bottom
   */

say_hi(Request) :-
	reply_html_page(
	   title('Howdy'),
	   [\page_content(Request)]).

page_content(_Request) -->
	html(
	   [
	    \rdf_ns(elgin),
	    h1('Demonstrating Mailman'),
	    div(\nav_bar),
	    p('The body goes here'),
	    div(\html_receive(bottom_nav))
	   ]).

rdf_ns(Id) -->
        { rdf_global_id(Id:'', Value) },
        xhtml_ns(Id, Value).


nav_bar -->
	{
	    findall(Name, nav(Name, _), ButtonNames),
	    maplist(as_top_nav, ButtonNames, TopButtons),
	    maplist(as_bottom_nav, ButtonNames, BottomButtons)
	},
	html([\html_post(bottom_nav, BottomButtons) | TopButtons]).


nav('Home', '/home').
nav('About', '/about').
nav('Recipes', '/recipes').

as_top_nav(Name, a([href=HREF, class=topnav], Name)) :-
	nav(Name, HREF).

as_bottom_nav(Name, a([href=HREF, class=bottomnav], Name)) :-
	nav(Name, HREF).

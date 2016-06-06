:- module(custom_404,
	  [ run/1
	  ]).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_header)).
:- use_module(library(http/html_write)).

:- http_handler(/, home, []).

/** <module> Customise the 404 page
Run this demo. Click the missing link.
*/

run(Port) :-
	http_server(http_dispatch, [port(Port)]).

home(_Request) :-
	reply_html_page(title('Custom 404 demo'),
			ul(li(a(href(i_do_not_exists),
				'Non existing page')))).

:- multifile http:status_page/3.

http:status_page(not_found(URL), _Context, HTML) :-
	phrase(page([ title('Sorry, no such page')
		    ],
		    {|html(URL)||
<h1>Sorry, no such page</h1>
<p>I'm afraid you asked for a page we do not have.  Please try the
search box to locate the page you are looking for.
		    |}),
	       HTML).


:- http_handler(root(throws), throws_handler, []).

http:status_page(server_error(Error), _Context, HTML) :-
	phrase(page([ title('Sorry Im Busted')
		    ],
		    {|html(Error)||
<h1>Dang, an error happened</h1>
<p>Oh fudge, error <b>Error</b> happened.</p>
		    |}),
	       HTML).

throws_handler(_Request) :-
	catch(
	    _ is 1 / 0,
	    E,
	    (	debug(status_page, '~w', [E]),
		throw(http_reply(server_error(E))))
	).
%	_ is 1 / 0.

http:status_page(Oops, _Context, _HTML) :-
	gtrace,
	debug(status_page, 'status ~w~n', [Oops]),
	fail.


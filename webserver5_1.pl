:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).

% from 1_3, if you've forgotten take a look
:- multifile http:location/3.
:- dynamic   http:location/3.

http:location(files, '/f', []).

% this handles a single path, /
:- http_handler(root(.), a_handler(root), []).
% this handles only /foo
:- http_handler(root(foo), a_handler(foo), []).

% this handles anything under /bar
% so it handles /bar/mep/meetzord
:- http_handler(root(bar), a_handler(barprefix), [prefix]).

% who handles /bar/mep/fnord?
% this one, because it's a refinement of /bar
:- http_handler(root('bar/mep/fnord'), a_handler(barmepfnord), []).

% Who wins this clash (both resolve to the same uri)?
% the last defined one
:- http_handler('/hoohaa', a_handler(uri_hoohaa), []).
:- http_handler(root('hoohaa'), a_handler(abstract_hoohaa), []).

%ooch, recall that they needn't be in the same file.
% So who wins? It's whoever's loaded last.  Best to explicitly set a
% priority. Default priority is zero.
%
% Now /numnums is handled by uri_numnums even though  abstract_numnums
% is below it, because it's priority is higher
:- http_handler('/f/numnums', a_handler(uri_numnums), [priority(10)]).
:- http_handler(files('numnums'), a_handler(abstract_numnums), []).

% Does that mess with the refinement rule?
% No, the rule is , refinement, then priority to disambiguate
:- http_handler(root('bar/moo'), a_handler(barmoo), [prefix, priority(10)]).
:- http_handler(root('bar/moo/waa'), a_handler(barmoowaa), []).


server(Port) :-
        http_server(http_dispatch, [port(Port)]).

a_handler(From, Request) :-
	member(request_uri(URI), Request),
	reply_html_page(
	   [title('Howdy')],
	   [h1('A Page'),
	    p('served from handler ~w'-[From]),
	    p('uri ~w'-[URI])]).




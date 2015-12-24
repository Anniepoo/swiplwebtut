:- module(upload, [ run/0]).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_mime_plugin)).
:- use_module(library(http/http_client)).
:- use_module(library(http/html_write)).
:- use_module(library(lists)).

:- http_handler(root(.),	upload_form, []).
:- http_handler(root(upload),	upload,      []).

run :-
	http_server(http_dispatch, [port(8080)]).

upload_form(_Request) :-
	reply_html_page(
	    title('Upload a file'),
	    [ h1('Upload a file'),
	      form([ method('POST'),
		     action(location_by_id(upload)),
		     enctype('multipart/form-data')
		   ],
		   table([],
			 [ tr([td(input([type(file), name(file)]))]),
			   tr([td(align(right),
				  input([type(submit), value('Upload!')]))])
			 ]))
	    ]).

upload(Request) :-
	(   memberchk(method(post), Request),
	    http_read_data(Request, Parts, [form_data(mime)]),
	    member(mime(Attributes, Data, []), Parts),
	    memberchk(name(file), Attributes),
	    memberchk(filename(Target), Attributes)
	->  % process file here; this demo just prints the info gathered
	    atom_length(Data, Len),
	    format('Content-type: text/plain~n~n'),
	    format('Need to store ~D characters into file \'~w\'~n',
		   [ Len, Target ])
	;   throw(http_reply(bad_request(bad_file_upload)))
	).

:- multifile prolog:message//1.

prolog:message(bad_file_upload) -->
	[ 'A file upload must be submitted as multipart/form-data using', nl,
	  'name=file and providing a file-name'
	].

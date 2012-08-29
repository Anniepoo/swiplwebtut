:- module(anothermodule, [stuff_in_other_module//0]).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).

stuff_in_other_module -->
	html(p('this is from the other module')).

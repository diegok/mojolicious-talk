#!/usr/bin/env perl
use Mojolicious::Lite;
plugin 'haml_renderer';

app->secret('dk');

get '/' => 'hello';

app->start;

__DATA__

@@ hello.html.haml
% layout test
!!!
  %html
    %body
      %article
        #main
          %h1 Hello, world!
          %h2 Here we are
        #footer.dark
          %ul
            %li item 1
            %li item 2
            %li item 3


#!/usr/bin/env perl

use Mojolicious::Lite;

get '/' => sub { 
    shift->render( json => { 
        title    => 'Mojolicious 1.0', 
        subtitle => [ 
            'The web in a box', 
            'Duct Tape For The HTML5 Web' 
        ],
        where    => 'Barcelona.pm',
        when     => '30/12/2010',
        who      => 'diegok'
    }); 
};

app->start;


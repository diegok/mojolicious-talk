#!/usr/bin/env perl

use Mojolicious::Lite;

get '/' => sub { 
    shift->render( json => { 
        title    => 'Mojolicious', 
        subtitle => [ 
            'The web in a box', 
            'Duct Tape For The HTML5 Web' 
        ],
        where    => 'Barcelona on rails',
        when     => '21/06/2012',
        who      => 'diegok'
    }); 
};

app->start;


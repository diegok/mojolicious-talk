#!/usr/bin/env perl
use Mojolicious::Lite;
plugin 'pod_renderer';

get '/welcome' => sub { shift->render('index') };
get '/' => sub { shift->render( text => 'Hello World!' ) };
get '/hello/:nombre' => \&hello;
post '/hello'        => \&hello;
app->start;

sub hello { 
    my $self = shift;
    my $name = $self->param('nombre');
    $self->render( text => "Hello $name!" ); 
};


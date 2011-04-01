#!/usr/bin/env perl

use feature "switch";
use Mojolicious::Lite;
use Mojo::JSON;

my $json  = Mojo::JSON->new;
my $peers = {};

get '/' => 'index';

websocket '/msgs' => sub {
    my $self = shift;

    my $ws_key = $self->tx .'';
    $peers->{$ws_key}{tx}   = $self;
    $peers->{$ws_key}{nick} = 'Anon-' . scalar( keys %$peers );
    $peers->{$ws_key}{time} = time;

    $self->on_message( sub {
        my ($self, $message) = @_;
        my $data = $json->decode( $message );
           $data->{peer_id} = $ws_key;
        dispatch_message( $data );
    });

    $self->on_finish( sub {
        my $self = shift;
        broadcast(
            $json->encode({ 
                type => 'disconnect', 
                nick => $peers->{$ws_key}{nick},
                time => time
            })
        );
        delete $peers->{$ws_key};
    });

    broadcast(
        $json->encode({ 
            type => 'connect', 
            nick => $peers->{$ws_key}{nick},
            time => $peers->{$ws_key}{time} 
        })
    );
};

sub broadcast {
    my $data = shift;

    for my $peer ( keys %$peers ) {
        $peers->{$peer}{tx}->send_message($data);
    }
}

sub dispatch_message {
    my $input = shift;

    given ($input->{type}) {
        when ('msg')  { 
            if ( $input->{value} =~ m|^/([a-z]+)\s+([^/].*)$| ) {
               $input->{type}  = $1;
               $input->{value} = $2;
               dispatch_message($input);
            }
            else {
                _message($input) 
            }
        }
        when ('nick') { _nick($input) }
    }
}

sub _message {
    my $input = shift;

    broadcast(
        $json->encode({
            type  => 'msg',
            from  => $peers->{$input->{peer_id}}{nick} || 'Anonymous',
            value => $input->{value},
            time  => time
        })
    );
}

sub _nick {
    my $input = shift;

    my $output = $json->encode({
        type  => 'nick',
        value => $input->{value},
        old   => $peers->{$input->{peer_id}}{nick},
        time  => time
    });

    $peers->{$input->{peer_id}}{nick} = $input->{value};
    broadcast($output);
}

app->start;

__DATA__

@@ index.html.ep
<!doctype html>
<html>
    <head>
        <title>Chat - WebSockets</title>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
        <script src="http://jquery-json.googlecode.com/files/jquery.json-2.2.min.js"></script>
        <script type="text/javascript" src="/js/chat.js"></script>
        <link rel="stylesheet" href="/css/screen.css" type="text/css" media="screen"/> 
    </head>
    <body>
        <div id="chatbox">
            <div id="live">
                <div id="peers"></div>
                <div id="msgs"><p>Connecting...</p></div>
            </div>
            <div id="write"><input type="text"/><a href="send">Send</a></div>
        </div>
    </body>
</html>

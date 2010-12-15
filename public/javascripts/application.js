NODEWISE = {
  common: {
    init: function() {
      // application-wide code
    }
  },

  users: {
    init: function() {
      // controller-wide code
    },

    show: function() {
      // action-specific code
    }
  }
};

UTIL = {
  exec: function( controller, action ) {
    var ns = NODEWISE,
        action = ( action === undefined ) ? "init" : action;

    if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) {
      ns[controller][action]();
    }
  },

  init: function() {
    var body = document.body,
        controller = body.getAttribute( "data-controller" ),
        action = body.getAttribute( "data-action" );

    UTIL.exec( "common" );
    UTIL.exec( controller );
    UTIL.exec( controller, action );
  }
};

$(document).ready( UTIL.init );

$(document).ready(function () {
  if (window.console === undefined) {
    var mdiv = $('<div></div>'); $('body').append(mdiv);
    window.console = {log: function(msg){ mdiv.html( mdiv.html() + "<br>" + msg ) }};
  }

  $('.flash').delay(2000).fadeOut(1000);
});

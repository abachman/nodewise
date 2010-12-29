NODEWISE = {
  common: {
    init: function() {
      // application-wide code

      if (window.console === undefined) {
        var mdiv = $('<div></div>'); $('body').append(mdiv);
        window.console = {log: function(msg){ mdiv.html( mdiv.html() + "<br>" + msg ) }};
      }

      MESSAGING.initFlash();
    }
  },

  users: {
    init: function() {
      // controller-wide code
    },

    index: function () {

    },

    show: function() {
      // action-specific code
    }
  },

  finances: {
    init: function () {
      linkToReport('All', '1910-01-01');
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

$(document).ready(UTIL.init);

MESSAGING = {};
(function (klass) {
  klass.initFlash = function () {
    var flash = $('.flash');
    this.showFlashMessage(flash);
  };

  klass.initFlashBehavior = function (flash) {
    $('.close', flash).click(function () {
      flash.remove();
      return false;
    });
  };

  klass.showFlashMessage = function (flash) {
    flash.show();
    this.initFlashBehavior(flash);
  };
})(MESSAGING);

function showMessage(level, msg) {
  var flash = $("<div class='flash' id='flash_" + level + "'></div>").html(msg);
  $('.flash_wrapper').append(flash);
  $(flash).append("<a href='#' class='close'>X</a>");
  MESSAGING.showFlashMessage(flash);
}

function linkToReport(text, date) {
  $('#invoice_report_status').show();
  $.ajax({
    url: '<%= report_invoices_path %>',
    data: {from_date: date, link: text},
    dataType: 'script',
    success: function () {
      $('#invoice_report_status').fadeOut();

      // reset all
      $("#report_links a").show();
      $("#report_links .label").hide();

      // set specific
      $("#report_links a:contains('"+ text +"')").hide();
      $("#report_links .label:contains('"+ text +"')").show();
    }
  });
  return false;
}


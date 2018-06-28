// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require popper
//= require jquery
//= require rails-ujs
//= require turbolinks
//= require bootstrap
//= require footable.min
//= require jquery.maskedinput.min
//= require trix
//= require jquery.datetimepicker
//= require nprogress

var ready = function(){
    $('.table').footable();

    $('.datetimepicker').datetimepicker({
        format: $('.datetimepicker').data('format'),
        step: 60,
        lang: 'tr',
        minDate: 0,
        defaultTime: '12:00'
    });

    $(function () {
        $('[data-toggle="tooltip"]').tooltip();
    });

    $("[data-mask]").each(function(index, element) {
        var $element;
        $element = $(element);
        $element.mask($element.data('mask'));
    });
    $('form[data-turboform]').on('submit', function(e) {
        Turbolinks.visit(this.action + (this.action.indexOf('?') === -1 ? '?' : '&') + $(this).serialize());
        return false;
    });
};

document.addEventListener("turbolinks:load", ready);

$(window).on('page:load', ready);

$(document).on('page:fetch', function() {
    NProgress.start();
});

$(document).on('page:change', function() {
    NProgress.done();
});

$(document).on('page:restore', function() {
    NProgress.remove();
});

$(document).ajaxStart(function() {
    NProgress.start();
});

$(document).ajaxComplete(function() {
    NProgress.done();
});


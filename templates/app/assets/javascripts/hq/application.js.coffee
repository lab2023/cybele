# This is a manifest file that will be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require bootstrap
#= require hierapolis
#= require chosen-jquery
#= require jquery.maskedinput.min
#= require trix
#= require jquery.datetimepicker
#= require nprogress


class @App
  @tooltip = ->
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="toolbar-tooltip"]').tooltip()

  @ready = ->
    App.tooltip()

    $('.chosen-select').chosen
      allow_single_deselect: true
      placeholder_text: $('.chosen-select').attr('include_blank')

    $('.chosen-select-with-width').chosen
      allow_single_deselect: true
      placeholder_text: $('.chosen-select-with-width').attr('include_blank')
      width: '370px'

    $('.changeable_select').on 'change', ->
      $hiden_area = $($('#hider-id').data('hiden-area'))
      values = $('#hider-id').data('hiden-on').split(',')
      if $.inArray($(this).val(), values) != -1
        $hiden_area.addClass('hidden')
      else
        $hiden_area.removeClass('hidden')

ready = ->
  App.ready()

  $('.datetimepicker').datetimepicker
    format: $('.datetimepicker').data('format')
    step: 60
    lang: 'tr'
    minDate: 0
    defaultTime: '12:00'

  $( "[data-mask]").each (index, element) ->
    $element = $(element)
    $element.mask($element.data('mask'))

  $('form[data-turboform]').on('submit', (e) ->
    Turbolinks.visit @action + (if @action.indexOf('?') == -1 then '?' else '&') + $(this).serialize()
    false
  )

$(document).ready(ready)
$(document).on('page:load', ready)
$(window).on('page:load', ready)


# Turbolinks.enableProgressBar()
# Turbolinks events
$(document).on 'page:fetch', ->
  NProgress.start()
  return
$(document).on 'page:change', ->
  NProgress.done()
  return
$(document).on 'page:restore', ->
  NProgress.remove()
  return
# jQuery events
# Trigger whenever ajax start
$(document).ajaxStart ->
  NProgress.start()
  return
# Complete the NProcess when ajax end
$(document).ajaxComplete ->
  NProgress.done()
  return
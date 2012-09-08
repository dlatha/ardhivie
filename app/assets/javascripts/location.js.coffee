class window.Ardhiview.Location
  
  _location_id: null
  _marker: null
  _infoWindow: null
  _latitude: null
  _longitude: null
  _address: null
  _title: null
  _saved: false
  # construt with {latitude: <>, longitude: <>, title: <>, address: <>}
  constructor: (location, newLocation) ->
    @_latitude = location.latitude
    @_longitude = location.longitude
    @_address = location.address
    @_title = location.title
    
    @_initMarker()
    if newLocation?
      @_initNewLocationForm()
  
  saved: (location_id)->
    @_saved = true
    @_location_id = location_id
    $('#new-location-form').modal('hide')
    @_initInfoWindow()
    @_infoWindow.open Ardhiview.map().googleMap, @_marker
  
  destroy: ->
    @_marker.setMap null
  
  showWindow: ->
    
  hideWindow: ->

  # private methods
  _initMarker: ->
    @_marker = new google.maps.Marker {
      map: Ardhiview.map().googleMap
      position: new google.maps.LatLng @_latitude, @_longitude
    }
    $(@_marker).data("location", this)

    google.maps.event.addListener @_marker, 'click', =>
      @showWindow()
  
  _initInfoWindow: ->
    @_infoWindow = new google.maps.InfoWindow {
      content: @_getForm()
    }
    
    google.maps.event.addListener @_infoWindow, 'closeclick', =>
      @hideWindow()
    
  _getForm: ->
    return tmpl("template-ufile-form",{location_id: @_location_id})
  
  _initNewLocationForm: ->
    $('#new-location-form').data("location", this)
    $('#location_address').val @_address
    $('#location_latitude').val @_latitude
    $('#location_longitude').val @_longitude
    $('#new-location-form .location-display-lat').text (Math.round(@_latitude*10)/10).toFixed(2)
    $('#new-location-form .location-display-lng').text (Math.round(@_longitude*10)/10).toFixed(2)
    setTimeout ->
      $('#new-location-form').modal('show')
    , '200'
    $('#new-location-form').on 'hidden', =>
      unless @_saved
        Ardhiview.map()._removeNewLocation()
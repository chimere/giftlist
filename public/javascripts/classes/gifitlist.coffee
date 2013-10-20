class window.GiftList
 constructor: ->
   @gifts = new GLGift if @domContains '.gifts li'

 domContains: (selectors...)->
   all_match = true
   $.each selectors, (index, item) ->
     all_match = false if $(item).length is 0
   all_match

 domDoesntContain: (selectors...)->
   none_found = true
   $.each selectors, (index, item) ->
     none_found = false if $(item).length isnt 0
   none_found
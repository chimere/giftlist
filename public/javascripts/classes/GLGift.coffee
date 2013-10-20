class window.GLGift
  constructor:->
    @giftLinks   = $ '.gifts li'
    @bindVariables @giftLinks

  bindVariables: ->
    @giftLinks.on 'click', @actionClick

  actionClick: (event) ->
    event.preventDefault()
    product_id = event.currentTarget.parent('li').data('gift')
    @incrementClicks product_id

  incrementClicks: (product_id) ->
    $.post
      url: '/gift/clicks/increment'
      data:
        gift: 
          id: product_id
      type: 'POST'
      success: (response) ->
        console.log response.body
      error: (error) ->
        console.log error.code, error.message
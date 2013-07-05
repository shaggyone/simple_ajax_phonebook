class PhoneBook
  constructor: (element) ->
    @element = $(element)
    @index_element = @element.find('.Index')
    @item_template = @element.find(@index_element.data('template')).html()
    @form_element = @element.find('.Form')

    @current_entry = {}
    @current_element = null

    @bind_event_handlers()

  index: ->
    $.ajax('/phone_book_entries', context: this).done (data)->
      for entry in data['phone_book_entries']
        @append_entry(entry)

  edit_entry: (entry) ->
    data.value

  select_element: (element) ->
    @current_entry = element.data('value')

    for name, value of @current_entry
     @form_element.find("[name='phone_book_entry[#{name}]']").val(value)

  append_entry: (entry) ->
    appended_element = $(_.template(@item_template, entry, { variable: 'phone_book_entry' }))
    appended_element.data('value', entry)

    @index_element.append(appended_element)

  bind_event_handlers: ->
    @form_element.on 'submit', $.proxy(@on_form_submit, this)
    @index_element.on 'click', '.Edit', $.proxy(@on_edit_clicked, this)

  on_edit_clicked: (e) ->
    @select_element $(e.currentTarget).parents('tr:first')

    false


  on_form_submit: ->
    $.ajax('/phone_book_entries', context: this, data: @form_element.serialize(), method: 'post').done (data)->
      if data.valid
        @append_entry(data)
        @form_element.find('*').removeClass('error')
        @form_element.get(0).reset()
      else
        for name, error of data.errors
          @form_element.find("[name='phone_book_entry[#{name}]']").addClass('error')
      return
    false

@phone_book = new PhoneBook($('#PhoneBook'))
@phone_book.index()





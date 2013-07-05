class PhoneBook
  constructor: (element) ->
    @element = $(element)
    @index_element = @element.find('.Index')
    @item_template = @element.find(@index_element.data('template')).html()
    @create_form_element = @element.find('.CreateForm')

    @bind_event_handlers()

  index: ->
    $.ajax('/phone_book_entries', context: this).done (data)->
      for entry in data['phone_book_entries']
        @append_entry(entry)

  append_entry: (entry) ->
    appended_element = $(_.template(@item_template, entry, { variable: 'phone_book_entry' }))
    appended_element.data('value', entry)

    @index_element.append(appended_element)

  bind_event_handlers: ->
    @create_form_element.on 'submit', $.proxy(@on_create_form_submit, this)

  on_create_form_submit: ->
    $.ajax('/phone_book_entries', context: this, data: @create_form_element.serialize(), method: 'post').done (data)->
      if data.valid
        @append_entry(data)
        @create_form_element.find('*').removeClass('error')
        @create_form_element.get(0).reset()
      else
        for name, error of data.errors
          @create_form_element.find("[name='phone_book_entry[#{name}]']").addClass('error')
      return
    false

# class Form
#   constructor: (@element) ->

@phone_book = new PhoneBook($('#PhoneBook'))
@phone_book.index()





class PhoneBook
  constructor: (element) ->
    @element = $(element)
    @index_element = @element.find('.Index')
    @item_template = @element.find(@index_element.data('template')).html()
    @form_element = @element.find('.Form')

    @select_element null

    @bind_event_handlers()

  index: ->
    $.ajax('/phone_book_entries', context: this).done (data)->
      for entry in data['phone_book_entries']
        @append_entry(entry)

  select_element: (element) ->
    @current_element = element
    if !!element
      @current_entry = element.data('value')
    else
      @current_entry = {}

    for name, value of _.extend({full_name: '', phone_number: ''}, @current_entry)
     @form_element.find("[name='phone_book_entry[#{name}]']").val(value)

  destroy_element: (element) ->
    @select_element null

    if window.confirm('Remove the entry?')
      entry = element.data('value')
      $.ajax("/phone_book_entries/#{entry.id}", context: this, type: 'delete').done (data) ->
        element.remove()

  replace_entry: (entry) ->
    @current_element.replaceWith(@prepare_entry_element(entry))

  append_entry: (entry) ->
    @index_element.append(@prepare_entry_element(entry))

  append_or_replace_entry: (entry) ->
    if !!@current_element
      @replace_entry entry
    else
      @append_entry entry


  prepare_entry_element: (entry) ->
    appended_element = $(_.template(@item_template, entry, { variable: 'phone_book_entry' }))
    appended_element.data('value', entry)

    appended_element


  bind_event_handlers: ->
    @form_element.on 'submit', $.proxy(@on_form_submit, this)
    @index_element.on 'click', '.Edit', $.proxy(@on_edit_clicked, this)
    @index_element.on 'click', '.Destroy', $.proxy(@on_destroy_clicked, this)

  on_edit_clicked: (e) ->
    @select_element $(e.currentTarget).parents('tr:first')

    false


  on_destroy_clicked: (e) ->
    @destroy_element $(e.currentTarget).parents('tr:first')

    false


  on_form_submit: ->
    $.ajax("/phone_book_entries/#{@current_entry.id || ''}", context: this, data: @form_element.serialize(), type: (if !!@current_entry.id then 'put' else 'post')).done (data)->
      if data.valid
        @append_or_replace_entry(data)
        @form_element.find('*').removeClass('error')
        @form_element.get(0).reset()

        @current_entry = {}
        @current_element = null
      else
        for name, error of data.errors
          @form_element.find("[name='phone_book_entry[#{name}]']").addClass('error')
      return
    false

@phone_book = new PhoneBook($('#PhoneBook'))
@phone_book.index()





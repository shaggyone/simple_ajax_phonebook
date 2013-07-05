class PhoneBook
  constructor: (element) ->
    @element = $(element)
    @index_element = @element.find('.Index')
    @item_template = @element.find(@index_element.data('template')).html()

  index: ->
    $.ajax('/phone_book_entries', context: this).done (data)->
      for entry in data['phone_book_entries']
        @append_entry(entry)

  append_entry: (entry) ->
    appended_element = $(_.template(@item_template, entry, { variable: 'phone_book_entry' }))
    appended_element.data('value', entry)

    @index_element.append(appended_element)

@phone_book = new PhoneBook($('#PhoneBook'))
@phone_book.index()





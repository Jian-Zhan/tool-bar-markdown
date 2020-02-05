{ CompositeDisposable } = require 'atom'

module.exports =
  buttons: [
    {
      'icon': 'file-send'
      'tooltip': 'Save File'
      'callback': 'core:save'
    }
    { 'type': 'separator' }
    {
      'icon': 'sitemap'
      'tooltip': 'Toggle Tree View'
      'callback': 'tree-view:toggle'
    }
    {
      'icon': 'markdown'
      'tooltip': 'Preview Markdown'
      'callback': 'markdown-preview-enhanced:toggle'
    }
    {
      'icon': 'table-of-contents'
      'tooltip': 'Toggle Outline'
      'callback': 'document-outline:toggle'
    }
    { 'type': 'separator' }
    {
      'icon': 'format-bold'
      'tooltip': 'Bold'
      'callback': 'markdown-writer:toggle-bold-text'
    }
    {
      'icon': 'format-italic'
      'tooltip': 'Italic'
      'callback': 'markdown-writer:toggle-italic-text'
    }
    {
      'icon': 'code-tags'
      'tooltip': 'Code Block'
      'callback': 'markdown-writer:toggle-codeblock-text'
    }
    { 'type': 'separator' }
    {
      'icon': 'format-list-bulleted'
      'tooltip': 'Unordered List'
      'callback': 'markdown-writer:toggle-ul'
    }
    {
      'icon': 'format-list-numbers'
      'tooltip': 'Ordered List'
      'callback':
        '': 'markdown-writer:toggle-ol'
        'shift': 'markdown-writer:correct-order-list-numbers'
    }
    { 'type': 'separator' }
    {
      'icon': 'format-header-1'
      'tooltip': 'Heading 1'
      'callback': 'markdown-writer:toggle-h1'
    }
    {
      'icon': 'format-header-2'
      'tooltip': 'Heading 2'
      'callback': 'markdown-writer:toggle-h2'
    }
    {
      'icon': 'format-header-3'
      'tooltip': 'Heading 3'
      'callback': 'markdown-writer:toggle-h3'
    }
    { 'type': 'separator' }
    {
      'icon': 'format-header-decrease'
      'tooltip': 'Jump to Previous Heading'
      'callback': 'markdown-writer:jump-to-previous-heading'
    }
    {
      'icon': 'format-header-increase'
      'tooltip': 'Jump to Next Heading'
      'callback': 'markdown-writer:jump-to-next-heading'
    }
    { 'type': 'separator' }
    {
      'icon': 'table'
      'tooltip': 'Insert Table'
      'callback': 'markdown-writer:insert-table'
    }
    {
      'icon': 'table-edit'
      'tooltip': 'Format Table'
      'callback': 'markdown-writer:format-table'
    }
    { 'type': 'separator' }
    {
      'icon': 'link-variant'
      'tooltip': 'Insert Link'
      'callback':
        '': 'markdown-writer:insert-link'
        'shift': 'markdown-writer:open-link-in-browser'
    }
    {
      'icon': 'image'
      'tooltip': 'Insert Image'
      'callback': 'markdown-writer:insert-image'
    }
  ]

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar('tool-bar-md')

    for button in @buttons
      if button['type'] == 'separator'
        @toolBar.addSpacer()
      else
        @toolBar.addButton(
          icon: button['icon']
          callback: button['callback']
          tooltip: button['tooltip']
          iconset: button['iconset'] || 'mdi')

  deactivate: ->
    @toolBar?.removeItems()

{ CompositeDisposable } = require 'atom'

module.exports =
  config:
    visibility:
      type: 'string'
      default: 'showButtonsOnMarkdown'
      description: 'Configure toolbar visibility behaviour'
      enum: [
        'showToolbarOnMarkdown'
        'showButtonsOnMarkdown'
        'showButtonsOnAll'
      ]
    grammars:
      type: 'array'
      default: [
        'source.gfm'
        'source.gfm.nvatom'
        'source.litcoffee'
        'text.md'
        'text.plain'
        'text.plain.null-grammar'
      ]
      description: 'Valid file type grammars'
    critic_markup:
      type: 'boolean',
      default: false,
      description: 'Configure Critic Markup toolbar buttons visibility behaviour'

  buttons: [
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
    {
      'type': 'separator'
      'option': 'criticmarkup'
    }
    {
      'icon': 'addition'
      'tooltip': 'CriticMarkup Addition'
      'callback': 'markdown-writer:toggle-addition-text'
      'option': 'criticmarkup'
      'iconset': 'criticmarkup'
    }
    {
      'icon': 'deletion'
      'tooltip': 'CriticMarkup Deletion'
      'callback': 'markdown-writer:toggle-deletion-text'
      'option': 'criticmarkup'
      'iconset': 'criticmarkup'
    }
    {
      'icon': 'substitution'
      'tooltip': 'CriticMarkup Substitution'
      'callback': 'markdown-writer:toggle-substitution-text'
      'option': 'criticmarkup'
      'iconset': 'criticmarkup'
    }
    {
      'icon': 'comment'
      'tooltip': 'CriticMarkup Comment'
      'callback': 'markdown-writer:toggle-comment-text'
      'option': 'criticmarkup'
      'iconset': 'criticmarkup'
    }
    {
      'icon': 'highlight'
      'tooltip': 'CriticMarkup Highlight'
      'callback': 'markdown-writer:toggle-highlight-text'
      'option': 'criticmarkup'
      'iconset': 'criticmarkup'
    }
  ]

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar('tool-bar-md')
    # cleaning up when tool bar is deactivated
    @toolBar.onDidDestroy => @toolBar = null
    # display buttons
    @addButtons()

  isCriticMarkupEnabled: ->
    return atom.config.get('tool-bar-md.critic_markup')

  hideOptionalCriticMarkupButton: (button) ->
    return button['option'] == 'criticmarkup' and not @isCriticMarkupEnabled()

  addButtons: ->
    return unless @toolBar?

    for button in @buttons
      if @hideOptionalCriticMarkupButton(button)
        continue

      if button['type'] == 'separator'
        @toolBar.addSpacer()
      else
        callback = button['callback']
        callback = button['visible'](button['data']) if button['visible']?
        continue unless callback

        @toolBar.addButton(
          icon: button['icon']
          data: button['data']
          callback: callback
          tooltip: button['tooltip']
          iconset: button['iconset'] || 'mdi')

  removeButtons: -> @toolBar?.removeItems()

  updateToolbarVisible: (visible) ->
    atom.config.set('tool-bar.visible', visible)

  isToolbarVisible: -> atom.config.get('tool-bar.visible')

  isMarkdown: ->
    editor = atom.workspace.getActiveTextEditor()
    return false unless editor?

    grammars = atom.config.get('tool-bar-md.grammars')
    return grammars.indexOf(editor.getGrammar().scopeName) >= 0

  activate: ->
    require('atom-package-deps')
      .install('tool-bar-md', true)
      .then(=> @activateBar())

  activateBar: ->
    @subscriptions = new CompositeDisposable()
    @subscriptions.add atom.workspace.onDidStopChangingActivePaneItem (item) =>
      visibility = atom.config.get('tool-bar-md.visibility')

      if @isMarkdown()
        @removeButtons()
        @addButtons()
        @updateToolbarVisible(true) if visibility == 'showToolbarOnMarkdown'
      else if @isToolbarVisible()
        if visibility == 'showButtonsOnMarkdown'
          @removeButtons()
        else if visibility == 'showToolbarOnMarkdown'
          @updateToolbarVisible(false)

  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null
    @removeButtons()

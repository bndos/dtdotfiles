import dracula.draw

config.load_autoconfig()

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    },
    'font': {
        'family': 'Monego',
        'size': 12
    }
})

c.tabs.position = "left"
c.tabs.show = "switching"
c.tabs.width = 230
c.tabs.show_switching_delay=1200
c.scrolling.bar = "never"
c.statusbar.hide = True
c.completion.shrink = True
config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
config.bind('<Ctrl-p>', 'completion-item-focus prev', mode='command')

config.bind('<Alt-n>', 'command-history-next', mode='command')
config.bind('<Alt-p>', 'command-history-prev', mode='command')

config.bind('yx','spawn mpv {url}')
config.bind('yf', 'hint links spawn mpv {hint-url}')

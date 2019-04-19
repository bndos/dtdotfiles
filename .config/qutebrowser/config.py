import dracula.draw

config.load_autoconfig()

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    },
    'font': {
        'family': 'MonacoB2',
        'size': 13
    }
})

c.tabs.position = "left"
c.tabs.show = "switching"
c.tabs.width = 230
c.tabs.show_switching_delay=1200
c.statusbar.hide = True
c.completion.shrink = True

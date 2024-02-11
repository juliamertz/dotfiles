from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import colors
import utils

mod = "mod4"

def go_to_group(name: str):
    def _inner(qtile):
        if len(qtile.screens) == 1:
            qtile.groups_map[name].toscreen()
            return

        if name in '1234':
            qtile.focus_screen(0)
            qtile.groups_map[name].toscreen()
        else:
            qtile.focus_screen(1)
            qtile.groups_map[name].toscreen()

    return _inner

keys = [
    Key([mod], "Return", lazy.spawn("kitty"), desc="Launch terminal"),
    Key([mod, "shift"], "s", lazy.spawn("spotify")),
    Key([mod, "shift"], "w", lazy.spawn("firefox")),
    Key([mod, "shift"], "e", lazy.spawn("code")),
    Key([mod, "shift"], "m", lazy.spawn("firefox --new-tab https://mail.proton.me/u/0/inbox")),

    Key([mod], "r", lazy.spawn("/home/joris/.config/rofi/launcher/launcher.sh")),
    Key([mod], "home", lazy.spawn("/home/joris/.config/rofi/displaymenu/start.sh")),
    Key([mod], "end", lazy.spawn("/home/joris/.config/rofi/powermenu/powermenu.sh")),
    Key([mod], "print", lazy.spawn("/home/joris/.config/rofi/screenshotmenu/start.sh")),
    Key([mod], "o", lazy.spawn("/home/joris/.config/rofi/audiomenu/start.py")),

    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),

    Key([mod], "i", lazy.layout.grow()),
    Key([mod], "m", lazy.layout.shrink()),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod, "mod1"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "mod1"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "mod1"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "mod1"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    
    # Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    # Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    # Key([mod, "mod1"], "h", lazy.layout.flip_left()),
    # Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

groups = [
    Group(name="1", screen_affinity=0, layout="columns"),
    Group(name="2", screen_affinity=0, layout="columns"),
    Group(name="3", screen_affinity=0, layout="columns"),
    Group(name="4", screen_affinity=1, layout="max", spawn="/usr/bin/spotify"),
    Group(name="5", screen_affinity=1, layout="monadwide"),
    Group(name="6", screen_affinity=1, layout="monadwide"),
    Group(name="7", screen_affinity=1, layout="monadwide"),
    Group(name="8", screen_affinity=1, layout="monadwide"),
]

for i in groups:
    keys.append(Key([mod], i.name, lazy.function(go_to_group(i.name))))

styles = {
    "border_width": 2,
    "border_normal": colors.highlightMed,
    "border_focus": colors.love,
}

layouts = [
    layout.Columns(
        **styles,
        margin=5,
    ),
    layout.Max(),
    layout.MonadWide(
        **styles,
        margin=10,
    ),
    # layout.MonadTall(
    #     **styles,
    #     margin=10,
    # ),
    # layout.Bsp(
    #     **styles,
    #     margin=5,
    # ),
    # layout.Stack(
    #     **styles,
    #     margin= 5,
    # ),
    # layout.Stack(num_stacks=2),
    # layout.Matrix(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                # widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": (colors.love, "#ffffff"),
                    },
                ),
                widget.StatusNotifier(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
            ],
            background=utils.add_opacity_to_hex(colors.base, 50),
            size=30,
            margin=[10, 15, 5, 15],
            # border_width=2,
            # border_color=colors["overlay"] 
        ),
    bottom=bar.Gap(10),
    left=bar.Gap(10),
    right=bar.Gap(10),
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = False

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])
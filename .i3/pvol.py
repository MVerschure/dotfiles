#!/usr/bin/env python2

# pvol -- Commandline audio volume utility
#         with an optional GTK progressbar
# Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
# Modified by 2011 Reza Jelveh

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.


import gtk
import gobject
import optparse
import ossaudiodev
import alsaaudio

appname = "Pvol"
appicon = "/usr/share/icons/ubuntu-mono-light/status/24/" \
    + "audio-volume-high-panel.svg"


class AlsaMixer():

    def __init__(self, pcm=False, mute=False, arg=None):
        self.mixer = alsaaudio.Mixer()
        self.percent = self.mixer.getvolume()[0]
        self.label = "Volume: "  # % name
        if arg:
            self.percent = min(100, max(0, self.percent + int(arg)))
            self.mixer.setvolume(self.percent)
        if mute:
            mutestate = self.mixer.getmute()[0]
            if mutestate:
                self.label = "Unmuted: "
            else:
                self.label = "Muted: "

            self.mixer.setmute(mutestate ^ 1)
        self.label = self.label + "%.0f%%" % self.percent


class OssMixer():

    def __init__(self, pcm=False, adj=False, arg=None):
        self.mixer = ossaudiodev.openmixer()
        get, set = self.mixer.get, self.mixer.set

        self.channels = [['MASTER', ossaudiodev.SOUND_MIXER_VOLUME],
                         ['PCM', ossaudiodev.SOUND_MIXER_PCM]]

        if pcm:
            self.channels.insert(0, self.channels.pop())

        name, channel = self.channels[0]
        self.label = "Volume: "  # % name

        # There is no simple way to toggle mute on a channel with ossaudiodev?
        if adj:
            if arg == -100:
                if not get(channel)[0]:
                    # Copy the PCM channel
                    # arg = get(self.channels[1][1])[0]
                    # Set to a pre-defined value
                    arg = 94
                    self.label = "Unmuted: "
                else:
                    self.label = "Muted: "
            arg = min(100, max(0, get(channel)[0] + int(arg)))
            set(channel, (arg, arg))

        self.percent = get(channel)[0]
        self.label = self.label + "%.0f%%" % self.percent

        self.mixer.close()


class Pvol:

    def __init__(self, fraction, label, wmname=appname):
        self.window = gtk.Window(gtk.WINDOW_POPUP)
        self.window.set_title(wmname)
        self.window.set_border_width(1)
        self.window.set_default_size(180, -1)
        self.window.set_position(gtk.WIN_POS_CENTER)

        self.window.connect("destroy", lambda x: gtk.main_quit())
        self.timer = gobject.timeout_add(2000, lambda: gtk.main_quit())

        self.widgetbox = gtk.HBox()

        self.icon = gtk.Image()
        self.icon.set_from_file(appicon)
        self.icon.show()

        self.progressbar = gtk.ProgressBar()
        self.progressbar.set_orientation(gtk.PROGRESS_LEFT_TO_RIGHT)
        self.progressbar.set_fraction(float(fraction) / 100)
        self.progressbar.set_text(label)

        self.widgetbox.pack_start(self.icon)
        self.widgetbox.pack_start(self.progressbar)
        self.window.add(self.widgetbox)
        self.window.show_all()


def main():
    usage = "%prog [-s] [-m] [-c PERCENT] [-p] [-q]"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option(
        '-s',
        '--status',
        action='store_true',
        dest='status',
        help='display current volume')
    parser.add_option(
        '-m',
        '--mute',
        action='store_true',
        dest='mute',
        default=False,
        help='mute the main audio channel')
    parser.add_option(
        '-c',
        '--change',
        type='int',
        dest='percent',
        help='increase or decrease volume by given percentage')
    parser.add_option(
        '-p',
        '--pcm',
        action='store_true',
        dest='pcm',
        default=False,
        help='change PCM channel (default is MASTER)')
    parser.add_option(
        '-q',
        '--quiet',
        action='store_true',
        dest='quiet',
        help='adjust volume without the progressbar')
    (option, args) = parser.parse_args()

    if option.percent or option.mute:
        volume = AlsaMixer(option.pcm, option.mute, option.percent)
    elif option.quiet:
        raise SystemExit(
            AlsaMixer(
                option.pcm,
                option.mute,
                option.percent).label)
    elif option.status:
        volume = AlsaMixer(option.pcm)
    else:
        raise SystemExit(
            "Unknown option, use --help to get explanations for these:\n\n\t%s"
            % parser.get_usage())

    Pvol(volume.percent, volume.label)
    gtk.main()
    return 0


if __name__ == "__main__":
    main()
# VTwitchBot
VTwitchBot is a Twitch chat bot written in the language [V](https://github.com/vlang/v)

## Features
The bot is able to:
* connect to Twitch chat rooms
* receive messages (only command handle at the moment)
* handle commands

## TODO
* moderate chat
* split up in two modules (irc and twitchbot)
* interface for handling messages
* async message reading

## Installation
```
v install prooxeydev.vtwitchbot
```

## Example
```
import vtwitchbot

fn main() {
    commandmap := {
        '!help': 'This is help'
    }

    mut twitchbot := vtwitchbot.TwitchBot{
        oauth: 'oauth:<token>'
        nick: '<botusername>'
        channel: ['<channelname>']
        commandmap: commandmap
    }
    twitchbot.connect()
}
```
